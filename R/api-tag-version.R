#' Create a new version tag
#'
#' Parses `NEWS.md` and creates/updates the tag for the most recent version.
#'
#' @param force Re-tag even if the last commit wasn't created by
#'   [bump_version()].  Useful when defining a CRAN release.
#'
#' @return The created tag, invisibly.
#'
#' @example man/examples/tag-version.R
#'
#' @return None
#' @export
tag_version <- function(force = FALSE) {
  tag <- tag_version_impl(force)
  invisible(tag)
}
