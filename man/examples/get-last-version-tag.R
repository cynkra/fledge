# Create mock package in a temporary directory.
# Set open to TRUE if you want to play in the mock package.
with_demo_project({
  # Use functions as if inside the newly created package project.
  # (Or go and actually run code inside the newly created package project!)
  # Add a new R file.
  usethis::use_r("cool-function", open = FALSE)
  # Pretend we added useful code inside it.
  # Track the new R file with Git.
  gert::git_add("R/cool-function.R")
  gert::git_commit("- Add cool function.")
  # Switch to branch for bumping version.
  gert::git_branch_create("fledge")
  # Bump version with fledge.
  fledge::bump_version(check_default_branch = FALSE)
  fledge::finalize_version()

  # Merge the version bump branch into main.
  gert::git_branch_checkout("main")
  gert::git_merge("fledge", squash = TRUE)

  print(get_top_level_commits(since = NULL))

  # get_last_tag() doesn't work in this scenario
  print(fledge::get_last_tag())

  # get_last_version_tag() is better
  print(fledge::get_last_version_tag())
})
