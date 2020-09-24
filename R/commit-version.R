commit_version_impl <- function() {
  check_only_staged(c("DESCRIPTION", news_path))

  if (is_last_commit_bump()) {
    cli_alert("Resetting to previous commit.")
    git2r::reset(git2r::revparse_single(revision = "HEAD^"))
    amending <- TRUE
  } else {
    amending <- FALSE
  }

  git2r::add(".", c("DESCRIPTION", news_path))
  if (length(git2r::status(".", unstaged = FALSE, untracked = FALSE)$staged) > 0) {
    cli_alert("Committing changes.")
    git2r::commit(".", get_commit_message())
  }

  amending
}

is_last_commit_bump <- function() {
  git2r::last_commit()$message == get_commit_message()
}

get_commit_message <- function(version) {
  desc <- desc::desc(file = "DESCRIPTION")
  version <- desc$get_version()

  paste0("Bump version to ", version)
}

check_clean <- function(forbidden_modifications) {
  status <- git2r::status(".", unstaged = TRUE, untracked = TRUE)
  stopifnot(!any(forbidden_modifications %in% unlist(status)))
}

check_only_modified <- function(allowed_modifications) {
  status <- git2r::status(".", unstaged = TRUE, untracked = TRUE)
  if (length(status$unstaged) > 0 || length(status$untracked) > 0 ||
      length(status$staged) > 0) {
    cli::cli_alert_danger("Found untracked/unstaged/staged files in the git index:
    {.file {unlist(status)}}. Please commit or discard them and
    try again.", wrap = TRUE)
  }
  stopifnot(all(unlist(status) %in% allowed_modifications))
}

check_only_staged <- function(allowed_modifications) {
  staged <- git2r::status(".", unstaged = FALSE, untracked = FALSE)$staged
  stopifnot(all(names(staged) == "modified"))

  modified <- staged$modified
  stopifnot(all(modified %in% allowed_modifications))
}

check_only_staged <- function(allowed_modifications) {
  staged <- git2r::status(".", unstaged = FALSE, untracked = FALSE)$staged
  stopifnot(all(names(staged) == "modified"))

  modified <- staged$modified
  stopifnot(all(modified %in% allowed_modifications))
}
