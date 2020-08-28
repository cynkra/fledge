#' @rdname finalize_version
#' @usage NULL
finalize_version_impl <- function(push) {
  head <- get_head_branch()

  #' @description
  #' 1. [commit_version()]
  force <- commit_version()
  #' 1. [tag_version()], setting `force = TRUE` if and only if `commit_version()`
  #'   amended a commit.
  tag <- tag_version(force)
  #' 1. Force-pushes the created tag to the `"origin"` remote, if `push = TRUE`.
  if (push) {
    push_tag(tag)
    push_head(head)
  } else {
    edit_news()
    cli_alert_warning("Call {.code fledge::finalize_version(push = TRUE)}.")
    send_to_console("fledge::finalize_version(push = TRUE)")
  }
}

get_head_branch <- function() {
  head <- git2r::repository_head()
  stopifnot(git2r::is_branch(head))
  head
}

push_tag <- function(tag) {
  cli_alert("Force-pushing tag {.field {tag}}.")
  git2r::push(name = "origin", refspec = paste0("refs/tags/", tag), force = TRUE)
}

push_head <- function(head) {
  cli_alert('Pushing {.field {head$name}}.')
  git2r::push(head)
}

push_to_new <- function(remote_name, force) {
  branch_name <- get_branch_name()

  ui_done("Pushing {ui_value(branch_name)} to remote {ui_value(remote_name)}")
  git2r::push(
    git2r::repository(),
    name = remote_name,
    refspec = paste0("refs/heads/", branch_name),
    force = force,
    set_upstream = TRUE
  )
}

send_to_console <- function(code) {
  if (!is_installed("rstudioapi")) return()
  if (!is_interactive()) return()

  rstudioapi::sendToConsole(code, execute = FALSE)
}
