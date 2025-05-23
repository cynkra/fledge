#' Update NEWS.md with messages from top-level commits
#'
#' Lists all commits from a range (default: top-level commits since the most
#' recent tag as determined by [get_last_version_tag()])
#' and adds bullets from their body to `NEWS.md`.
#' Creates `NEWS.md` if necessary.
#'
#' @param messages A character vector of commit messages,
#'   e.g. as in the `message` column in the return value of [get_top_level_commits()].
#'   The default uses the top level commits since the last tag as retrieved by [get_last_version_tag()].
#' @param which Component of the version number to update. Supported
#'   values are
#'   * `"auto"` (default: `"samedev"` or `"dev"`, depending on contents of `NEWS.md`),
#'   * `"samedev"` (a.b.c.900x with stable version),
#'   * `"dev"` (a.b.c.9xxx),
#'   * `"patch"` (a.b.x),
#'   * `"pre-minor"` (a.b.99.9000),
#'   * `"minor"` (a.x.0),
#'   * `"pre-major"` (a.99.99.9000),
#'   * `"major"` (x.0.0).
#' @example man/examples/tag-version.R
#'
#' @return None
#' @export
update_news <- function(
  messages = NULL,
  which = c("auto", "samedev", "dev", "pre-patch", "patch", "pre-minor", "minor", "pre-major", "major")
) {
  which <- arg_match(which)

  local_repo()

  if (is.null(messages)) {
    commits <- default_commit_range()
  } else {
    commits <- tibble::tibble(
      message = messages,
      merge = FALSE
    )
  }

  fledgeling <- update_news_impl(
    commits = commits,
    which = which
  )
  write_fledgling(fledgeling)

  invisible(NULL)
}

default_commit_range <- function(current_version = NULL, ref = "HEAD") {
  since <- get_last_version_tag_impl(current_version)$commit
  get_top_level_commits_impl(since = since, ref)
}
