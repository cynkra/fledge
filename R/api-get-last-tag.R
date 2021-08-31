#' The most recent tag
#'
#' Returns the most recent Git tag.
#'
#' @return A one-row tibble with columns `name`, `ref` and `commit`.
#'   For annotated tags (as created by fledge), `commit` may be different
#'   from the SHA of the commit that this tag points to.
#'   Use [gert::git_log()] to find the actual commit.
#'
#' @export
get_last_tag <- function() {
  with_repo(get_last_tag_impl())
}
