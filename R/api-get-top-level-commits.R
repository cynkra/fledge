#' All top-level commits
#'
#' Return all top-level commits since a particular version
#' as commit objects.
#'
#' @return A [tibble] with at least two columns:
#' - `commit`: the commit SHA
#' - `message`: the commit message
#'
#' @param since A commit SHA, e.g. as returned from [get_last_tag()].
#'   If `NULL`, the entire log is retrieved.
#'
#' @example man/examples/get-last-tag.R
#'
#' @export
get_top_level_commits <- function(since = NULL) {
  with_repo(get_top_level_commits_impl(since))
}
