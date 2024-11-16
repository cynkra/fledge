test_that("full cycle, add more to main NO PUSH", {
  local_fledge_quiet()
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
  bump_version()
  finalize_version(push = TRUE)

  ## init release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  expect_fledge_snapshot({
    plan_release("next")
  })

  ## add stuff on main and push ----
  gert::git_branch_checkout("main")

  brio::write_lines('"boo"', "R/bla.R")
  fast_git_add("R/bla.R")
  gert::git_commit("* Booing bla.")

  gert::git_branch_checkout("cran-0.0.1")

  ## release ----
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  expect_fledge_snapshot(transform = clean_submission_messages, {
    release()
  })
  expect_equal(nrow(gert::git_status()), 0)

  ## post release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  expect_fledge_snapshot({
    post_release()
  })
})
