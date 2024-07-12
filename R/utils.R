#' Try Success
#'
#' This function tries to evaluate an expression multiple times until it succeeds.
#'
#' @param expr An expression to evaluate.
#' @param retries Number of retries.
#' @param pre_delay Delay before each retry.
#'
#' @return The result of the expression.
#' @export
try_success <- function(expr, retries, pre_delay = 0) {
  success <- FALSE
  result <- NULL
  
  for (i in 1:retries) {
    if (pre_delay > 0) Sys.sleep(pre_delay)
    
    try({
      result <- eval(expr)
      success <- TRUE
      break
    }, silent = TRUE)
  }
  
  if (!success) {
    stop("Failed to execute expression successfully after retries.")
  }
  
  return(result)
}

#' Get Numeric Month by String
#'
#' This function converts a month name to its numeric equivalent.
#'
#' @param month_str A month name.
#'
#' @return The numeric equivalent of the month.
#' @export
get_numeric_month_by_string <- function(month_str) {
  match(tolower(month_str), tolower(month.name))
}
