#' Finalize package version
#'
#' @description
#' Calls the following functions:
#'
#' @param push If `TRUE`, push the created tag.
#' @inheritParams commit_version
#' @example man/examples/finalize-version.R
#' @return None
#' @export
finalize_version <- function(push = FALSE, pull = push) {
  with_repo(finalize_version_impl(push, suggest_finalize = FALSE, pull))
}
