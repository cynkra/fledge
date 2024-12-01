test_that("bump_version() works -- dev", {
  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  use_r("bla")
  fast_git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")

  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9000")

  expect_snapshot(bump_version())

  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9001")
  expect_equal(get_last_version_tag()[["name"]], "v0.0.0.9001")
  expect_snapshot_file("NEWS.md", compare = compare_file_text)

  cat("\n", file = "NEWS.md", append = TRUE)
  fast_git_add("NEWS.md")
  gert::git_commit("fledge: Edit NEWS.")

  ## no changes ----
  expect_snapshot(error = TRUE, {
    bump_version(no_change_behavior = "fail")
  })

  expect_snapshot(bump_version(no_change_behavior = "noop"))
  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9001")
  expect_equal(get_last_version_tag()[["name"]], "v0.0.0.9001")

  expect_snapshot(bump_version(no_change_behavior = "bump"))
  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9002")
  expect_equal(get_last_version_tag()[["name"]], "v0.0.0.9002")
  expect_snapshot_file("NEWS.md", "NEWS2.md", compare = compare_file_text)
})

test_that("bump_version() works -- dev squash", {
  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  use_r("bla")
  fast_git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")

  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9000")

  gert::git_branch_create("fledge")

  expect_snapshot(bump_version(check_default_branch = FALSE))

  gert::git_branch_checkout("main")
  gert::git_merge("fledge", squash = TRUE)

  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9001")
  expect_equal(get_last_version_tag()[["name"]], "v0.0.0.9001")
  expect_snapshot_file("NEWS.md", compare = compare_file_text)

  cat("\n", file = "NEWS.md", append = TRUE)
  fast_git_add("NEWS.md")
  gert::git_commit("fledge: Edit NEWS.")

  ## no changes ----
  expect_snapshot(error = TRUE, {
    bump_version(no_change_behavior = "fail")
  })

  expect_snapshot(bump_version(no_change_behavior = "noop"))
  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9001")
  expect_equal(get_last_version_tag()[["name"]], "v0.0.0.9001")

  expect_snapshot(bump_version(no_change_behavior = "bump"))
  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9002")
  expect_equal(get_last_version_tag()[["name"]], "v0.0.0.9002")
  expect_snapshot_file("NEWS.md", "NEWS3.md", compare = compare_file_text)
})

test_that("bump_version() works -- not dev", {
  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  use_r("bla")
  fast_git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")

  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9000")

  expect_snapshot(bump_version(which = "major"))
  expect_equal(as.character(desc::desc_get_version()), "1.0.0")
  expect_snapshot_file("NEWS.md", "NEWS-nondev.md", compare = compare_file_text)
})

test_that("bump_version() errors informatively for forbidden notifications", {
  local_demo_project(quiet = TRUE)

  use_r("bla")
  fast_git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")

  desc::desc_set_dep("bla")

  expect_snapshot(error = TRUE, bump_version())
})

test_that("bump_version() errors informatively for wrong branch", {
  local_demo_project(quiet = TRUE)

  use_r("bla")
  fast_git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")

  gert::git_branch_create("bla", checkout = TRUE)

  expect_snapshot(error = TRUE, bump_version())
})


test_that("bump_version() errors well for wrong arguments", {
  expect_snapshot(error = TRUE, bump_version(no_change_behavior = "blabla"))

  expect_snapshot(error = TRUE, bump_version(which = "blabla"))
})

test_that("bump_version() does nothing if no preamble and not interactive", {
  local_demo_project(quiet = TRUE)

  news_lines <- readLines("NEWS.md")
  preamble_lines <- 1:2
  brio::write_lines(news_lines[-preamble_lines], "NEWS.md")

  expect_snapshot(bump_version())
})
