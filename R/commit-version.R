commit_version_impl <- function(pull) {
  check_only_staged(c("DESCRIPTION", news_path()))

  if (has_remote_branch(gert::git_branch()) && pull) {
    # is the local branch behind?
    if (gert::git_ahead_behind()$behind > 0) {
      # With pull = TRUE we would fetch always and always uncommit + commit if behind master
      gert::git_pull(rebase = TRUE)
    }
  }

  if (is_last_commit_bump()) {
    if (fledge_chatty()) {
      cli_alert("Resetting to previous commit.")
    }
    gert::git_reset_soft(gert::git_log(max = 2)[2, "commit"])
    amending <- TRUE
  } else {
    amending <- FALSE
  }

  gert::git_add(c("DESCRIPTION", news_path()))

  if (nrow(gert::git_status(staged = TRUE)) > 0) {
    if (fledge_chatty()) {
      cli_alert("Committing changes.")
    }

    # For stable examples output (R Markdown etc.)
    # Default to DESCRIPTION fields
    if (in_example()) {
      author <- default_gert_author()
      committer <- default_gert_committer()
    } else {
      author <- NULL
      committer <- NULL
    }

    gert::git_commit(get_commit_message(), author = author, committer = committer)
  }

  amending
}

is_last_commit_bump <- function() {
  gert::git_log(max = 1)$message == get_commit_message()
}

get_commit_message <- function(version) {
  desc <- desc::desc(file = "DESCRIPTION")
  version <- desc$get_version()

  # gert always appends a newline to the commit messages
  paste0("Bump version to ", version, "\n")
}

check_clean <- function(forbidden_modifications) {
  status <- gert::git_status()
  unexpected <- forbidden_modifications[forbidden_modifications %in% status$file]

  if (length(unexpected) == 0) {
    return()
  }

  error_message <- sprintf(
    "Unindexed change(s) in %s.",
    toString(sprintf("`%s`", unexpected))
  )
  rlang::abort(
    message = c(
      x = error_message,
      i = "Commit the change(s) before running any fledge function again."
    )
  )
}

check_only_modified <- function(allowed_modifications) {
  status <- gert::git_status()
  if (nrow(status) > 0) {
    cli::cli_alert_danger("Found untracked/unstaged/staged files in the git index:
    {.file {unlist(status$file)}}. Please commit or discard them and
    try again.", wrap = TRUE)
  }
  stopifnot(all(unlist(status) %in% allowed_modifications))
}

check_only_staged <- function(allowed_modifications) {
  staged <- gert::git_status(staged = TRUE)
  stopifnot(all(staged$status == "modified"))

  modified <- staged$modified
  stopifnot(all(modified %in% allowed_modifications))
}

check_only_staged <- function(allowed_modifications) {
  staged <- gert::git_status(staged = TRUE)
  stopifnot(all(staged$status == "modified"))

  modified <- staged$file
  stopifnot(all(modified %in% allowed_modifications))
}

in_example <- function() {
  if (Sys.getenv("IN_PKGDOWN") != "") {
    return(TRUE)
  }

  is_test_repo <- (!is.na(desc::desc_get("context")))
  is_test_repo && !rlang::is_interactive()
}

desc_author_name <- function() {
  sub(" <.*", "", desc::desc_get_maintainer())
}

desc_author_email <- function() {
  sub(">", "", sub(".*<", "", desc::desc_get_maintainer()))
}

default_datetime <- function() {
  "2021-09-27 12:47:37Z"
}

default_gert_author <- function() {
  gert::git_signature(
    name = Sys.getenv("GIT_AUTHOR_NAME", desc_author_name()),
    email = Sys.getenv("GIT_AUTHOR_EMAIL", desc_author_email()),
    time = parsedate::parse_iso_8601(
      Sys.getenv("GIT_AUTHOR_DATE", default_datetime())
    )
  )
}

default_gert_committer <- function() {
  gert::git_signature(
    name = Sys.getenv("GIT_COMMITTER_NAME", desc_author_name()),
    email = Sys.getenv("GIT_COMMITTER_EMAIL", desc_author_email()),
    time = parsedate::parse_iso_8601(
      Sys.getenv("GIT_COMMITTER_DATE", default_datetime())
    )
  )
}
