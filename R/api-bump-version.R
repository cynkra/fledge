#' Bump package version
#'
#' @description
#' Calls the following functions:
#'
#' @inheritParams update_version
#' @export
bump_version <- function(which = "dev") {
  check_which(which)
  check_clean(c("DESCRIPTION", news_path))
  with_repo(bump_version_impl(which))
}
