commit_version_impl <- function() {
  check_only_staged(c("DESCRIPTION", news_path))

  if (is_last_commit_bump()) {
    cli_alert("Resetting to previous commit.")
    gert::git_reset_soft(gert::git_log(max = 2)[2, "commit"])
    amending <- TRUE
  } else {
    amending <- FALSE
  }

  gert::git_add(c("DESCRIPTION", news_path))

  if (length(gert::git_status(staged = TRUE)$staged) > 0) {
    cli_alert("Committing changes.")

    # For stable Rmarkdown output
    if (Sys.getenv("IN_PKGDOWN") != "") {
      author_time <- parsedate::parse_iso_8601(Sys.getenv("GIT_AUTHOR_DATE"))
      author <- gert::git_signature(
        name = Sys.getenv("GIT_AUTHOR_NAME"),
        email = Sys.getenv("GIT_AUTHOR_EMAIL"),
        time = author_time
      )
      committer_time <- parsedate::parse_iso_8601(Sys.getenv("GIT_COMMITTER_DATE"))
      committer <- gert::git_signature(
        name = Sys.getenv("GIT_COMMITTER_NAME"),
        email = Sys.getenv("GIT_COMMITTER_EMAIL"),
        time = committer_time
      )
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

  paste0("Bump version to ", version, "\n")
}

check_clean <- function(forbidden_modifications) {
  status <- gert::git_status()
  stopifnot(!any(forbidden_modifications %in% status$file))
}

check_only_staged <- function(allowed_modifications) {
  staged <- gert::git_status(staged = TRUE)
  stopifnot(all(staged$status == "modified"))

  modified <- staged$modified
  stopifnot(all(modified %in% allowed_modifications))
}
