#' Update NEWS.md and DESCRIPTION with a new version
#'
#' Bumps a version component and adds to `NEWS.md` and `DESCRIPTION`.
#'
#' @inheritParams update_news
#' @example man/examples/tag-version.R
#'
#' @return None
#' @export
update_version <- function(which = c("dev", "patch", "pre-minor", "minor", "pre-major", "major")) {
  # FIXME: Signal deprecation

  update_news(character(), which)
}
