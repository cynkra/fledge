#' @rdname unbump_version
#' @usage NULL
unbump_version_impl <- function() {
  tag <- get_last_tag()
  last_commit <- git2r::last_commit()

  ui_info("Checking if working copy is clean")
  stopifnot(sum(map_int(git2r::status(), length)) == 0)
  ui_info("Checking if last tag points to last commit")
  stopifnot(tag$target == last_commit$sha)
  ui_info("Checking if commit messages match")
  stopifnot(is_last_commit_bump())

  ui_done("Safety checks complete")

  ui_done("Deleting tag {ui_value(tag$name)}")
  git2r::tag_delete(tag)

  parent_commit <- git2r::parents(last_commit)[[1]]
  ui_done("Resetting to parent commit {ui_value(parent_commit$sha)}")
  git2r::reset(parent_commit, "hard")
}
