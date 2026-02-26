#' @rdname unbump_version
#' @usage NULL
unbump_version_impl <- function() {
  # We are not assuming diverged branches here, get_last_tag() is fine
  tag <- get_last_tag()
  tag_last_commit <- gert::git_log(tag$commit, max = 1)
  last_commit <- gert::git_log(max = 1)

  if (fledge_chatty()) {
    cli_alert_info("Checking if working copy is clean.")
  }
  stopifnot(sum(map_int(gert::git_status(), length)) == 0)
  if (fledge_chatty()) {
    cli_alert_info("Checking if last tag points to last commit.")
  }
  stopifnot(tag_last_commit$commit == last_commit$commit)
  if (fledge_chatty()) {
    cli_alert_info("Checking if commit messages match.")
  }
  stopifnot(is_last_commit_bump())

  if (fledge_chatty()) {
    cli_alert_success("Safety checks complete.")
  }

  if (fledge_chatty()) {
    cli_alert("Deleting tag {.field {tag$name}}.")
  }
  gert::git_tag_delete(tag$name)

  parent_commit_id <- gert::git_commit_info(last_commit$commit)$parents

  message_id <- if (in_example()) {
    42
  } else {
    parent_commit_id
  }
  if (fledge_chatty()) {
    cli_alert_success("Resetting to parent commit {.field {message_id}}.")
  }

  gert::git_reset_hard(parent_commit_id)

  invisible()
}
