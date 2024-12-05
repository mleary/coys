
load_config <- function() {
  config <- list(
    azure_storage_account = Sys.getenv("AZURE_STORAGE_ACCOUNT"),
    azure_storage_access_key = Sys.getenv("AZURE_STORAGE_ACCESS_KEY"),
    epl_db_name = Sys.getenv("EPL_DB_NAME"),
    azure_epl_container = Sys.getenv("AZURE_EPL_CONTAINER")
  )

  # Identify missing variables
  missing_vars <- names(config)[
    sapply(config, function(x) is.null(x) || x == "")
  ]

  # Stop execution if any variables are missing
  if (length(missing_vars) > 0) {
    stop(
      "The following required variables aren't importing from the .Renviron file: ",
      paste(missing_vars, collapse = ", ")
    )
  }

  # Return the configuration list
  return(config)
}


connect_to_azure_container <- function(storage_acct, access_key, container) {

  # Connect to the Azure Blob Storage container
  endpoint <- AzureStor::storage_endpoint(
    endpoint = storage_acct,
    key = access_key
  )

  container_connection <- AzureStor::storage_container(
    endpoint = endpoint,
    name = container
  )
  return(container_connection)
}


download_from_azure_container <- function(container_conn, storage_name) {
  # Download the storage file from Azure container
  AzureStor::storage_download(
    container = container_conn,
    src = storage_name,
    dest = storage_name
  )
}


upload_to_azure_container <- function(container_conn, storage_name) {
  # Upload the storage file to Azure container
  AzureStor::storage_upload(
    container = container_conn,
    src = storage_name,
    dest = storage_name
  )
}