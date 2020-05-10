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
    finalize_version(push = FALSE)
  } else {
  #'     - Otherwise, [commit_version()].
    commit_version()
    ui_info("Preparing package for release (CRAN or otherwise)")
    edit_news()
    ui_todo("Convert the change log in {ui_path('NEWS.md')} to release notes")
    ui_todo("After CRAN release, call {ui_code('fledge::tag_version()')} and {ui_code('fledge::bump_version()')} to re-enter development mode")
  }
}
