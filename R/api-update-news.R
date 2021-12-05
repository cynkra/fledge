#' Update NEWS.md with messages from top-level commits
#'
#' Lists all commits from a range (default: top-level commits since the most
#' recent tag) and adds bullets from their body to `NEWS.md`.
#' Creates `NEWS.md` if necessary.
#' @param messages A character vector of commit messages,
#'   e.g. as in the `message` column in the return value of [get_top_level_commits()].
#'   The default uses the top level commits since the last tag as retrieved by [get_last_tag()].
#'
#' @example man/examples/tag-version.R
#'
#' @return None
#' @export
update_news <- function(messages = NULL) {
  if (is.null(messages)) {
    messages <- get_top_level_commits(since = get_last_tag()$commit)$message
  }

  with_repo(update_news_impl(messages))
  invisible(NULL)
}
