test_that("release abandon", {
  ## not opening anything ----
  rlang::local_options(rlang_interactive = FALSE)

  ## initial state ----
  local_demo_project(quiet = TRUE)

  ## create remote ----
  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  ## some edits ----
  use_r("bla")
  gert::git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")
  shut_up_fledge(bump_version())
  shut_up_fledge(finalize_version(push = TRUE))

  ## init release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  shut_up_fledge(try(init_release()))

  expect_snapshot(error = TRUE, {
    init_release(force = TRUE)
  })

  gert::git_branch_checkout("main")

  expect_snapshot(error = TRUE, {
    init_release(force = FALSE)
  })

  expect_snapshot(init_release(force = TRUE))
})
