#' @rdname unbump_version
#' @usage NULL
unbump_version_impl <- function() {
  tag <- get_last_tag()
  last_commit <- git2r::last_commit()

  cli_alert_info("Checking if working copy is clean.")
  stopifnot(sum(map_int(git2r::status(), length)) == 0)
  cli_alert_info("Checking if last tag points to last commit.")
  stopifnot(tag$target == last_commit$sha)
  cli_alert_info("Checking if commit messages match.")
  stopifnot(is_last_commit_bump())

  cli_alert_success("Safety checks complete.")

  cli_alert("Deleting tag {.field {tag$name}}.")
  git2r::tag_delete(tag)

  parent_commit <- git2r::parents(last_commit)[[1]]
  cli_alert_success("Resetting to parent commit {.field {parent_commit$sha}}.")
  git2r::reset(parent_commit, "hard")
}
