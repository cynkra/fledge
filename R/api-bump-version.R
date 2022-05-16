#' Bump package version
#'
#' @description
#' Calls the following functions:
#'
#' @inheritParams update_version
#' @param no_change_behavior What to do if there was no change since the last
#' version: `"bump"` for bump the version;
#' `"noop"` for do nothing;
#' `"fail"` for erroring.
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
bump_version <- function(which = "dev", no_change_behavior = c("bump", "noop", "fail")) {
  check_which(which)

  no_change_behavior <- arg_match(no_change_behavior)

  check_clean(c("DESCRIPTION", news_path))
  with_repo(bump_version_impl(which = which, no_change_behavior = no_change_behavior))
}
