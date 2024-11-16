test_that("unbump_version() works", {
  rlang::local_interactive(value = FALSE)
  withr::local_options(usethis.quiet = TRUE)
  withr::local_envvar(FLEDGE_UNBUMP_TEST_COMMIT = "42")

  local_demo_project(quiet = TRUE)

  use_r("bla")
  fast_git_add("R/bla.R")
  gert::git_commit("* Add cool bla.", author = default_gert_author(), committer = default_gert_committer())

  testthat::expect_snapshot({
    bump_version()
    unbump_version()
    use_r("blop")
    fast_git_add("R/blop.R")
    c <- gert::git_commit("* Add cool blop.", author = default_gert_author(), committer = default_gert_committer())
    bump_version()
  })

  testthat::expect_snapshot_file("NEWS.md", compare = compare_file_text)
})
