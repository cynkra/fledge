#' Bump package version
#'
#' @description
#' Calls the following functions:
#'
#' @inheritParams update_version
#' @export
bump_version <- function(which = "dev") {
  bump_version_impl(which)
}
