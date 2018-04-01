#' Update NEWS.md with messages from top-level commits
#'
#' Lists all commits from a range (default: top-level commits since the most
#' recent tag) and adds bullets from their body to `NEWS.md`.
#' @param range range
#' @export
update_news <- function(range = get_top_level_commits(since = get_last_tag())) {
  update_news_impl(range)
  invisible(NULL)
}
