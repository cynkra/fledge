commit_version_impl <- function() {
  stopifnot(length(git2r::status(".", unstaged = FALSE, untracked = FALSE)$staged) == 0)

  if (is_last_commit_bump()) {
    message("Resetting to previous commit")
    git2r::reset(git2r::revparse_single(revision = "HEAD^"))
    amending <- TRUE
  } else {
    amending <- FALSE
  }

  git2r::add(".", c("DESCRIPTION", "NEWS.md"))
  if (length(git2r::status(".", unstaged = FALSE, untracked = FALSE)$staged) > 0) {
    message("Committing changes")
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
