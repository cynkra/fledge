#' @rdname finalize_version
#' @usage NULL
finalize_version_impl <- function(additional_commit_message = "") {
  #' @description
  #' 1. [commit_version()]
  force <- commit_version(additional_commit_message)
  #' 1. [tag_version()], setting `force = TRUE` if and only if `commit_version()`
  #'   amended a commit.
  tag_version(force)
}
