update_news_impl <- function(range) {
  news <- collect_news(range)

  ui_info("Adding new entries to {ui_path('NEWS.md')}")
  add_to_news(news)
}

collect_news <- function(range) {
  ui_info("Scraping {ui_value(length(range))} commit messages")

  messages <- gsub("\r\n", "\n", map_chr(range, "message"))
  messages_before_triple_dash <- map_chr(strsplit(messages, "\n---", fixed = TRUE), 1)
  message_lines <- strsplit(messages_before_triple_dash, "\n", fixed = TRUE)
  message_bullets <- map(message_lines, keep, ~ grepl("^[*-]", .))

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
  enc::transform_lines_enc(news_path, make_prepend(news))
  invisible(news_path)
}

make_prepend <- function(news) {
  force(news)
  function(x) {
    c(news, x)
  }
}

edit_news <- function() {
  edit_file(news_path)
}
