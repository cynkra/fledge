commit_version_impl <- function() {
  stopifnot(length(git2r::status(".", unstaged = FALSE, untracked = FALSE)$staged) == 0)

  desc <- desc::desc(file = "DESCRIPTION")
  version <- desc$get_version()

  if (grepl("^fledge: Bump version to ", git2r::last_commit()$message)) {
    message("Resetting to previous commit")
    git2r::reset(git2r::revparse_single(revision = "HEAD^"))
    amending <- TRUE
  } else {
    amending <- FALSE
  }

  git2r::add(".", c("DESCRIPTION", "NEWS.md"))
  if (length(git2r::status(unstaged = FALSE, untracked = FALSE)$staged) > 0) {
    message("Committing changes")
    git2r::commit(".", paste0("fledge: Bump version to ", version))
  }

  amending
}
