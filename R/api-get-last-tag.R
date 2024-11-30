#' The most recent tag
#'
#' Returns the most recent Git tag that is reachable from the current branch.
#' This will not be accurate if the version bump and tag has occurred on a branch
#' which has been squashed into the main branch.
#' See [get_last_version_tag()] for a version that works in this scenario.
#'
#' @return A one-row tibble with columns `name`, `ref` and `commit`.
#'   For annotated tags (as created by fledge), `commit` may be different
#'   from the SHA of the commit that this tag points to.
#'   Use [gert::git_log()] to find the actual commit.
#'
#' @example man/examples/get-last-tag.R
#'
#' @export
get_last_tag <- function() {
  with_repo(get_last_tag_impl())
}
