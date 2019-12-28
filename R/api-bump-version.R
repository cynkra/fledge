#' Bump package version
#'
#' @description
#' Calls the following functions:
#'
#' @inheritParams update_version
#' @export
bump_version <- function(which = "dev") {
  check_which(which)
  check_clean(c("DESCRIPTION", "NEWS.md"))
  bump_version_impl(which)
}
