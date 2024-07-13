#' Get Publication
#'
#' Using a paper entry provided, this function builds a publication instance.
#'
#' @param paper_entry A paper entry retrieved from PubMed API.
#'
#' @return A publication instance.
#' @export
get_publication <- function(paper_entry) {
  article <- paper_entry$PubmedArticleSet$PubmedArticle$MedlineCitation$Article
  publication_title <- article$Journal$Title[[1]]
  
  if (is.null(publication_title) || length(publication_title) == 0) {
    return(NULL)
  }
  
  publication_issn <- article$Journal$ISSN[[1]]
  
  publication <- list(
    title = publication_title,
    issn = publication_issn,
    type = "Journal"
  )
  
  return(publication)
}
