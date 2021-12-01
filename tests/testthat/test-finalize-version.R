test_that("finalize_version(push = FALSE)", {

  news_tempdir <- withr::local_tempdir(pattern = "news")

  with_demo_project({
    use_r("bla")
    gert::git_add("R/bla.R")
    gert::git_commit("* Add cool bla.")
    bump_version()
    expect_snapshot(finalize_version(push = FALSE), variant = rlang_version())
    file.copy("NEWS.md", file.path(news_tempdir, "NEWS-push-false.md"))
  })

  expect_snapshot_file(
    file.path(news_tempdir, "NEWS-push-false.md"),
    compare = compare_file_text
  )
})

test_that("finalize_version(push = TRUE)", {

  news_tempdir <- withr::local_tempdir(pattern = "news")

  with_demo_project({
    remote_url <- create_remote()
    use_r("bla")
    gert::git_add("R/bla.R")
    gert::git_commit("* Add cool bla.")
    bump_version()
    gert::git_push()
    expect_snapshot(finalize_version(push = TRUE), variant = rlang_version())
    file.copy("NEWS.md", file.path(news_tempdir, "NEWS-push-true.md"))
    expect_snapshot(gert::libgit2_config())
    expect_snapshot(show_tags(remote_url))
    expect_snapshot(show_files(remote_url))
  })

  expect_snapshot_file(
    file.path(news_tempdir, "NEWS-push-true.md"),
    compare = compare_file_text
  )
})
