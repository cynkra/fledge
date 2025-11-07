# Package index

## Main functions

- [`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
  : Bump package version
- [`commit_version()`](https://fledge.cynkra.com/dev/reference/commit_version.md)
  : Commits NEWS.md and DESCRIPTION to Git
- [`finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md)
  : Finalize package version
- [`unbump_version()`](https://fledge.cynkra.com/dev/reference/unbump_version.md)
  : Undoes bumping the package version
- [`plan_release()`](https://fledge.cynkra.com/dev/reference/release.md)
  [`release()`](https://fledge.cynkra.com/dev/reference/release.md)
  [`post_release()`](https://fledge.cynkra.com/dev/reference/release.md)
  : Automating CRAN release

## Lower-level functions

- [`get_last_version_tag()`](https://fledge.cynkra.com/dev/reference/get_last_version_tag.md)
  : The most recent versioned tag
- [`get_top_level_commits()`](https://fledge.cynkra.com/dev/reference/get_top_level_commits.md)
  : All top-level commits
- [`tag_version()`](https://fledge.cynkra.com/dev/reference/tag_version.md)
  : Create a new version tag
- [`update_news()`](https://fledge.cynkra.com/dev/reference/update_news.md)
  : Update NEWS.md with messages from top-level commits
- [`get_last_tag()`](https://fledge.cynkra.com/dev/reference/get_last_tag.md)
  : The most recent tag

## Helper for fledge demonstration

- [`create_demo_project()`](https://fledge.cynkra.com/dev/reference/create_demo_project.md)
  : Create example repo for fledge demos
- [`with_demo_project()`](https://fledge.cynkra.com/dev/reference/with_demo_project.md)
  [`local_demo_project()`](https://fledge.cynkra.com/dev/reference/with_demo_project.md)
  : Run code in temporary project
