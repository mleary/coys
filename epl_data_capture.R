# Title: epl_data_capture.R
# Description: Initial attempt to capture weekly English Premiere League data
#              so I can make charts and do analysis on Tottenham Hotspur
# Intent: I wanted to keep this simple and not overly documented since it will
#         not be updated regularly.  This script loads packages, and then uses
#         the worldfootballR package to capture data from the fbref website.
#         The stat types are ones provided natively by fbref.
# Author:  Matt Leary
# Date Created: 2024-10-23
# Last Modified: 2024-12-03


# Load packages ===============================================================
library(worldfootballR)
library(duckdb)
library(DBI)
library(dplyr)
library(AzureStor)

source('./utils/functions.R')


# Prep local environment: Load config, connect azure, download DB =============
config <- load_config()

container_connection <- connect_to_azure_container(
  storage_acct = config$azure_storage_account,
  access_key = config$azure_storage_access_key, 
  container = config$azure_epl_container
)

download_from_azure_container(container_connection, config$epl_db_name)

# List of stat types to capture ===============================================
stat_types <- c("league_table", "league_table_home_away", "standard", "keeper",
                "keeper_adv", "shooting", "passing", "passing_types",
                "goal_shot_creation", "defense", "possession", "misc")


# Supporting functions =========================================================

get_team_stats <- function(stat_type) {
  tryCatch({
    data <- fb_season_team_stats(
      country = "ENG",
      gender = "M",
      season_end_year = "2025",
      tier = "1st",
      stat_type = stat_type
    ) %>%
      janitor::clean_names()

    return(data)
  }, error = function(e) {
    message(paste("Error fetching data for stat_type:", stat_type))
    NULL  # Return NULL if there's an error
  })
}


write_team_stats_to_db <- function(team_stats, stat_type, db_name) {

  # Connect to the DuckDB database
  con <- dbConnect(duckdb(), dbdir = db_name, read_only = FALSE) # nolint
  on.exit(dbDisconnect(con), add = TRUE)  # Ensure the connection is closed

  # Add timestamp column to team_stats
  team_stats$timestamp <- Sys.time()

  # Check if the table exists
  if (!dbExistsTable(con, stat_type)) {
    # Create the table and insert all data
    dbWriteTable(con, stat_type, team_stats)
    return(paste('New Table added:', nrow(team_stats), "for", stat_type))
  } else {
    # Read existing data from the table
    existing_data <- dbReadTable(con, stat_type)

    # Exclude 'timestamp' from the columns used for the anti_join
    join_cols <- setdiff(colnames(team_stats), 'timestamp')
    
    # Identify new rows by performing an anti_join
    new_data <- anti_join(team_stats, existing_data, by = join_cols)

    # Write only the new data to the database
    if (nrow(new_data) > 0) {
      dbWriteTable(con, stat_type, new_data, append = TRUE)
      return(paste("Inserted", nrow(new_data), 
                    "new rows into table", stat_type))
    } else {
      return(paste("No new data to insert for stat_type:", stat_type))
    }
  }
}



# Capture data for each stat type =============================================
# Intentionally not using TryCatch to let failure send alert email

for (item in stat_types) {
  team_stats <- get_team_stats(item)
  outcome <- write_team_stats_to_db(team_stats, item, config$epl_db_name)
  message(paste("Success writing local DB! Outcome:", outcome, "for:", item))
  upload_to_azure_container(container_connection, config$epl_db_name)
  message(paste("Success writing DB to azure!"))
}


# R Session Info ==============================================================
# platform       aarch64-apple-darwin20      
# arch           aarch64                     
# os             darwin20                    
# system         aarch64, darwin20           
# status                                     
# major          4                           
# minor          4.1                         
# year           2024                        
# month          06                          
# day            14                          
# svn rev        86737                       
# language       R                           
# version.string R version 4.4.1 (2024-06-14)
# nickname       Race for Your Life
# ==============================================================================
