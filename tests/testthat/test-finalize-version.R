
test_that("finalize_version()", {

  with_demo_project({
    create_remote()
    use_r("bla")
    gert::git_add("R/bla.R")
    gert::git_commit("* Add cool bla.")
    bump_version()
    gert::git_push()
    expect_snapshot(finalize_version(push = TRUE), variant = rlang_version())
    expect_snapshot_file(
      file.path(getwd(), "NEWS.md"),
      compare = compare_file_text
    )
    expect_snapshot(show_tags(file.path(getwd(), "remote")))
  })
})
