
#' Read expansion planning options
#' 
#' \code{read_options} is a function which read the options related to the
#' expansion planning optimization. The options are stored in the file 
#' antaresStudyPath/user/expansion/settings.ini.
#' 
#' @param opts
#'   list of simulation parameters returned by the function
#'   \code{antaresRead::setSimulationPath}
#'
#' @return 
#' Returns a list containing the different optimisation options 
#' 
#' @import assertthat antaresRead
#' @export
#' 
#' 
#' 
read_options <- function(opts = simOptions())
{
  option_file_name <- paste(opts$studyPath,"/user/expansion/settings.ini",sep="")
  assert_that(file.exists(option_file_name))
  assert_that(file.info(option_file_name)$size !=0)
  
  # read file
  param_data <- scan(option_file_name, what=character(), sep="/", quiet = TRUE)
  
  # initiate option list, with default values
  options <- list()
  options$method <- "benders_decomposition"
  options$uc_type <- "fast"
  options$master <- "integer"
  options$optimality_gap <- 0
  options$max_iteration <- Inf
  options$cut_type <- "average"
  options$week_selection <- TRUE
  options$relaxed_optimality_gap <- "0.01%"

  # go through every line of the file
  for(line in 1:length(param_data))
  {
    # read option and value
    option_name <- strsplit(param_data[line], "=")[[1]][1]
    if(option_name == ""){next} # empty line
    
    option_value <- strsplit(param_data[line], "=")[[1]][2]
    
    # remove white spaces in the beginning and the end
    option_name <- sub("^\\s+", "", option_name)
    option_name <- sub("\\s+$", "", option_name)
    option_value <- sub("^\\s+", "", option_value)
    option_value <- sub("\\s+$", "", option_value)
    
    # see what option it is referring to
    if (option_name == "method")
    {
      assert_that(option_value %in% c("benders_decomposition"))
      options$method <- option_value
    }
    else if (option_name == "uc_type")
    {
      assert_that(option_value %in% c("accurate", "fast", "relaxed_fast"))
      options$uc_type <- option_value
    }
    else if (option_name == "master")
    {
      assert_that(option_value %in% c("integer", "relaxed", "full_integer"))
      options$master <- option_value
    }
    else if (option_name == "optimality_gap")
    {
      # if the value is numeric, it is the optimality gap in euros
      if (!is.na(suppressWarnings(as.numeric(option_value)))) 
      {
        options$optimality_gap <- as.numeric(option_value)

      }
      # else, the optimality gap is in % of the best found solution
      else
      {
        option_value <- gsub(" ", "", option_value, fixed = TRUE)
        assert_that(grepl("%$", option_value))
        option_value_bis <- gsub("%$", "", option_value) 
        assert_that(!is.na(as.numeric(option_value_bis)))
        options$optimality_gap <- option_value
      }
    }
    else if (option_name == "max_iteration")
    {
      assert_that(!is.na(as.numeric(option_value)))
      options$max_iteration <- round(as.numeric(option_value))
    }
    else if (option_name == "cut_type")
    {
      assert_that(option_value %in% c("average", "yearly", "weekly"))
      options$cut_type <- option_value
    }
    else if (option_name == "week_selection")
    {
      assert_that(option_value %in% c("true", "false"))
      options$week_selection <- as.logical(option_value)
    }
    else if (option_name == "relaxed_optimality_gap")
    {
      # if the value is numeric, it is the optimality gap in euros
      if (!is.na(suppressWarnings(as.numeric(option_value)))) 
      {
        options$relaxed_optimality_gap <- as.numeric(option_value)
        
      }
      # else, the optimality gap is in % of the best found solution
      else
      {
        option_value <- gsub(" ", "", option_value, fixed = TRUE)
        assert_that(grepl("%$", option_value))
        option_value_bis <- gsub("%$", "", option_value) 
        assert_that(!is.na(as.numeric(option_value_bis)))
        options$relaxed_optimality_gap <- option_value
      }
      
    }
    else
    {
      warning(paste0("Unknown option : ", option_name))
    }
  }
  
  return(options)
}
