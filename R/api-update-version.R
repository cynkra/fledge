#' Update NEWS.md and DESCRIPTION with a new version
#'
#' Bumps a version component and adds to `NEWS.md` and `DESCRIPTION`.
#'
#' @param which Component of the version number to update. Supported
#'   values are
#'   * `"dev"` (default),
#'   * `"patch"`,
#'   * `"pre-minor"` (x.y.99.9000),
#'   * `"minor"`,
#'   * `"pre-major"` (x.99.99.9000),
#'   * `"major"`.
#' @example man/examples/tag-version.R
#'
#' @return None
#' @export
update_version <- function(which = c("dev", "patch", "pre-minor", "minor", "pre-major", "major")) {
  which <- arg_match(which)
  update_version_impl(which)
  invisible(NULL)
}
