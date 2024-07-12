#' Run PubMed Search
#'
#' This function fetches papers from PubMed database using the provided search parameters.
#' After fetching the data from PubMed, the collected papers are added to the provided search instance.
#'
#' @param search A search instance.
#' @export
run <- function(search) {
  if (!is.null(search$publication_types) && !"journal" %in% search$publication_types) {
    message("Skipping PubMed search, journal publication type not in filters. Currently, PubMed only retrieves papers published in journals.")
    return()
  }
  
  papers_count <- 0
  result <- get_api_result(search)
  
  total_papers <- if (!is.null(result$eSearchResult$ErrorList)) {
    0
  } else {
    as.numeric(result$eSearchResult$Count)
  }
  
  message("PubMed: ", total_papers, " papers to fetch")
  
  while (papers_count < total_papers && !search$reached_its_limit(DATABASE_LABEL)) {
    for (pubmed_id in result$eSearchResult$IdList$Id) {
      if (papers_count >= total_papers || search$reached_its_limit(DATABASE_LABEL)) {
        break
      }
      
      papers_count <- papers_count + 1
      
      try({
        paper_entry <- get_paper_entry(pubmed_id)
        
        if (!is.null(paper_entry)) {
          paper_title <- get_text_recursively(paper_entry$PubmedArticleSet$PubmedArticle$MedlineCitation$Article$ArticleTitle)
          
          message("(", papers_count, "/", total_papers, ") Fetching PubMed paper: ", paper_title)
          
          publication <- get_publication(paper_entry)
          paper <- get_paper(paper_entry, publication)
          
          if (!is.null(paper)) {
            paper$database <- DATABASE_LABEL
            search$add_paper(paper)
          }
        }
      }, silent = TRUE)
    }
    
    if (papers_count < total_papers && !search$reached_its_limit(DATABASE_LABEL)) {
      result <- get_api_result(search, papers_count)
    }
  }
}
