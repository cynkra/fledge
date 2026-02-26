test_that("check_only_modified() works", {
  tempdir <- withr::local_tempdir(pattern = "fledge-commit-version")
  repo <- create_repo(tempdir)
  withr::local_dir(repo$repo)
  file.create("blop.R")
  expect_snapshot(error = TRUE, {
    check_only_modified("NEWS.md")
  })

  file.create("onemore.R")
  expect_snapshot(error = TRUE, {
    check_only_modified("NEWS.md")
  })

  file.create("onemore.R")
  expect_snapshot(error = TRUE, {
    check_only_modified(c("blop.R", "NEWS.md"))
  })
})
