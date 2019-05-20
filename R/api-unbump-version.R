#' Undoes bumping the package version
#'
#' This undoes the effect of a [bump_version()] call, with a safety check.
#'
#' @export
unbump_version <- function() {
  unbump_version_impl()
}
