#' Update NEWS.md with messages from top-level commits
#'
#' Lists all commits from a range (default: top-level commits since the most
#' recent tag) and adds bullets from their body to `NEWS.md`.
#' @param range A commit range as character vector of SHAs,
#'   e.g. as returned from [get_top_level_commits()].
#' @export
update_news <- function(range = get_top_level_commits(since = get_last_tag())) {
  with_repo(update_news_impl(range))
  invisible(NULL)
}
