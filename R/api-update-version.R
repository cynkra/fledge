#' Update NEWS.md and DESCRIPTION with a new version
#'
#' @description
#'`r lifecycle::badge("deprecated")`
#'
#' Deprecated, use [update_news()].
#'
#' @inheritParams update_news
#' @example man/examples/tag-version.R
#'
#' @return None
#' @keywords internal
#' @export
update_version <- function(which = c("auto", "samedev", "dev", "patch", "pre-minor", "minor", "pre-major", "major")) {
  lifecycle::deprecate_soft("0.1.1", "fledge::update_version()", "fledge::update_news()")

  update_news(character(), which)
}
