#' Get Text Recursively
#'
#' This function extracts text from an arbitrary object recursively.
#'
#' @param text_entry An arbitrary object that contains some text.
#'
#' @return The extracted text.
#' @export
get_text_recursively <- function(text_entry) {
  if (is.null(text_entry)) {
    return("")
  }
  if (is.character(text_entry)) {
    return(text_entry)
  } else {
    text <- c()
    items <- if (is.list(text_entry)) text_entry else unlist(text_entry, use.names = FALSE)
    for (item in items) {
      text <- c(text, get_text_recursively(item))
    }
    return(str_c(text, collapse = " "))
  }
}
