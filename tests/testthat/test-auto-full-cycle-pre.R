test_that("full cycle pre-minor", {
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
  bump_version(which = "pre-minor")
  finalize_version(push = TRUE)

  expect_equal(
    as.character(desc::desc_get_version()),
    "0.0.99.9900"
  )

  ## init release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  expect_fledge_snapshot({
    plan_release("next")
  })
  expect_equal(gert::git_branch(), "cran-0.1.0")
  expect_setequal(
    gert::git_branch_list(local = TRUE)[["name"]],
    c("cran-0.1.0", "main")
  )
  expect_equal(as.character(desc::desc_get_version()), "0.1.0")
  expect_equal(nrow(gert::git_status()), 0)

  ## release ----
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  expect_fledge_snapshot(
    release(),
    transform = clean_submission_messages
  )
  expect_equal(nrow(gert::git_status()), 0)

  gert::git_branch_checkout("main")
  expect_equal(nrow(gert::git_status()), 0)

  ## post release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  expect_fledge_snapshot({
    post_release()
  })
  expect_equal(nrow(gert::git_status()), 0)
  expect_setequal(
    gert::git_tag_list()[["name"]],
    c("v0.0.99.9900", "v0.1.0")
  )
})
