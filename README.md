# coys

The point of this repository is to explore all data related to Tottenham Hotspur.  coys is short for come on your spurs.

## Current Process
* I have an initial process to get `fbref` data for English Premier League (EPL) matches. The workflow file run_daily.yml is scheduled to run daily at 12:00 UTC. The workflow file is located in the `.github/workflows` directory.  It runs the `weekly_data_capture.R` file to get weekly stats for all EPL teams.  Intent is to gather raw data for now and add refined data in the coming weeks.

## TODO
* Clean up process to get raw data in `weekly_data_capture.R` that is rough POC code
* Set up a project in GitHub to track tasks
* I Need to swap out saving files locally and move to Azure storage. This could speed up Github actions since current duckdb install takes a long time
* Much more
