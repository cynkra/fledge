test_that("extract_version_pr() works", {
  expect_equal(extract_version_pr("CRAN release v1.2.3"), "1.2.3")
  expect_equal(extract_version_pr("Let's get 1.42.3 on CRAN"), "1.42.3")
  expect_equal(extract_version_pr(" fledge 1.2.3"), "1.2.3")
})

test_that("guess_next_impl() works", {
  expect_equal(guess_next_impl("1.2.3.9007"), "patch")
  expect_equal(guess_next_impl("1.2.99.9008"), "minor")
  expect_equal(guess_next_impl("1.99.99.9009"), "major")
})

test_that("merge_dev_news() works", {
  skip_if_not_installed("rlang", "1.0.1")
  local_options(repos = NULL) # because of usethis::use_news_md() -> available.packages()
  local_demo_project(quiet = TRUE)

  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")

  use_r("bla")
  gert::git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")
  shut_up_fledge(bump_version())

  use_r("blop")
  gert::git_add("R/blop.R")
  gert::git_commit("* Add cool blop.")
  shut_up_fledge(bump_version())

  fledgeling <- read_fledgling()
  fledgeling <- merge_dev_news(fledgeling, "2.0.0")
  write_fledgling(fledgeling)
  expect_snapshot_file("NEWS.md")
})

test_that("create_release_branch() works", {
  local_demo_project(quiet = TRUE)
  gert::git_branch_create("bla")
  gert::git_branch_checkout("main")

  expect_snapshot({
    create_release_branch("0.0.1", ref = "bla")
  })

  gert::git_branch_checkout("main")
  expect_snapshot(error = TRUE, {
    create_release_branch("0.0.1", ref = "blop", force = TRUE)
  })
})

test_that("init_release() works", {
  withr::local_envvar("FLEDGE_TEST_NOGH" = "blop")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  shut_up_fledge(bump_version())
  expect_snapshot(init_release())
  expect_true(gert::git_branch_exists("cran-0.0.1"))
})

test_that("init_release() -- force", {
  withr::local_envvar("FLEDGE_TEST_NOGH" = "blop")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  shut_up_fledge(bump_version())

  gert::git_branch_create("cran-0.0.1", checkout = FALSE)

  expect_snapshot(init_release(), error = TRUE)
  expect_snapshot(init_release(force = TRUE))
  expect_true(gert::git_branch_exists("cran-0.0.1"))
})
