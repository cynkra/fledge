test_that("extract_version_pr() works", {
  expect_equal(extract_version_pr("CRAN release v1.2.3"), "1.2.3")
})

test_that("guess_next() works", {
  expect_equal(guess_next("1.2.3.9007"), "patch")
  expect_equal(guess_next("1.2.99.9008"), "minor")
  expect_equal(guess_next("1.99.99.9009"), "major")
})

test_that("merge_dev_news() works", {
  skip_if_not_installed("rlang", "1.0.1")
  local_fledge_quiet()
  local_options(repos = NULL) # because of usethis::use_news_md() -> available.packages()
  local_demo_project(quiet = TRUE)

  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")

  use_r("bla")
  fast_git_add("R/bla.R")
  gert::git_commit("* Add cool bla (@someone, #hashtag-test).")
  bump_version()

  use_r("blop")
  fast_git_add("R/blop.R")
  gert::git_commit("* Add cool blop.")
  bump_version()

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

test_that("plan_release() -- force", {
  withr::local_envvar("FLEDGE_TEST_NOGH" = "blop")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  local_fledge_quiet()
  bump_version()

  gert::git_branch_create("cran-0.0.0.9900", checkout = FALSE)

  expect_fledge_snapshot(transform = scrub_hash, error = TRUE, {
    plan_release()
  })
  expect_fledge_snapshot(transform = scrub_hash, {
    plan_release(force = TRUE)
  })
  expect_true(gert::git_branch_exists("cran-0.0.0.9900"))
})
