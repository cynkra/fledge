test_that("bump_version() works", {
  tempdir <- withr::local_tempdir(pattern = "fledge")
  repo <- create_demo_project(open = FALSE, dir = tempdir, news = TRUE)
  usethis::with_project(
    path = repo, {
      use_r("bla")
      gert::git_add("R/bla.R")
      gert::git_commit("* Add cool bla.")
      bump_version()
    }
  )
  testthat::expect_snapshot_file(file.path(repo, "NEWS.md"))
})
