update_news_impl <- function(messages) {
  news <- collect_news(messages)

  if (fledge_chatty()) {
    cli_h2("Updating NEWS")
    cli_alert("Adding new entries to {.file {news_path()}}.")
  }

  add_to_news(news)
}

collect_news <- function(messages) {
  if (fledge_chatty()) {
    cli_alert("Scraping {.field {length(messages)}} commit messages.")
  }

  message_items <- messages %>%
    gsub("\r\n", "\n", .) %>%
    purrr::discard(~ . == "") %>%
    purrr::map_chr(remove_housekeeping) %>%
    purrr::map(extract_newsworthy_items) %>%
    unlist()

  if (length(message_items) == 0) {
    if (length(messages) <= 1) {
      message_items <- "- Same as previous version."
    } else {
      message_items <- "- Internal changes only."
    }
  }

  if (fledge_chatty()) {
    cli_alert_success("Found {.field {length(message_items)}} NEWS-worthy entries.")
  }

  paste0(paste(message_items, collapse = "\n"), "\n\n")
}

remove_housekeeping <- function(message) {
  strsplit(message, "\n---", fixed = TRUE)[[1]][1]
}

extract_newsworthy_items <- function(message) {
  if (is_conventional_commit(message)) {
    return(parse_conventional_commit(message))
  }

  # There can be several bullets per message!
  message_lines <- strsplit(message, "\n", fixed = TRUE)
  purrr::map(message_lines, purrr::keep, ~ grepl("^[*-]", .))
}

is_conventional_commit <- function(message) {
  grepl(".*:", message)
}

parse_conventional_commit <- function(message) {
  header <- sub(":.*", "", message)
  rest <- sub(sprintf("%s:", header), "", message)
  # TODO: parse body, trailer.

  c(
    sprintf("## %s", header),
    rest
  )
}

news_path <- function() {
  "NEWS.md"
}

news_comment <- function() {
  "<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->"
}

add_to_news <- function(news) {
  if (!file.exists(news_path())) {
    file.create(news_path())
  }

  enc::transform_lines_enc(news_path(), make_prepend(news))
  invisible(news_path())
}

make_prepend <- function(news) {
  force(news)

  function(x) {
    # Not empty news file needs to be tweaked
    if (length(x) > 0) {
      # Remove fledge NEWS.md comment
      if (x[[1]] == news_comment()) {
        x <- x[-1]
        # Remove empty line at the top
        if (x[[1]] == "") {
          x <- x[-1]
        }
      }
    }

    c(news_comment(), "", news, x)
  }
}


edit_news <- function() {
  local_options(usethis.quiet = TRUE)
  edit_file(news_path())
}

edit_cran_comments <- function() {
  local_options(usethis.quiet = TRUE)
  edit_file("cran-comments.md")
}
