commit_version_impl <- function() {
  stopifnot(length(git2r::status(".", unstaged = FALSE, untracked = FALSE)$staged) == 0)

  desc <- desc::desc(file = "DESCRIPTION")
  version <- desc$get_version()

  if (git2r::last_commit()$message == get_commit_message(version)) {
    message("Resetting to previous commit")
    git2r::reset(git2r::revparse_single(revision = "HEAD^"))
    amending <- TRUE
  } else {
    amending <- FALSE
  }

  git2r::add(".", c("DESCRIPTION", "NEWS.md"))
  if (length(git2r::status(unstaged = FALSE, untracked = FALSE)$staged) > 0) {
    message("Committing changes")
    git2r::commit(".", get_commit_message(version))
  }

  amending
}

get_commit_message <- function(version) {
  paste0("fledge: Bump version to ", version)
}
