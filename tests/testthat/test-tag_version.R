test_that("tag_version() works", {
  local_fledge_quiet()
  local_demo_project(quiet = TRUE)

  use_r("bla")
  fast_git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")

  expect_snapshot({
    tag_version()
    get_last_version_tag()[, c("name", "ref")]
  })

  ## Attempting tagging again without any new commit ----
  tag_version()

  ## Attempting tagging again ----
  # with a new commit but same version
  use_r("pof")
  fast_git_add("R/pof.R")
  gert::git_commit("* Add cool pof.")

  expect_snapshot(error = TRUE, {
    tag_version(force = FALSE)
  })

  ## Same, but forcing ----
  expect_fledge_snapshot({
    tag_version(force = TRUE)
    get_last_version_tag()[, c("name", "ref")]
  })
})
