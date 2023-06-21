# General --------------------

collect_news <- function(commits, no_change_message = NULL) {
  if (fledge_chatty()) {
    cli_alert("Digesting messages from {.field {nrow(commits)}} commits.")
  }

  treat_message <- function(commit_df) {
    default_newsworthy <- commit_df$message %>%
      gsub("\r\n", "\n", .) %>%
      purrr::discard(~ . == "") %>%
      purrr::map_chr(remove_housekeeping) %>%
      purrr::map(extract_newsworthy_items)

    if (nrow(default_newsworthy[[1]]) > 0) {
      return(default_newsworthy[[1]])
    }

    if (commit_df$merge) {
      tibble::tibble(
        description = commit_df$message,
        type = default_type(),
        breaking = FALSE,
        scope = NA
      )
    } else {
      NULL
    }
  }

  newsworthy_items <- split(commits, seq_len(nrow(commits))) %>%
    purrr::map(treat_message) %>%
    purrr::keep(~ !is.null(.)) %>%
    bind_rows()

  if (is.null(newsworthy_items)) {
    if (is.null(no_change_message)) {
      if (nrow(commits) <= 1) {
        no_change_message <- same_as_previous()
      } else {
        no_change_message <- internal_changes_only()
      }
    }

    newsworthy_items <- parse_bullet_commit(sprintf("- %s", no_change_message))
    if (fledge_chatty()) cli_alert_info(no_change_message)
  } else {
    if (fledge_chatty()) {
      no <- nrow(newsworthy_items)
      entry_word <- if (no == 1) "entry" else "entries"
      cli_alert_success("Found {.val {no}} NEWS-worthy {entry_word}.")
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
    return(parse_merge_commit(message))
  }

  # Conventional commits messages
  if (is_conventional_commit(message)) {
    return(parse_conventional_commit(message))
  }

  # Bullets messages
  # There can be several bullets per message!
  parse_bullet_commit(message)
}

# Bullet commits ------

parse_bullet_commit <- function(message) {
  message_lines <- strsplit(message, "\n", fixed = TRUE)[[1]]
  bullets <- purrr::keep(message_lines, is_bullet_message)
  bullets <- trimws(sub(bullet_pattern(), "", bullets))

  meta <- parse_squash_info(message)
  if (!is.null(meta["pr"])) {
    bullets <- trimws(sub(sprintf("\\(%s\\)", meta["pr"]), "", bullets))
  }

  if (!is.null(meta)) {
    description <- sprintf("%s (%s).", bullets, toString(meta))
  } else {
    description <- bullets
  }

  tibble::tibble(
    description = description,
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

# Conventional commits -----
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

default_type <- function() {
  "Uncategorized"
}

translate_type <- function(type) {
  standard <- names(conventional_commit_types())[conventional_commit_types() == tolower(type)]

  if (length(standard) > 0) {
    standard
  } else {
    type
  }
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

  description <- add_squash_info(description)

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

# Squash commits ------

author_pattern <- function() {
  "^Co-authored-by:"
}

parse_squash_info <- function(description) {
  description_lines <- strsplit(description, "\n")[[1]]
  author_lines <- description_lines[grepl(author_pattern(), description_lines)]
  authors <- rematch2::re_match(author_lines, "<.*@users.noreply.github.com>")$.match
  authors <- stats::na.omit(authors)

  if (length(author_lines) == 0 || length(authors) == 0) {
    return(NULL)
  }

  authors <- sub("^<", "", authors)
  authors <- sub("@.*", "", authors)

  meta <- sprintf("@%s", authors)

  # If there are co-authors, this is a merge commit so use its syntax
  pr <- rematch2::re_match(description_lines[1], "(#[0-9]*)")$.match
  if (!is.na(pr)) {
    meta <- c(meta, "pr" = pr)
  }

  meta
}

add_squash_info <- function(description) {
  description_lines <- strsplit(description, "\n")[[1]]

  meta <- parse_squash_info(description)
  if (!is.null(meta["pr"])) {
    description_lines[1] <- trimws(sub(sprintf("\\(%s\\)", meta["pr"]), "", description_lines[1]))
  }

  description <- trimws(paste(description_lines[!grepl(author_pattern(), description_lines)], collapse = "\n"))

  if (!is.null(meta)) {
    sprintf("%s (%s)", description, toString(meta))
  } else {
    description
  }
}

# Merge commits -----

parse_merge_commit <- function(message) {
  pr_data <- harvest_pr_data(message)
  pr_number <- pr_data$pr_number
  pr_numbers <- toString(c(unlist(pr_data$issue_numbers), paste0("#", pr_number)))

  title <- if (is.na(pr_data$title)) {
    sprintf("- PLACEHOLDER https://github.com/%s/pull/%s", github_slug(), pr_number)
  } else {
    pr_data$title
  }
  ctb <- if (is.na(pr_data$external_ctb)) {
    ""
  } else {
    sprintf("@%s, ", pr_data$external_ctb)
  }

  description <- sprintf("%s (%s%s).", title, ctb, pr_numbers)

  if (is_conventional_commit(title)) {
    return(parse_conventional_commit(description))
  } else {
    return(parse_bullet_commit(description))
  }
}


is_merge_commit <- function(message) {
  grepl("^Merge pull request #([0-9]*) from", message)
}

harvest_pr_data <- function(message) {
  check_gh_pat(NULL)

  pr_number <- regmatches(message, regexpr("#[0-9]*", message))
  pr_number <- sub("#", "", pr_number)

  slug <- github_slug()
  org <- sub("/.*", "", slug)
  repo <- sub(".*/", "", slug)

  failure_message <- sprintf("Could not get title for PR #%s", pr_number)

  if (!has_internet()) {
    cli::cli_alert_warning("{failure_message} (no internet connection)")
    pr_info <- NULL
    issue_info <- NULL
  } else {
    pr_info <- tryCatch(
      {
        # suppressMessages() for quiet mocking
        suppressMessages(
          gh(glue("GET /repos/{slug}/pulls/{pr_number}"))
        )
      },
      error = function(e) {
        print(e)
        cli::cli_alert_warning(failure_message)
        return(NULL)
      }
    )
    issue_info <- tryCatch(
      {
        # suppressMessages() for quiet mocking
        suppressMessages(gh::gh_gql(
          sprintf(
            '{
  repository(owner: "%s", name: "%s") {
    pullRequest(number: %s) {
      id
      closingIssuesReferences(first: 50) {
        edges {
          node {
            number
            repository {
              nameWithOwner
            }
          }
        }
      }
    }
  }
}',
            org, repo, pr_number
          )
        ))
      },
      error = function(e) {
        print(e)
        cli::cli_alert_warning("Could not get linked issues for PR #{.val {pr_number}}")
        return(NULL)
      }
    )
  }

  pr_sender <- pr_info$head$repo$owner$login

  external_ctb <- NA_character_
  if (!is.null(pr_sender)) {
    repo_owner <- sub("/.*", "", github_slug(get_remote_name()))
    if (pr_sender != repo_owner) {
      external_ctb <- pr_sender
    }
  }

  format_linked_issue <- function(x, slug) {
    issue_repo <- x$node$repository$nameWithOwner
    repo <- if (issue_repo == slug) {
      ""
    } else {
      issue_repo
    }

    paste0(repo, "#", x$node$number)
  }
  issue_numbers <- purrr::map_chr(
    issue_info$data$repository$pullRequest$closingIssuesReferences$edges,
    format_linked_issue, github_slug(get_remote_name())
  )

  tibble::tibble(
    title = pr_info$title %||% NA_character_,
    pr_number = pr_number,
    issue_numbers = list(issue_numbers),
    external_ctb = external_ctb,
  )
}

has_internet <- function() {
  # impossible as fledge imports httr2 that imports curl :-)
  if (!rlang::is_installed("curl")) {
    return(FALSE)
  }
  if (nzchar(Sys.getenv("FLEDGE_YES_INTERNET_TEST"))) {
    return(TRUE)
  }
  if (nzchar(Sys.getenv("FLEDGE_NO_INTERNET_TEST"))) {
    return(FALSE)
  }
  curl::has_internet()
}

same_as_previous <- function() {
  "Same as previous version."
}

internal_changes_only <- function() {
  "Internal changes only."
}

added_changelog <- function() {
  # same as in usethis
  "Added a `NEWS.md` file to track changes to the package."
}
