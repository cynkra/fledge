#' Create a new version tag
#'
#' Parses `NEWS.md` and creates/updates the tag for the most recent version.
#'
#' @param force Re-tag even if the last commit wasn't created by
#'   [bump_version()].  Useful when defining a CRAN release.
#'
#' @export
tag_version <- function(force = FALSE) {
  tag_version_impl(force)
  invisible(NULL)
}
