#' All top-level commits
#'
#' Return all top-level commits since a particular version
#' as commit objects.
#'
#' @return A list of commit objects similarly to [gert::git_log()].
#'
#' @param since A commit or tag object, e.g. [get_last_tag()].
#' @export
get_top_level_commits <- function(since) {
  get_top_level_commits_impl(since)
}
