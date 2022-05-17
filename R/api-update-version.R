#' Update NEWS.md and DESCRIPTION with a new version
#'
#' Bumps a version component and adds to `NEWS.md` and `DESCRIPTION`.
#'
#' @example man/examples/tag-version.R
#'
#' @return None
#' @export
update_version <- function(which = c("dev", "patch", "minor", "major")) {
  which <- arg_match(which)
  update_version_impl(which)
  invisible(NULL)
}
