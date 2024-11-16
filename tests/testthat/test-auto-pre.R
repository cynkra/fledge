test_that("pre_release() pre-flight checks", {
  withr::local_envvar("FLEDGE_TEST_NOGH" = "blop")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")

  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  local_fledge_quiet()
  bump_version()

  expect_fledge_snapshot(error = TRUE, {
    pre_release()
  })

  init_release()
  use_r("blop")

  expect_fledge_snapshot(error = TRUE, {
    pre_release()
  })
})

test_that("pre_release() works", {
  withr::local_envvar("FLEDGE_TEST_NOGH" = "blop")
  withr::local_envvar("FLEDGE_FORCE_NEWS_MD" = "bla")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")

  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  ## TODO: add test for bump_version() not run?
  local_fledge_quiet()
  bump_version()
  init_release()
  expect_true(gert::git_branch_exists("cran-0.0.1"))

  expect_fledge_snapshot({
    pre_release()
  })
})
