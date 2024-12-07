# coys

The point of this repository is to explore all data related to Tottenham Hotspur.  coys is short for come on your spurs.

I have an initial process to get `fbref` data for English Premier League (EPL) matches. The workflow file run_daily.yml is scheduled to run daily at 12:00 UTC. The workflow file is located in the `.github/workflows` directory.  It runs the `epl_data_capture.R` file to get weekly stats for all 

I am planning work with a GitHub project [here](https://github.com/users/mleary/projects/5/views/1)

## setup

1. First you need to clone the repo
   
```sh
git clone https://github.com/mleary/coys.git
```

2. This script depends on having a .Renviron with the following variables:

```
AZURE_STORAGE_ACCOUNT={azure storage account name}
AZURE_STORAGE_ACCESS_KEY={azure storage access key}
AZURE_EPL_CONTAINER={azure container name}
EPL_DB_NAME={duckdb database name}

```

3. If using GitHub workflow, you need to add the .Renviron variables to GitHub repo secrets as well. Note, this also assumes you have an azure blob storage container to host your duckdb database.
