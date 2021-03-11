#' @rdname bump_version
#' @usage NULL
bump_version_impl <- function(which) {
  #' @description
  #' 1. [update_news()]
  update_news()
  #' 2. [update_version()], using the `which` argument
  update_version(which = which)
  #' 3. Depending on the `which` argument:
  if (which == "dev") {
    #'     - If `"dev"`, [finalize_version()] with `push = FALSE`
    finalize_version_impl(push = FALSE)
  } else {
    #'     - Otherwise, [commit_version()].
    commit_version()

    cli_h2("Preparing package for CRAN release")
    edit_news()
    cli_ul("Convert the changelog in {.file {news_path}} to release notes.")
  }
}

bump_version_to_dev_with_force <- function(force) {
  update_news()
  update_version()

  head <- get_head_branch()
  force <- commit_version() || force
  tag <- tag_version(force)
  push_tag(tag)
  push_head(head)
}
