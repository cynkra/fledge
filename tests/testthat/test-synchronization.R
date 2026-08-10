test_that("check_tags", {
  skip_if_not_installed("rlang", "1.0.1")
  skip_if_not_installed("testthat", "3.1.2")

  local_demo_project(quiet = TRUE)
  expect_snapshot(check_tags())
  shut_up_fledge(tag_version())
  expect_null(expect_silent(check_tags()))
})
