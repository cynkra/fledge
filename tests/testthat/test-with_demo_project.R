test_that("with_demo_project errors informatively", {
  skip_if_not_installed("rlang", "1.0.1")
  expect_snapshot_error(
    with_demo_project(1 + 1, dir = "unexisting-dir")
  )
})
