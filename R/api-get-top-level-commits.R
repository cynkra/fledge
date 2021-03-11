#' All top-level commits
#'
#' Return all top-level commits since a particular version
#' as commit objects.
#'
#' @return A character vector of commit SHAs.
#'
#' @param since A commit SHA, e.g. as returned from [get_last_tag()].
#' @export
get_top_level_commits <- function(since) {
  with_repo(get_top_level_commits_impl(since))
}
