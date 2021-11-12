test_that("bump_version() works", {
  tempdir <- withr::local_tempdir(pattern = "fledge")
  repo <- create_demo_project(open = FALSE, dir = tempdir, news = TRUE)
  usethis::with_project(
    path = repo, {
      use_r("bla")
      gert::git_add("R/bla.R")
      gert::git_commit("* Add cool bla.")
      expect_snapshot(
        bump_version(), variant = rlang_version())
    }
  )
  expect_snapshot_file(
    file.path(repo, "NEWS.md"),
    compare = compare_file_text
  )
})

test_that("bump_version() errors informatively for forbidden notifications", {

  tempdir <- withr::local_tempdir(pattern = "fledge")
  repo <- create_demo_project(open = FALSE, dir = tempdir, news = TRUE)
  usethis::with_project(
    path = repo, {
      use_r("bla")
      gert::git_add("R/bla.R")
      gert::git_commit("* Add cool bla.")
      desc::desc_set_dep("bla")
      expect_snapshot_error(bump_version(), variant = rlang_version())
    }
  )
})

test_that("bump_version() errors informatively for wrong branch", {

  tempdir <- withr::local_tempdir(pattern = "fledge")
  repo <- create_demo_project(open = FALSE, dir = tempdir, news = TRUE)
  usethis::with_project(
    path = repo, {
      use_r("bla")
      gert::git_add("R/bla.R")
      gert::git_commit("* Add cool bla.")
      gert::git_branch_create("bla")
      expect_snapshot_error(bump_version(), variant = rlang_version())
    }
  )
})
