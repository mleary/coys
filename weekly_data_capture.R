# ==============================================================================
# Title: weekly_data_capture.R
# Description: Initial attempt to capture weekly English Premiere League data, so I can make charts and do analysis on Tottenham Hotspur
# Author:  Matt Leary
# Date Created: 2024-10-23
# Last Modified: 2024-10-23
# ==============================================================================

library(worldfootballR)
library(ggplot2)
library(duckdb)
library(DBI)


# Define the function to get team stats
get_team_stats <- function(stat_type) {
  fb_season_team_stats(country = "ENG", gender = "M", season_end_year = "2025", tier = "1st", stat_type = stat_type)
}

write_team_stats_to_db <- function(team_stats, stat_type, db_name = 'weekly_epl_data.duckdb') {
    con <- dbConnect(duckdb(), dbdir = db_name, read_only = FALSE)
    dbWriteTable(con, stat_type, team_stats)
}


# List of stat types
stat_types <- c("league_table", "league_table_home_away", "standard", "keeper", "keeper_adv", "shooting", "passing", "passing_types", "goal_shot_creation", "defense", "possession", "playing_line", "misc")

for (item in stat_types) {
  team_stats <- get_team_stats(item)
  write_team_stats_to_db(team_stats, item)
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
