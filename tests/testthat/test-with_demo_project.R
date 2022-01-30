test_that("with_demo_project errors informatively", {
  expect_snapshot_error(
    with_demo_project(1 + 1, dir = "unexisting-dir"),
    variant = rlang_version()
  )
})
