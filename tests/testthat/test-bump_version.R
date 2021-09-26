test_that("bump_version() works", {
  skip_if_not_installed("rlang", "0.4.11.9001")

  tempdir <- withr::local_tempdir(pattern = "fledge")
  repo <- create_demo_project(open = FALSE, dir = tempdir, news = TRUE)
  usethis::with_project(
    path = repo, {
      use_r("bla")
      gert::git_add("R/bla.R")
      gert::git_commit("* Add cool bla.")
      expect_snapshot(bump_version())
    }
  )
  expect_snapshot_file(
    file.path(repo, "NEWS.md"),
    compare = compare_file_text
  )
})

test_that("bump_version() works (CRAN rlang)", {
  skip_if(packageVersion("rlang") >= "0.4.11.9001")

  tempdir <- withr::local_tempdir(pattern = "fledge")
  repo <- create_demo_project(open = FALSE, dir = tempdir, news = TRUE)
  usethis::with_project(
    path = repo, {
      use_r("bla")
      gert::git_add("R/bla.R")
      gert::git_commit("* Add cool bla.")
      expect_snapshot(bump_version())
    }
  )
  expect_snapshot_file(
    file.path(repo, "NEWS.md"),
    compare = compare_file_text
  )
})
