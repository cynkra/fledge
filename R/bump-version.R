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
    cli_alert_info("Preparing package for release (CRAN or otherwise).")
    edit_news()
    cli_alert_warning("Convert the change log in {.file {news_path}} to release notes.")
    cli_alert_warning("After CRAN release, call {.fun fledge::tag_version} and
           {.fun fledge::bump_version} to re-enter development mode")
  }
}
