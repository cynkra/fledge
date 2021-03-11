#' The most recent tag
#'
#' Returns the most recent Git tag.
#'
#' @return The SHA of the commit representing the last tag.
#'
#' @export
get_last_tag <- function() {
  with_repo(get_last_tag_impl())
}
