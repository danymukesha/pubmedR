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
  url <- get_search_url(search, start_record) |>
    stringr::str_replace_all(" ", "+")
  response <- httr2::request(url) |>
    httr2::req_perform()
  result <- httr2::resp_body_xml(response)
  
  return(result)
}
