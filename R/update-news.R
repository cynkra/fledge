#' @import purrr
NULL

update_news_impl <- function(range) {
  news <- collect_news(range)

  ui_info("Adding new entries to {ui_path('NEWS.md')}")
  add_to_news(news)
}

collect_news <- function(range) {
  ui_info("Scraping {ui_value(length(range))} commit messages")

  messages <- map_chr(range, "message")
  messages_before_triple_dash <- map_chr(strsplit(messages, "\n---", fixed = TRUE), 1)
  message_lines <- strsplit(messages_before_triple_dash, "\n", fixed = TRUE)
  message_bullets <- map(message_lines, keep, ~grepl("^[*-]", .))

  message_items <- unlist(message_bullets)
  if (length(message_items) == 0) {
    if (length(range) <= 1) {
      message_items <- "- Same as previous version."
    } else {
      message_items <- "- Internal changes only."
    }
  }

  ui_done("Found {ui_value(length(message_items))} NEWS-worthy entries.")
  paste0(paste(message_items, collapse = "\n"), "\n\n")
}

news_path <- "NEWS.md"

add_to_news <- function(news) {
  old_news <- safe_read_lines(news_path)
  writeLines(c(news, old_news), news_path)
  invisible(news_path)
}

edit_news <- function() {
  edit_file(news_path)
}

safe_read_lines <- function(path) {
  if (!file.exists(path)) return(character())
  readLines(path)
}
