#' Finalize package version
#'
#' @description
#' Calls the following functions:
#'
#' @param push If `TRUE`, push the created tag.
#' @export
finalize_version <- function(push = FALSE) {
  finalize_version_impl(push)
}
