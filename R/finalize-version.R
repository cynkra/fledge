#' @rdname finalize_version
#' @usage NULL
finalize_version_impl <- function(push, suggest_finalize = TRUE) {

  #' @description
  #' 1. [commit_version()]
  force <- commit_version()
  #' 1. [tag_version()], setting `force = TRUE` if and only if `commit_version()`
  #'   amended a commit.
  tag <- tag_version(force)
  #' 1. Force-pushes the created tag to the `"origin"` remote, if `push = TRUE`.
  if (push) {
    cli_alert("Force-pushing tag {.field {tag}}.")
    gert::git_tag_push(tag, force = TRUE)
    gert::git_push()
  } else if (suggest_finalize) {
    edit_news()

    if (has_remote_branch(head)) {
      command <- "fledge::finalize_version(push = TRUE)"
    } else {
      command <- "fledge::finalize_version()"
    }

    cli_alert_warning("Call {.code {command}}.")
    send_to_console(command)
  }
}

send_to_console <- function(code) {
  if (!is_installed("rstudioapi")) return()
  if (!is_interactive()) return()

  rstudioapi::sendToConsole(code, execute = FALSE)
}
