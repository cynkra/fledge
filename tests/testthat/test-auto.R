test_that("extract_version_pr() works", {
  expect_equal(extract_version_pr("CRAN release v1.2.3"), "1.2.3")
  expect_equal(extract_version_pr("Let's get 1.42.3 on CRAN"), "1.42.3")
  expect_equal(extract_version_pr(" fledge 1.2.3"), "1.2.3")
})

test_that("guess_next_impl() works", {
  expect_snapshot({
    guess_next_impl("1.2.3.9007")
    guess_next_impl("1.2.99.9008")
    guess_next_impl("1.99.99.9009")
  })
})

test_that("init_release() works", {
  local_options(repos = NULL) # because of usethis::use_news_md() -> available.packages()
  local_demo_project(quiet = TRUE)

  # TODO: add test for bump_version() not run?
  expect_snapshot(bump_version())
  expect_snapshot(init_release())
  expect_true(gert::git_branch_exists("cran-0.0.1"))
})

test_that("init_release() -- force", {
  local_options(repos = NULL) # because of usethis::use_news_md() -> available.packages()
  local_demo_project(quiet = TRUE)

  expect_snapshot(bump_version())

  gert::git_branch_create("cran-0.0.1", checkout = FALSE)

  expect_snapshot(init_release(), error = TRUE)
  expect_snapshot(init_release(force = TRUE))
  expect_true(gert::git_branch_exists("cran-0.0.1"))
})
