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

    # For stable Rmarkdown output
    if (Sys.getenv("IN_PKGDOWN") != "") {
      author_time <- unclass(parsedate::parse_iso_8601(Sys.getenv("GIT_AUTHOR_DATE")))[[1]]
      author <- structure(
        list(
          name = Sys.getenv("GIT_AUTHOR_NAME"),
          email = Sys.getenv("GIT_AUTHOR_EMAIL"),
          when = structure(list(time = author_time, offset = 0), class = "git_time")
        ),
        class = "git_signature"
      )
      committer_time <- unclass(parsedate::parse_iso_8601(Sys.getenv("GIT_COMMITTER_DATE")))[[1]]
      committer <- structure(
        list(
          name = Sys.getenv("GIT_COMMITTER_NAME"),
          email = Sys.getenv("GIT_COMMITTER_EMAIL"),
          when = structure(list(time = committer_time, offset = 0), class = "git_time")
        ),
        class = "git_signature"
      )
    } else {
      author <- NULL
      committer <- NULL
    }

    git2r::commit(".", get_commit_message(), author = author, committer = committer)
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

check_only_staged <- function(allowed_modifications) {
  staged <- git2r::status(".", unstaged = FALSE, untracked = FALSE)$staged
  stopifnot(all(names(staged) == "modified"))

  modified <- staged$modified
  stopifnot(all(modified %in% allowed_modifications))
}
