#' The most recent versioned tag
#'
#' Returns the Git tag of the form vx.y, vx.y.z or vx.y.z.w with the latest version.
#' An older version of this logic is used in [get_last_tag()],
#' which traverses the Git history but does not work with squash-merging of version bumps.
#'
#' @inherit get_last_tag return
#'
#' @example man/examples/get-last-version-tag.R
#'
#' @export
get_last_version_tag <- function() {
  with_repo(get_last_version_tag_impl())
}
