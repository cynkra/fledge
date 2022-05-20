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

  newsworthy_items <- messages %>%
    gsub("\r\n", "\n", .) %>%
    purrr::discard(~ . == "") %>%
    purrr::map_chr(remove_housekeeping) %>%
    purrr::map(extract_newsworthy_items) %>%
    unlist()

  if (length(newsworthy_items) == 0) {
    if (length(messages) <= 1) {
      newsworthy_items <- "- Same as previous version."
      if (fledge_chatty()) cli_alert_info("Same as previous version.")
    } else {
      newsworthy_items <- "- Internal changes only."
      if (fledge_chatty()) cli_alert_info("Internal changes only.")
    }
  } else {
    if (fledge_chatty()) {
      no <- length(newsworthy_items)
      entry_word <- if (no == 1) "entry" else "entries"
      cli_alert_success(sprintf("Found %s NEWS-worthy %s.", no, entry_word))
    }
  }

  paste0(paste(newsworthy_items, collapse = "\n"), "\n\n")
}

remove_housekeeping <- function(message) {
  strsplit(message, "\n---", fixed = TRUE)[[1]][1]
}

extract_newsworthy_items <- function(message) {
  if (is_merge_commit(message)) {
    pr_data <- harvest_pr_data(message)
    pr_number <- pr_data$pr_number
    title <- pr_data$title %||% sprintf("PLACEHOLDER https://github.com/%s/pull/%s", github_slug(), pr_number)

    if (is_conventional_commit(title)) {
      return(parse_conventional_commit(title))
    } else {
      return(sprintf("- %s", title))
    }
  }

  if (is_conventional_commit(message)) {
    return(parse_conventional_commit(message))
  }

  # There can be several bullets per message!
  message_lines <- strsplit(message, "\n", fixed = TRUE)
  purrr::map(message_lines, purrr::keep, ~ grepl("^[*-]", .))
}

conventional_commit_header_pattern <- function() {
  # Type is a noun
  # There can be a scope
  # Compulsory space after the colon
  "^[A-Za-z]*(\\(.*\\))?!?:[[:space:]]"
}

is_conventional_commit <- function(message) {
  grepl(conventional_commit_header_pattern(), message)
}

parse_conventional_commit <- function(message) {
  type_matches <- regexpr(conventional_commit_header_pattern(), message)
  header <- regmatches(message, type_matches)

  type <- sub("(\\(.*\\))?!?:[[:space:]]$", "", header)
  type <- translate_type(type)

  scope <- regmatches(header, regexpr("(\\(.*\\))", header))
  scope <- gsub("[\\(\\)]", "", scope)
  scope_header <- if (length(scope) == 0) NULL else c(sprintf("### %s", scope), "")

  description <- sub(header, "", message, fixed = TRUE)

  breaking <- grepl("!:", header)
  breaking_prefix <- if (breaking) {
    "Breaking change: "
  } else {
    ""
  }
  breaking_section <- if (breaking) {
    c("", "## Breaking changes", "", scope_header, description)
  } else {
    ""
  }
  # TODO: parse body, trailer.

  c(
    "",
    sprintf("## %s", type),
    "",
    scope_header,
    sprintf("%s%s", breaking_prefix, description),
    breaking_section
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

translate_type <- function(type) {
  if (type %in% conventional_commit_types()) {
    names(conventional_commit_types())[conventional_commit_types() == type]
  } else {
    type
  }
}

conventional_commit_types <- function() {
  c(
    "Bug fixes" = "fix",
    "Features" = "feat",
    "Build system, external dependencies" = "build",
    "Chore" = "chore",
    "Continuous integration" = "ci",
    "Documentation" = "docs",
    "Code style" = "style",
    "Refactoring" = "refactor",
    "Performance" = "perf",
    "Testing" = "test"
  )
}

is_merge_commit <- function(message) {
  grepl("^Merge pull request #([0-9]*) from", message)
}

harvest_pr_data <- function(message) {
  pr_number <- regmatches(message, regexpr("#[0-9]*", message))
  pr_number <- sub("#", "", pr_number)
  slug <- github_slug()

  pr_info <- if (!has_internet()) {
    NULL
  } else {
    tryCatch(
      {
        gh::gh(glue("GET /repos/{slug}/pulls/{pr_number}"))
      },
      error = function(e) {
        print(e)
        cli::cli_alert_warning(sprintf("Could not get title for PR #%s", pr_number))
        return(NULL)
      }
    )
  }

  tibble::tibble(
    title = pr_info$title,
    pr_number = pr_number
  )
}

has_internet <- function() {
  if (nzchar(Sys.getenv("NO_INTERNET_TEST_FLEDGE"))) {
    return(FALSE)
  }
  curl::has_internet()
}
