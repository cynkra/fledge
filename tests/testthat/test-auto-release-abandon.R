test_that("release abandon", {
  ## not opening anything ----
  local_options(rlang_interactive = FALSE)

  ## initial state ----
  local_demo_project(quiet = TRUE)

  ## create remote ----
  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  ## some edits ----
  use_r("bla")
  fast_git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")

  local_fledge_quiet()
  bump_version()
  finalize_version(push = TRUE)

  ## init release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  expect_fledge_snapshot({
    plan_release()
  })

  expect_fledge_snapshot(error = TRUE, {
    plan_release(force = TRUE)
  })

  gert::git_branch_checkout("main")

  expect_fledge_snapshot(error = TRUE, {
    plan_release(force = FALSE)
  })

  expect_fledge_snapshot({
    plan_release(force = TRUE)
  })
})
