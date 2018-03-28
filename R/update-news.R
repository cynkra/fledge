#' @import purrr
NULL

update_news_impl <- function(range) {
  news <- collect_news(range)
  add_to_news(news)
}

collect_news <- function(range) {
  messages <- map_chr(range, "message")
  messages_before_triple_dash <- map_chr(strsplit(messages, "\n---", fixed = TRUE), 1)
  message_lines <- strsplit(messages_before_triple_dash, "\n", fixed = TRUE)
  message_bullets <- map(message_lines, keep, ~grepl("^[*-]", .))
  paste0(paste(unlist(message_bullets), collapse = "\n"), "\n\n")
}

add_to_news <- function(news) {
  news_path <- "NEWS.md"
  old_news <- readLines(news_path)
  writeLines(c(news, old_news), news_path)
}
