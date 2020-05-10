#' Finalize package version
#'
#' @description
#' Calls the following functions:
#'
#' @export
finalize_version <- function(push = FALSE) {
  finalize_version_impl(push)
}
