test_that("unbump_version() works", {
  tempdir <- withr::local_tempdir(pattern = "fledge-unbump")
  repo <- create_demo_project(open = FALSE, dir = tempdir, news = TRUE)
  usethis::with_project(
    path = repo, {
      use_r("bla")
      gert::git_add("R/bla.R")
      gert::git_commit("* Add cool bla.", author = default_gert_author(), committer = default_gert_committer())
      testthat::expect_snapshot({
        bump_version()
        unbump_version()
        use_r("blop")
        gert::git_add("R/blop.R")
        c <- gert::git_commit("* Add cool blop.", author = default_gert_author(), committer = default_gert_committer())
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
