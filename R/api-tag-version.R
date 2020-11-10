#' Create a new version tag
#'
#' Parses `NEWS.md` and creates/updates the tag for the most recent version.
#'
#' @param force Re-tag even if the last commit wasn't created by
#'   [bump_version()].  Useful when defining a CRAN release.
#'
#' @return The created tag, invisibly.
#'
#' @export
tag_version <- function(force = FALSE) {
  tag <- tag_version_impl(force)
  invisible(tag)
}

#' @rdname tag_version
#' @export
tag_release_candidate <- function(force = FALSE) {
  tag <- tag_release_candidate_impl(force)
  invisible(tag)
}

delete_release_candidate_tags <- function() {

  tag_names <- gert::git_tag_list()$name

  tags_to_delete <- grep("-rc", tag_names, value = TRUE)

  cli_alert("Deleting all release candidate tags.")

  # delete all tags which contain "-rc"
  # # not vectorized :/?
  invisible(lapply(tags_to_delete, function(x) gert::git_tag_delete(x)))
}
