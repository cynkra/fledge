test_that("demo vignette works", {
  skip_on_os(c("mac", "linux"))
  test_galley("demo")
})
