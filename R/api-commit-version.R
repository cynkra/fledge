#' Commits NEWS.md and DESCRIPTION to Git
#'
#' Commits changes to `NEWS.md` and `DESCRIPTION`, amending a previous commit
#' created by \pkg{fledge} if necessary.
#'
#' @export
commit_version <- function(additional_commit_message = "") {
  amending <- commit_version_impl(additional_commit_message)

  #' @return Invisibly: `TRUE` if a previous commit for that version has been
  #'   amended, `FALSE` if not.
  invisible(amending)
}
