#' Get Paper Entry
#'
#' This function returns paper data from PubMed database using the provided PubMed ID.
#'
#' @param pubmed_id A PubMed ID.
#'
#' @return A paper entry from PubMed database.
#' @export
get_paper_entry <- function(pubmed_id) {
  url <- paste0(
    BASE_URL,
    "/entrez/eutils/efetch.fcgi?db=pubmed&id=",
    pubmed_id,
    "&rettype=abstract"
  )
  response <- httr::GET(url)
  content <- content(response, as = "text")
  result <- xml2::as_list(xml2::read_xml(content))
  
  return(result)
}
