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
#' @return
#'   `TRUE` if `NEWS.md` and `DESCRIPTION` have been updated,
#'   `FALSE` otherwise.
#'   Do not rely on this behavior.
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
bump_version <- function(which = c("dev", "patch", "pre-minor", "minor", "pre-major", "major"), no_change_behavior = c("bump", "noop", "fail")) {

  is_preamble_absent <- is.null(read_news()[["preamble"]])
  if (!is_interactive() && is_preamble_absent) {
    cli::cli_alert_info("Can't act non-interactively on a {.field NEWS.md} with no fledge-like preamble (HTML comment).")
    return(invisible(FALSE))
  }

  which <- arg_match(which)
  no_change_behavior <- arg_match(no_change_behavior)

  check_clean(c("DESCRIPTION", news_path))

  local_repo()

  bump_version_impl(which = which, no_change_behavior = no_change_behavior)
}
