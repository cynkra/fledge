update_news_impl <- function(messages) {
  news_items <- collect_news(messages)
  news_lines <- regroup_news(news_items)

  if (fledge_chatty()) {
    cli_h2("Updating NEWS")
    cli_alert("Adding new entries to {.file {news_path()}}.")
  }

  add_to_news(news_lines)
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
    purrr::keep(~ nrow(.) > 0) %>%
    bind_rows()

  if (is.null(newsworthy_items)) {
    if (length(messages) <= 1) {
      newsworthy_items <- parse_regular_commit("Same as previous version.")
      if (fledge_chatty()) cli_alert_info("Same as previous version.")
    } else {
      newsworthy_items <- parse_regular_commit("Internal changes only.")
      if (fledge_chatty()) cli_alert_info("Internal changes only.")
    }
  } else {
    if (fledge_chatty()) {
      no <- nrow(newsworthy_items)
      entry_word <- if (no == 1) "entry" else "entries"
      cli_alert_success(sprintf("Found %s NEWS-worthy %s.", no, entry_word))
    }
  }

  newsworthy_items
}

remove_housekeeping <- function(message) {
  strsplit(message, "\n---", fixed = TRUE)[[1]][1]
}

extract_newsworthy_items <- function(message) {
  # Merge messages
  if (is_merge_commit(message)) {
    pr_data <- harvest_pr_data(message)
    pr_number <- pr_data$pr_number
    title <- if (is.na(pr_data$title)) {
      sprintf("PLACEHOLDER https://github.com/%s/pull/%s", github_slug(), pr_number)
    } else {
      pr_data$title
    }

    if (is_conventional_commit(title)) {
      return(parse_conventional_commit(title))
    } else {
      description <- sprintf("%s (#%s)", title, pr_number)
      return(parse_regular_commit(description))
    }
  }

  # Conventional commits messages
  if (is_conventional_commit(message)) {
    return(parse_conventional_commit(message))
  }

  # Bullets messages
  # There can be several bullets per message!
  message_lines <- strsplit(message, "\n", fixed = TRUE)
  items <- purrr::map(message_lines, purrr::keep, ~ is_bullet_message(.))
  bind_rows(purrr::map(items, parse_regular_commit))
}

parse_regular_commit <- function(message) {
  tibble::tibble(
    description = trimws(sub(bullet_pattern(), "", message)),
    type = default_type(),
    breaking = FALSE,
    scope = NA
  )
}

bullet_pattern <- function() {
  "^[*-]"
}

is_bullet_message <- function(message) {
  grepl(bullet_pattern(), message)
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
  scope <- if (length(scope) > 0) {
    gsub("[\\(\\)]", "", scope)
  } else {
    NA
  }

  description <- sub(header, "", message, fixed = TRUE)

  breaking <- grepl("!:", header)
  breaking_prefix <- if (breaking) {
    "Breaking change: "
  } else {
    ""
  }
  tibble::tibble(
    description = trimws(sprintf("%s%s", breaking_prefix, description)),
    type = type,
    breaking = breaking,
    scope = scope
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
  standard <- names(conventional_commit_types())[conventional_commit_types() == tolower(type)]

  if (length(standard) > 0) {
    standard
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
  check_gh_pat()

  pr_number <- regmatches(message, regexpr("#[0-9]*", message))
  pr_number <- sub("#", "", pr_number)

  slug <- github_slug()

  failure_message <- sprintf("Could not get title for PR #%s", pr_number)

  pr_info <- if (!has_internet()) {
    cli::cli_alert_warning(sprintf("%s (no internet connection)", failure_message))
    NULL
  } else {
    tryCatch(
      {
        gh::gh(glue("GET /repos/{slug}/pulls/{pr_number}"))
      },
      error = function(e) {
        print(e)
        cli::cli_alert_warning(failure_message)
        return(NULL)
      }
    )
  }

  tibble::tibble(
    title = pr_info$title %||% NA,
    pr_number = pr_number
  )
}

has_internet <- function() {
  if (nzchar(Sys.getenv("NO_INTERNET_TEST_FLEDGE"))) {
    return(FALSE)
  }
  curl::has_internet()
}

check_gh_pat <- function() {
  if (!nzchar(gh::gh_token()) || nzchar(Sys.getenv("FLEDGE_TEST_NO_PAT"))) {
    abort(
      message = c(
        x = "Can't find a GitHub Personal Access Token (PAT).",
        i = 'See for instance `?gh::gh_token` or https://usethis.r-lib.org/reference/github-token.html'
      )
    )
  }
}

default_type <- function() {
  "Uncategorized"
}

regroup_news <- function(news_items) {

  ## Only uncategorized?
  if (isTRUE(all.equal(unique(news_items$type), default_type()))) {
    return(treat_type_items(news_items, header = FALSE))
  }

  # Repeat breaking changes in a distinct section
  breaking <- news_items[news_items$breaking, ]
  breaking$type <- "Breaking changes"
  news_items <- rbind(news_items, breaking)

  news_types <- split(news_items, news_items$type)

  # Order
  types <- names(news_types)
  present_types <- unique(news_items$type)
  standard_types <- c(names(conventional_commit_types()), "Breaking changes", default_type())
  custom_types <- present_types[!(present_types %in% standard_types)]
  types <- factor(types, levels = c(names(conventional_commit_types()), "Breaking changes", custom_types, default_type()))
  order <- order(types)
  news_types <- news_types[order]

  glue::glue_collapse(purrr::map_chr(news_types, treat_type_items), sep = "\n\n")
}

treat_type_items <- function(df, header = TRUE) {
  items <- split(df, seq_len(nrow(df))) %>%
    purrr::map(add_hyphen) %>%
    purrr::map_chr(add_scope) %>%
    glue::glue_collapse(sep = "\n\n")

  if (!header) {
    sprintf("%s\n\n", items)
  } else {
    type <- df$type[1]
    sprintf("## %s \n\n%s\n\n", type, items)
  }
}

add_scope <- function(row) {
  if (is.na(row$scope)) {
    row$description
  } else {
    sprintf("### %s \n\n%s", row$scope, row$description)
  }
}
add_hyphen <- function(row) {
  row$description <- sprintf("- %s", row$description)
  row
}

bind_rows <- function(df_list) {
  do.call(rbind, df_list)
}
