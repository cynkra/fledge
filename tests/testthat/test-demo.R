test_that("demo.Rmd does not change", {
  dir <- usethis::proj_get()
  withr::with_dir(dir, {
    old <- system.file("vignettes/out/demo.md", package = "fledge")
    callr::r(function() galley::galley_article("demo"))
    new <- system.file("vignettes/out/demo.md", package = "fledge")
  })
  expect_equal(old, new)
})
