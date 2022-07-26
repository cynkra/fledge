#' Commits NEWS.md and DESCRIPTION to Git
#'
#' Commits changes to `NEWS.md` and `DESCRIPTION`, amending a previous commit
#' created by \pkg{fledge} if necessary.
#'
#' @param pull whether to fetch the remote (if it exists).
#'
#'
#' @example man/examples/commit-version.R
#'
#' @export
commit_version <- function(pull = TRUE) {
  amending <- commit_version_impl(pull = pull)

  #' @return Invisibly: `TRUE` if a previous commit for that version has been
  #'   amended, `FALSE` if not.
  invisible(amending)
}
