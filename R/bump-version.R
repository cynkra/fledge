#' @rdname bump_version
#' @usage NULL
bump_version_impl <- function(which, additional_commit_message = "") {
  #' @description
  #' 1. [update_news()]
  update_news()
  #' 2. [update_version()], using the `which` argument
  update_version(which = which)
  #' 3. Depending on the `which` argument:
  if (which == "dev") {
  #'     - If `"dev"`, [finalize_version()]
    finalize_version_impl(additional_commit_message)
    edit_news()
    ui_todo("If you have updated {ui_path('NEWS.md')}, save the file and call {ui_code('fledge::finalize_version()')}")
    ui_todo("When done, push to the remote repository, including tags.")
    ui_info("Use {ui_code('git push --tags')} from the command line.")
  } else {
  #'     - Otherwise, [commit_version()].
    commit_version(additional_commit_message)
    ui_info("Preparing package for release (CRAN or otherwise)")
    edit_news()
    ui_todo("Every time you edit {ui_path('NEWS.md')}, save it and call {ui_code('fledge::commit_version()')}")
    ui_todo("After CRAN release, call {ui_code('fledge::tag_version(force = TRUE)')} and {ui_code('fledge::bump_version()')} to re-enter development mode")
  }
}
