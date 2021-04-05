test_that("demo.Rmd does not change", {
  dir <- usethis::proj_get()
  withr::with_dir(dir, {
    old <- readLines("vignettes/out/demo.md")
    callr::r(function() galley::galley_article("demo"))
    new <- readLines("vignettes/out/demo.md")
  })
  expect_equal(old, new)
})
