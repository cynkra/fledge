#' Bump package version
#'
#' @description
#' Calls the following functions:
#'
#' @inheritParams update_version
#' @inheritParams rlang::args_dots_empty
#' @param no_change_behavior What to do if there was no change since the last
#'   version: `"bump"` for bump the version;
#'   `"noop"` for do nothing;
#'   `"fail"` for erroring.
#' @param check_default_branch Whether to check that the current branch is the
#'   default branch.
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
bump_version <- function(
    which = c("dev", "patch", "pre-minor", "minor", "pre-major", "major"),
    ...,
    no_change_behavior = c("bump", "noop", "fail"),
    check_default_branch = TRUE
) {
  check_dots_empty()

  which <- arg_match(which)
  no_change_behavior <- arg_match(no_change_behavior)

  fledgeling <- read_fledgling()

  if (!fledge_is_interactive() && !fledgeling[["preamble_in_file"]] && !nzchar(Sys.getenv("FLEDGE_FORCE_NEWS_MD"))) {
    cli::cli_alert_info("Can't act non-interactively on a {.file NEWS.md} with no fledge-like preamble (HTML comment).")
    return(invisible(FALSE))
  }

  check_clean(c("DESCRIPTION", news_path))

  local_repo()

  new_fledgeling <- bump_version_impl(
    fledgeling,
    which = which,
    no_change_behavior = no_change_behavior,
    check_default_branch = check_default_branch
  )

  invisible(!identical(new_fledgeling, fledgeling))
}
