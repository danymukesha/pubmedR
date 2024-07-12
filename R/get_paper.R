#' Get Paper
#'
#' Using a paper entry provided, this function builds a paper instance.
#'
#' @param paper_entry A paper entry retrieved from PubMed API.
#' @param publication A publication instance that will be associated with the paper.
#'
#' @return A paper instance or NULL.
#' @export
get_paper <- function(paper_entry, publication) {
  article <- paper_entry$PubmedArticleSet$PubmedArticle$MedlineCitation$Article
  
  paper_title <- get_text_recursively(article$ArticleTitle)
  
  if (is.null(paper_title) || length(paper_title) == 0) {
    return(NULL)
  }
  
  if (!is.null(article$ArticleDate)) {
    paper_publication_date_day <- article$ArticleDate$Day
    paper_publication_date_month <- article$ArticleDate$Month
    paper_publication_date_year <- article$ArticleDate$Year
  } else {
    paper_publication_date_day <- 1
    paper_publication_date_month <- month(article$Journal$JournalIssue$PubDate$Month, label = TRUE, abbr = FALSE)
    paper_publication_date_year <- article$Journal$JournalIssue$PubDate$Year
  }
  
  paper_doi <- NULL
  paper_ids <- article$PubmedData$ArticleIdList$ArticleId
  for (paper_id in paper_ids) {
    if (is.list(paper_id) && paper_id$`@IdType` == "doi") {
      paper_doi <- paper_id$`#text`
      break
    }
  }
  
  paper_abstract <- NULL
  paper_abstract_entry <- article$Abstract$AbstractText
  if (is.null(paper_abstract_entry)) {
    stop("Paper abstract is empty")
  }
  
  if (is.list(paper_abstract_entry)) {
    paper_abstract <- stringr::str_c(sapply(paper_abstract_entry, get_text_recursively), collapse = "\n")
  } else {
    paper_abstract <- get_text_recursively(paper_abstract_entry)
  }
  
  paper_keywords <- tryCatch({
    sets::set(sapply(article$MedlineCitation$KeywordList$Keyword, get_text_recursively))
  }, error = function(e) {
    sets::set()
  })
  
  paper_publication_date <- tryCatch({
    as.Date(paste(paper_publication_date_year, paper_publication_date_month, paper_publication_date_day, sep = "-"))
  }, error = function(e) {
    if (!is.null(paper_publication_date_year)) {
      as.Date(paste(paper_publication_date_year, 1, 1, sep = "-"))
    } else {
      NULL
    }
  })
  
  if (is.null(paper_publication_date)) {
    return(NULL)
  }
  
  paper_authors <- c()
  retrieved_authors <- if (is.list(article$AuthorList$Author)) article$AuthorList$Author else list(article$AuthorList$Author)
  
  for (author in retrieved_authors) {
    if (is.character(author)) {
      paper_authors <- c(paper_authors, author)
    } else if (is.list(author)) {
      paper_authors <- c(paper_authors, stringr::str_c(author$ForeName, author$LastName, sep = " "))
    }
  }
  
  paper_pages <- NULL
  paper_number_of_pages <- NULL
  try({
    paper_pages <- article$Pagination$MedlinePgn
    if (!is.numeric(paper_pages)) {
      pages_split <- stringr::str_split(paper_pages, "-")
      paper_number_of_pages <- abs(as.numeric(pages_split[[1]][1]) - as.numeric(pages_split[[1]][2])) + 1
    }
  }, silent = TRUE)
  
  paper <- list(
    title = paper_title,
    abstract = paper_abstract,
    authors = paper_authors,
    publication = publication,
    publication_date = paper_publication_date,
    doi = paper_doi,
    keywords = paper_keywords,
    number_of_pages = paper_number_of_pages,
    pages = paper_pages
  )
  
  return(paper)
}
