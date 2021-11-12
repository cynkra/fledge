#' Bump package version
#'
#' @description
#' Calls the following functions:
#'
#' @inheritParams update_version
#' @export
#'
#' @seealso [unbump_version()]
#'
#' @section Bumped too soon?:
#'
#' Have you just run `bump_version()`, then realized
#' "oh shoot, I forgot to merge that PR"?
#' Fear not, run [unbump_version()], merge that PR, run `bump_version()`.
#'
#' @examples
#' # Create temporary directory to hold a mock package.
#' tempdir <- file.path(tempdir(), "fledge", "bump")
#' dir.create(tempdir, recursive = TRUE)
#' # Create said mock package.
#' # Set open to TRUE if you want to play in the mock package.
#' pkg <- create_demo_project(open = FALSE, news = TRUE, dir = tempdir)
#' # Use functions as if inside the newly created package project.
#' # (Or go and actually run code inside the newly created package project!)
#' usethis::with_project(pkg, {
#' # Add a new R file.
#' usethis::use_r("cool-function", open = FALSE)
#' # Pretend we added useful code inside it.
#' # Track the new R file with Git.
#' gert::git_add("R/cool-function.R")
#' gert::git_commit("- Add cool function.")
#' # Bump version with fledge.
#' fledge::bump_version()
#' })
#' # Clean
#' unlink(tempdir, recursive = TRUE)
bump_version <- function(which = "dev") {
  check_which(which)
  check_clean(c("DESCRIPTION", news_path()))
  with_repo(bump_version_impl(which))
}
