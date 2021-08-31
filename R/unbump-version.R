#' @rdname unbump_version
#' @usage NULL
unbump_version_impl <- function() {
  tag <- get_last_tag()
  tag_last_commit <- gert::git_log(tag$commit, max = 1)
  last_commit <- gert::git_log(max = 1)

  cli_alert_info("Checking if working copy is clean.")
  stopifnot(sum(map_int(gert::git_status(), length)) == 0)
  cli_alert_info("Checking if last tag points to last commit.")
  stopifnot(tag_last_commit$commit == last_commit$commit)
  cli_alert_info("Checking if commit messages match.")
  stopifnot(is_last_commit_bump())

  cli_alert_success("Safety checks complete.")

  cli_alert("Deleting tag {.field {tag$name}}.")
  gert::git_tag_delete(tag$name)

  parent_commit_id <- gert::git_commit_info(last_commit$commit)$parent

  cli_alert_success("Resetting to parent commit {.field {parent_commit_id}}.")
  gert::git_reset_hard(parent_commit_id)

  invisible()
}
