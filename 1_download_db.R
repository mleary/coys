# Load required packages
library(AzureStor)
library(dotenv)
library(DBI)
library(duckdb)

# Load environment variables
storage_account <- Sys.getenv("STORAGE_ACCOUNT")
access_key <- Sys.getenv("ACCESS_KEY")
endpoint <- storage_endpoint(storage_account, key = access_key)
container <- storage_container(endpoint, "coys-databases")
db_name <- 'weekly_epl_data.duckdb'

# Download the DuckDB database from Azure Blob Storage
storage_download(
  container,
  src = db_name,
  dest = db_name
)
