#' @rdname bump_version
#' @usage NULL
bump_version_impl <- function(which) {
  #' @description
  #' 1. [update_news()]
  update_news()
  #' 2. [update_version()], using the `which` argument
  update_version(which = which)
  #' 3. Depending on the `which` argument:
  if (which == "dev") {
  #'     - If `"dev"`, [finalize_version()]
    finalize_version()
  } else {
  #'     - Otherwise, [commit_version()].
    commit_version()
  }
}
