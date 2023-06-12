test_that("unbump_version() works", {
  testthat::skip_if_offline()
  skip_if_not_installed("rlang", "1.0.1")

  tempdir <- withr::local_tempdir(pattern = "fledge-unbump")
  rlang::local_interactive(value = FALSE)
  repo <- create_demo_project(
    open = FALSE,
    dir = tempdir,
    news = TRUE,
    maintainer = "Jane Doe",
    email = "mail@example.com"
  )
  usethis::with_project(
    path = repo,
    {
      withr::local_options(usethis.quiet = TRUE)
      withr::local_envvar(FLEDGE_UNBUMP_TEST_COMMIT = "42")
      use_r("bla")
      gert::git_add("R/bla.R")
      gert::git_commit("* Add cool bla.", author = default_gert_author(), committer = default_gert_committer())
      testthat::expect_snapshot(variant = snapshot_variant("testthat"), {
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
