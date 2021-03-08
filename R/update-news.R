update_news_impl <- function(range) {
  news <- collect_news(range)

  cli_h2("Updating NEWS")
  cli_alert("Adding new entries to {.file {news_path}}.")
  add_to_news(news)
}

collect_news <- function(range) {
  cli_alert("Scraping {.field {length(range)}} commit messages.")

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

  cli_alert_success("Found {.field {length(message_items)}} NEWS-worthy entries.")
  paste0(paste(message_items, collapse = "\n"), "\n\n")
}

news_path <- "NEWS.md"
news_comment <- "<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->"

add_to_news <- function(news) {
  enc::transform_lines_enc(news_path, make_prepend(news))
  invisible(news_path)
}

make_prepend <- function(news) {
  force(news)

  function(x) {
    if (x[[1]] == news_comment) {
      x <- x[-1]
      if (x[[1]] == "") {
        x <- x[-1]
      }
    }

    c(news_comment, "", news, x)
  }
}

edit_news <- function() {
  edit_file(news_path)
}
