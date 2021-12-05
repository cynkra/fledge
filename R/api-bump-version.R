#' Bump package version
#'
#' @description
#' Calls the following functions:
#'
#' @inheritParams update_version
#' @return None
#' @export
#'
#' @seealso [unbump_version()]
#'
#' @section Bumped too soon?:
#'
#' Have you just run `bump_version()`, then realized
#' "oh shoot, I forgot to merge that PR"?
#' Fear not, run [unbump_version()], merge that PR, run `bump_version()`.
#'
#' @example man/examples/bump-version.R
bump_version <- function(which = "dev") {
  check_which(which)
  check_clean(c("DESCRIPTION", news_path))
  with_repo(bump_version_impl(which))
}
