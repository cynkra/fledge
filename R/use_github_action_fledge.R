#' Use fledge GitHub Actions workflow
#'
#' @inheritParams usethis::use_github_action
#'
#' @return Nothing, called for its side-effect.
#' @export
#'
use_github_action_pkgcheck <- function(save_as = NULL) {
  usethis::use_github_action(
    url = system.file("fledge.yaml", package = "fledge"),
    save_as = save_as
  )
}
