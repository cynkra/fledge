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

test_that("pre_release() pre-flight checks", {
  skip_if_not_installed("rlang", "1.0.1")

  local_options("fledge.quiet" = TRUE)
  local_options(repos = NULL) # because of usethis::use_news_md() -> available.packages()
  local_demo_project(quiet = TRUE)
  bump_version()

  expect_snapshot(pre_release(), error = TRUE)

  expect_output(init_release())
  use_r("blop")
  expect_snapshot(pre_release(), error = TRUE)
})
