#' Update NEWS.md and DESCRIPTION with a new version
#'
#' Bumps a version component and adds to `NEWS.md` and `DESCRIPTION`.
#'
#' @param which which
#' @export
update_version <- function(which = "dev") {
  update_version_impl(which)
}
