#' @rdname finalize_version
#' @usage NULL
finalize_version_impl <- function(push, suggest_finalize = TRUE) {
  #' @description
  #' 1. [commit_version()]
  commit_version()
  #' 1. [tag_version()] with `force = TRUE`
  tag <- tag_version(TRUE)
  #' 1. Force-pushes the created tag to the `"origin"` remote, if `push = TRUE`.
  if (push) {
    push_head()
    push_tag(tag, force = TRUE)
  } else if (suggest_finalize) {
    edit_news()

    if (has_remote_branch(gert::git_branch())) {
      command <- "fledge::finalize_version(push = TRUE)"
    } else {
      command <- "fledge::finalize_version()"
    }
    if (fledge_chatty()) {
      cli_alert_warning("Run {.run {command}}.")
    }
    send_to_console(command)
  }
}

pull_head <- function() {
  head <- gert::git_branch()

  if (fledge_chatty()) {
    cli_alert("Pulling {.field {head}}.")
  }

  gert::git_pull(rebase = TRUE)
}

push_tag <- function(tag, force = TRUE) {
  if (fledge_chatty()) {
    cli_alert("Force-pushing tag {.field {tag}}.")
  }
  gert::git_tag_push(tag, force = force)
}

push_head <- function() {
  head <- gert::git_branch()

  if (fledge_chatty()) {
    cli_alert("Pushing {.field {head}}.")
  }

  # https://github.com/r-lib/gert/issues/236
  gert::git_push()

  info <- gert::git_info()
  if (info$commit != gert::git_commit_id(info$upstream)) {
    cli::cli_abort("Push failed, perhaps due to branch protection?")
  }
}

push_to_new <- function(remote_name, force) {
  branch_name <- get_branch_name()

  if (fledge_chatty()) {
    cli_alert("Pushing {.field {branch_name}} to remote {.field {remote_name}}.")
  }

  gert::git_push(
    refspec = paste0("refs/heads/", branch_name),
    remote = remote_name,
    force = force,
    set_upstream = TRUE
  )
}

has_remote_branch <- function(branch) {
  branches <- gert::git_branch_list(local = TRUE)
  !is.na(branches$upstream[branches$name == branch])
}

send_to_console <- function(code) {
  if (!is_interactive()) {
    return()
  }
  if (!is_installed("rstudioapi")) {
    return()
  }
  if (!rstudioapi::hasFun("sendToConsole")) {
    return()
  }

  tryCatch(
    rstudioapi::sendToConsole(code, execute = FALSE),
    error = function(e) {
      rstudioapi::sendToConsole(paste0("if (FALSE) ", code), execute = TRUE)
    }
  )
}
