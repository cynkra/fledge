test_that("bump_version() works", {

  with_demo_project({
    use_r("bla")
    gert::git_add("R/bla.R")
    gert::git_commit("* Add cool bla.")
    expect_snapshot(bump_version(), variant = as.character(packageVersion("rlang")))
    expect_snapshot_file(
      file.path(getwd(), "NEWS.md"),
      compare = compare_file_text
    )
  })
})

