test_that("with_demo_project errors informatively", {
  expect_snapshot(error = TRUE, {
    with_demo_project(1 + 1, dir = "unexisting-dir")
  })
})
