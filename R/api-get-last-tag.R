#' The most recent tag
#'
#' Returns the most recent Git tag.
#'
#' @return An object of the repo's [gert::git_tag_list()].
#'
#' @export
get_last_tag <- function() {
  get_last_tag_impl()
}
