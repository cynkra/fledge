#' All top-level commits
#'
#' Return all top-level commits since a particular version
#' as commit objects.
#'
#' @return A list of commit objects similarly to [git2r::commits()].
#'
#' @param since A commit or tag object, e.g. [get_last_tag()].
#' @export
get_top_level_commits <- function(since) {
  with_repo(get_top_level_commits_impl(since))
}
