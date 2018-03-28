#' Bump package version
#'
#' @description
#' Calls the following functions:
#'
#' @inheritParams update_version
#' @export
bump_version <- function(which = "dev") {
  #' @description
  #' 1. [update_news()]
  update_news()
  #' 2. [update_version()], using the `which` argument
  update_version(which = which)
  #' 3. [tag_version()]
  tag_version()
}
