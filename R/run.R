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
  
  start_record <- 0
  papers_count <- 0
  retry_attempts <- 3  # the number of retry attempts
  all_papers <- list()
  
  repeat {
    result <- tryCatch({
      pubmedr::get_api_result(search, start_record)
    }, error = function(e) {
      message("Error fetching results: ", e$message)
      return(NULL)
    })
    ids <- xml2::xml_find_all(result, ".//Id") |>
      xml2::xml_text()
    
    if (is.null(result)) {
      break
    }
    
    # this check for HTTP 429 for too many requests error
    if (inherits(result, "try-error") && grepl("HTTP 429", result$message)) {
      if (retry_attempts > 0) {
        message("Too Many Requests (HTTP 429). Retrying after 5 seconds...")
        Sys.sleep(5)  # Wait for 5 seconds before retrying
        retry_attempts <- retry_attempts - 1
        next
      } else {
        message("Too Many Requests (HTTP 429). Maximum retry attempts reached. Exiting.")
        break
      }
    }
    
    total_papers <- length(ids) |>
      as.numeric()
    
    message("PubMed: ", total_papers, " papers to fetch")
    
    if (length(ids) == 0) break
    
    for (id in ids) {
      
      if (papers_count >= total_papers || search$reached_its_limit(start_record)) {
        break
      }
      
      papers_count <- papers_count + 1
      try({
        paper_entry <- pubmedr::get_paper_entry(id)
        
        if (!is.null(paper_entry)) {
          paper_title <- pubmedr::get_text_recursively(paper_entry$PubmedArticleSet$PubmedArticle$MedlineCitation$Article$ArticleTitle)
          
          message("(", papers_count, "/", total_papers, ") Fetching PubMed paper: ", paper_title)
          
          publication <- pubmedr::get_publication(paper_entry)
          paper <- pubmedr::get_paper(paper_entry, publication)
          if (!is.null(paper)) {
            paper$database <- "PubMed"
            # search$add_paper(paper)
            if (!is.null(paper)) {
              paper$database <- "PubMed"
              all_papers <- append(all_papers, list(paper))
            }
          }
          articleIdList <- paper_entry$PubmedArticleSet$PubmedArticle$PubmedData$ArticleIdList|> purrr::pluck(-1)
          doi <- articleIdList[[1]]
        }
      }, silent = TRUE)
    }
    
    start_record <- start_record + MAX_ENTRIES_PER_PAGE
    
    if (papers_count >= total_papers ||search$reached_its_limit(start_record)) break
  }
  return(create_pubmed_table(all_papers))
  
}
