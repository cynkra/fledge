test_that("bump_version() works -- dev", {
  skip_if_not_installed("rlang", "1.0.1")

  news_tempdir <- withr::local_tempdir(pattern = "news")

  with_demo_project(quiet = TRUE, {
    create_remote()
    use_r("bla")
    gert::git_add("R/bla.R")
    gert::git_commit("* Add cool bla.")
    expect_equal(as.character(desc::desc_get_version()), "0.0.0.9000")
    expect_snapshot(bump_version(), variant = snapshot_variant("testthat"))
    expect_equal(as.character(desc::desc_get_version()), "0.0.0.9001")
    expect_equal(get_last_tag()$name, "v0.0.0.9001")
    file.copy("NEWS.md", file.path(news_tempdir, "NEWS.md"))
  })

  expect_snapshot_file(
    file.path(news_tempdir, "NEWS.md"),
    compare = compare_file_text
  )
})

test_that("bump_version() works -- not dev", {
  skip_if_not_installed("rlang", "1.0.1")

  news_tempdir <- withr::local_tempdir(pattern = "news")

  with_demo_project(quiet = TRUE, {
    create_remote()
    use_r("bla")
    gert::git_add("R/bla.R")
    gert::git_commit("* Add cool bla.")
    expect_equal(as.character(desc::desc_get_version()), "0.0.0.9000")
    expect_snapshot(bump_version(which = "major"), variant = snapshot_variant("testthat"))
    expect_equal(as.character(desc::desc_get_version()), "1.0.0")
    file.copy("NEWS.md", file.path(news_tempdir, "NEWS-nondev.md"))
  })

  expect_snapshot_file(
    file.path(news_tempdir, "NEWS-nondev.md"),
    compare = compare_file_text
  )
})

test_that("bump_version() errors informatively for forbidden notifications", {
  skip_if_not_installed("rlang", "1.0.1")

  with_demo_project(quiet = TRUE, {
    use_r("bla")
    gert::git_add("R/bla.R")
    gert::git_commit("* Add cool bla.")
    desc::desc_set_dep("bla")
    expect_snapshot_error(bump_version())
  })
})

test_that("bump_version() errors informatively for wrong branch", {
  skip_if_not_installed("rlang", "1.0.1")

  with_demo_project(quiet = TRUE, {
    use_r("bla")
    gert::git_add("R/bla.R")
    gert::git_commit("* Add cool bla.")
    gert::git_branch_create("bla")
    expect_snapshot_error(bump_version())
  })
})
