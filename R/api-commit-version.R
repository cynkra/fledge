#' Commits NEWS.md and DESCRIPTION to Git
#'
#' Commits changes to `NEWS.md` and `DESCRIPTION`, amending a previous commit
#' created by \pkg{fledge} if necessary.
#'
#' @example man/examples/commit-version.R
#'
#' @export
commit_version <- function() {
  amending <- commit_version_impl()

  #' @return Invisibly: `TRUE` if a previous commit for that version has been
  #'   amended, `FALSE` if not.
  invisible(amending)
}
