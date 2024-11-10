# This is a stand alone script that can be run to update all tables
# in the database with a 'timestamp' column.
# I realized I needed to capture this for when stats are updated,
# will run one time but keeping just in case.

library(duckdb)
library(DBI)

db_name <- "weekly_epl_data.duckdb"
con <- dbConnect(duckdb(), dbdir = db_name, read_only = FALSE)

# Get a list of all tables in the database & get system time
tables <- dbListTables(con)
current_time <- Sys.time()
current_time_str <- format(current_time, "%Y-%m-%d %H:%M:%S")

# Loop through each table
for (table_name in tables) {
  # Use dbQuoteIdentifier to safely quote table names
  table_name_quoted <- dbQuoteIdentifier(con, table_name)
  timestamp_col_quoted <- dbQuoteIdentifier(con, 'timestamp')

  # Check if the 'timestamp' column already exists
  columns <- dbListFields(con, table_name)
  if (!"timestamp" %in% columns) {
    # Add the 'timestamp' column as TIMESTAMP with DEFAULT value
    alter_query <- sprintf(
      "ALTER TABLE %s ADD COLUMN %s TIMESTAMP DEFAULT TIMESTAMP '%s';",
      table_name_quoted, timestamp_col_quoted, current_time_str
    )
    dbExecute(con, alter_query)
    message(sprintf("Added 'timestamp' column to table '%s' with value '%s'.", table_name, current_time_str))
  } else {
    message(sprintf("Table '%s' already has a 'timestamp' column.", table_name))
  }
}

# Disconnect from the database
dbDisconnect(con, shutdown = TRUE)
