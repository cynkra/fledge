test_that("unbump_version() works", {
  withr::local_envvar(list("FLEDGE_UNBUMP_TEST_COMMIT" = "42"))
  tempdir <- withr::local_tempdir(pattern = "fledge")
  repo <- create_demo_project(open = FALSE, dir = tempdir, news = TRUE)
  usethis::with_project(
    path = repo, {
      use_r("bla")
      gert::git_add("R/bla.R")
      gert::git_commit("* Add cool bla.")
      testthat::expect_snapshot({
        bump_version()
        unbump_version()
        use_r("blop")
        gert::git_add("R/blop.R")
        c <- gert::git_commit("* Add cool blop.")
        bump_version()
      })
    },
    quiet = TRUE
  )
  testthat::expect_snapshot_file(
    file.path(repo, "NEWS.md"),
    compare = compare_file_text
  )
})
