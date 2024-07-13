#' Create a Table from PubMed Output
#'
#' This function takes a list of PubMed records and converts them into a tibble.
#'
#' @param pubmed_records A list of PubMed records or a single PubMed record. Each record should be a list containing the fields: title, abstract, authors, publication (with title, issn, type), publication_date, doi, number_of_pages, pages, and database.
#'
#' @return A tibble containing the key information from the PubMed records.
#'
#' @examples
#' pubmed_record <- list(
#'   title = "Impairment of cognition and sleep after acute ischaemic stroke or transient ischaemic attack in Chinese patients: design, rationale and baseline patient characteristics of a nationwide multicentre prospective registry.",
#'   abstract = "Cognitive impairment and sleep disorder are both common poststroke conditions and are closely related to the prognosis of patients who had a stroke...",
#'   authors = "Yongjun Wang",
#'   publication = list(title = "Stroke and vascular neurology", issn = "2059-8696", type = "Journal"),
#'   publication_date = "2020-07-13",
#'   doi = "10.1136/svn-2020-000359",
#'   number_of_pages = 6,
#'   pages = "139-144",
#'   database = "PubMed"
#' )
#'
#' create_pubmed_table(pubmed_record)
#'
#' @export
create_pubmed_table <- function(pubmed_records) {
  # ensuring that the input is a list of records
  if (!is.list(pubmed_records[[1]])) {
    pubmed_records <- list(pubmed_records)
  }
  
  # Extract relevant information and create a tibble
  records_tbl <- tibble::tibble(
    title = sapply(pubmed_records, `[[`, "title"),
    abstract = sapply(pubmed_records, `[[`, "abstract"),
    authors = sapply(pubmed_records, `[[`, "authors"),
    publication_title = sapply(pubmed_records, function(x) x$publication$title),
    publication_issn = sapply(pubmed_records, function(x) x$publication$issn),
    publication_type = sapply(pubmed_records, function(x) x$publication$type),
    publication_date = sapply(pubmed_records, `[[`, "publication_date"),
    doi = sapply(pubmed_records, `[[`, "doi"),
    number_of_pages = sapply(pubmed_records, `[[`, "number_of_pages"),
    pages = sapply(pubmed_records, `[[`, "pages"),
    database = sapply(pubmed_records, `[[`, "database")
  )
  
  return(records_tbl)
}
