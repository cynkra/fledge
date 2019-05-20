#' @rdname unbump_version
#' @usage NULL
unbump_version_impl <- function() {
  tag <- get_last_tag()
  last_commit <- git2r::last_commit()

  usethis::ui_info("Checking if working copy is clean.")
  stopifnot(sum(map_int(git2r::status(), length)) == 0)
  usethis::ui_info("Checking if last tag points to last commit.")
  stopifnot(tag$target == last_commit$sha)
  usethis::ui_info("Checking if commit messages match.")
  stopifnot(is_last_commit_bump())

  usethis::ui_done("Safety checks complete")

  usethis::ui_info("Deleting tag {usethis::ui_value(tag$name)}.")
  git2r::tag_delete(tag)

  parent_commit <- git2r::parents(last_commit)[[1]]
  usethis::ui_info("Resetting to parent commit {parent_commit$sha}.")
  git2r::reset(parent_commit, "hard")
}
