#' Create a new version tag
#'
#' Parses `NEWS.md` and creates/updates the tag for the most recent version.
#'
#' @export
tag_version <- function() {
  tag_version_impl()
}
