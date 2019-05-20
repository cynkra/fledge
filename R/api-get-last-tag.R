#' The most recent tag
#'
#' Returns the most recent Git tag.
#'
#' @return An element from this repo's [git2r::tags()].
#'
#' @export
get_last_tag <- function() {
  get_last_tag_impl()
}
