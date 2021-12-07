#' Finalize package version
#'
#' @description
#' Calls the following functions:
#'
#' @param push If `TRUE`, push the created tag.
#' @example man/examples/finalize-version.R
#' @return None
#' @export
finalize_version <- function(push = FALSE) {
  with_repo(finalize_version_impl(push, suggest_finalize = FALSE))
}
