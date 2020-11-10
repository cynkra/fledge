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
    gert::git_tag_push(tag, force = force)
    gert::git_push()
  } else if (suggest_finalize) {
    edit_news()

    command <- "fledge::finalize_version(push = TRUE)"

    cli_alert_warning("Call {.code {command}}.")
    send_to_console(command)
  }
}

send_to_console <- function(code) {
  if (!is_installed("rstudioapi")) {
    return()
  }
  if (!is_interactive()) {
    return()
  }

  rstudioapi::sendToConsole(code, execute = FALSE)
}

push_head <- function(head) {
  cli_alert("Pushing {.field {head}}.")
  gert::git_push()
}

push_to_new <- function(remote_name, force) {
  branch_name <- get_branch_name()

  cli_alert("Pushing {.field {branch_name}} to remote {.field {remote_name}}.")

  gert::git_push(remote_name,
    force = force,
    refspec = paste0("refs/heads/", branch_name)
  )
}

push_tag <- function(tag) {
  cli_alert("Force-pushing tag {.field {tag}}.")
  gert::git_tag_push(name = tag, force = TRUE)
}
