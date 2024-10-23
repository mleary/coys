source("renv/activate.R")
#author: Matt Leary
#date: 08/13/2020
#intent: basic customization for my RStudio sessions

if (interactive()) {
    ############################################
    #            Set session options           #
    ############################################
    options(scipen=99)		# disable scientific notation
    options(digits = 4)		# limit digits as much as possible


    ############################################
    #          load package function           #
    ############################################

    load_pkg <- function(pkg) {
      if(!suppressWarnings(suppressMessages(require(pkg, character.only = TRUE)))) {
        message(paste0("You should install the `", pkg, "` package"))
      } else {
        message(paste0("The`", pkg, "` package has been loaded"))
      }  
    }


    ############################################
    #  Print Message that .Rprofile is loaded  #
    #       and add message about changes      #
    ############################################

    message(
"***********************************************************
    Loading Matt's .Rprofile
        Custom Settings:
          * Scientific Notation display is disabled 
          * Digits = 2

    Current Working Directory is:
        -", getwd()," \n"
    )                     # print changes & working directory

    #load_pkg("fcuk")      # Loading to catch typos
    # I stopped loading due to issues with packages and checkpoint + the fact I wasn't using it as much.
    # Leaving here for now, in case I come back to it.

    ###### Console prompt chnages
    if(requireNamespace("prompt", quietly = TRUE)) {
      prompt_git <- function(...){
        paste0(
          "[", prompt::git_branch(), "]",
          " > "
        )
      }

      if(prompt::prompt_git() == "> "){
        prompt::set_prompt("[no git] >")
      } else {
        prompt::set_prompt(prompt_git) 
      }

    } else {
      message("\nHi Matt! You should install the {prompt} package.")
      message("    devtools::install_github('gaborcsardi/prompt')")
    }
    ###### Closing message sign off
    message("
    Cheers!
***********************************************************\n")

    ############################################
    #     remove load package function         #
    ############################################
    rm(load_pkg, prompt_git)
  
}
