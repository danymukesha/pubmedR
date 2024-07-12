#' Get Search URL
#'
#' This function returns the URL to be used to retrieve data from PubMed database.
#' See https://www.ncbi.nlm.nih.gov/books/NBK25500/ for query tips.
#'
#' @param search A search instance.
#' @param start_record Sequence number of the first record to fetch, by default 0.
#'
#' @return A URL to be used to retrieve data from PubMed database.
#' @export
get_search_url <- function(search, start_record = 0) {
  query <- gsub(" AND NOT ", " NOT ", search$query)
  query <- stringr::str_replace_all(query, '\"', '\"[TIAB]')
  
  url <- paste0(BASE_URL, "/entrez/eutils/esearch.fcgi?db=pubmed&term=", query,
                " AND has abstract [FILT] AND \"journal article\"[Publication Type]")
  
  if (!is.null(search$since) || !is.null(search$until)) {
    since <- if (is.null(search$since)) as.Date("0001-01-01") else search$since
    until <- if (is.null(search$until)) Sys.Date() else search$until
    url <- paste0(url, " AND ", format(since, "%Y/%m/%d"), ":", format(until, "%Y/%m/%d"), "[Date - Publication]")
  }
  
  if (!is.null(start_record)) {
    url <- paste0(url, "&retstart=", start_record)
  }
  
  url <- paste0(url, "&retmax=", MAX_ENTRIES_PER_PAGE, "&sort=pub+date")
  
  return(url)
}
