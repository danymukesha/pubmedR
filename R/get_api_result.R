#' Get API Result
#'
#' This function returns results from PubMed database using the provided search parameters.
#'
#' @param search A search instance.
#' @param start_record Sequence number of the first record to fetch, by default 0.
#'
#' @return A result from PubMed database.
#' @export
get_api_result <- function(search, start_record = 0) {
  url <- get_search_url(search, start_record)
  response <- httr::GET(url)
  content <- content(response, as = "text")
  result <- xml2::as_list(read_xml(content))
  
  return(result)
}
