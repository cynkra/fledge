#' Undoes bumping the package version
#'
#' This undoes the effect of a [bump_version()] call, with a safety check.
#'
#' @return `NULL`, invisibly. This function is called for its side effects.
#'
#' @seealso bump_version
#'
#' @examples
#' # Create temporary directory to hold a mock package.
#' tempdir <- file.path(tempdir(), "fledge", "unbump")
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
#' # Oh no, we forgot to also add the awesome function for that version!
#' # UNBUMP
#' fledge::unbump_version()
#' # Add a new R file.
#' usethis::use_r("awesome-function", open = FALSE)
#' # Pretend we added awesome code inside it.
#' # Track the new R file with Git.
#' gert::git_add("R/awesome-function.R")
#' gert::git_commit("- Add awesome function.")
#' # Bump version with fledge.
#' fledge::bump_version()
#'
#' })
#' # Clean
#' unlink(tempdir, recursive = TRUE)
#'
#' @export
unbump_version <- function() {
  unbump_version_impl()
}
