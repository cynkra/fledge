#' @rdname finalize_version
#' @usage NULL
finalize_version_impl <- function(push, suggest_finalize = TRUE) {
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

has_remote_branch <- function(branch) {
  !is.null(git2r::branch_get_upstream(branch))
}

send_to_console <- function(code) {
  if (!is_interactive()) return()
  if (!is_installed("rstudioapi")) return()
  if (!rstudioapi::hasFun("sendToConsole")) return()

  tryCatch(
    rstudioapi::sendToConsole(code, execute = FALSE),
    error = function(e) {
      rstudioapi::sendToConsole(paste0("FALSE || ", code), execute = TRUE)
    }
  )
}
