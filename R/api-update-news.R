#' Update NEWS.md with messages from top-level commits
#'
#' Lists all commits from a range (default: top-level commits since the most
#' recent tag) and adds bullets from their body to `NEWS.md`.
#' Creates `NEWS.md` if necessary.
#' @param messages A character vector of commit messages,
#'   e.g. as in the `message` column in the return value of [get_top_level_commits()].
#'   The default uses the top level commits since the last tag as retrieved by [get_last_tag()].
#' @param which Component of the version number to update. Supported
#'   values are
#'   * `"dev"` (default),
#'   * `"patch"`,
#'   * `"pre-minor"` (x.y.99.9000),
#'   * `"minor"`,
#'   * `"pre-major"` (x.99.99.9000),
#'   * `"major"`.
#' @example man/examples/tag-version.R
#'
#' @return None
#' @export
update_news <- function(messages = NULL, which = NULL) {
  if (is.null(messages)) {
    commits <- default_commit_range()
  } else {
    commits <- tibble::tibble(
      message = messages,
      merge = FALSE
    )
  }

  local_repo()

  update_news_impl(commits, which)

  invisible(NULL)
}

default_commit_range <- function() {
  get_top_level_commits(since = get_last_tag()$commit)
}
