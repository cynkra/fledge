test_that("bump_version() works -- dev", {
  skip_if_not_installed("rlang", "1.0.1")
  skip_if_not_installed("testthat", "3.1.2")

  local_demo_project(quiet = TRUE)

  create_remote()
  use_r("bla")
  gert::git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")
  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9000")
  expect_snapshot(bump_version(), variant = snapshot_variant("testthat"))
  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9001")
  expect_equal(get_last_tag()$name, "v0.0.0.9001")
  expect_snapshot_file("NEWS.md", compare = compare_file_text)

  ## no changes
  expect_snapshot_error(bump_version(no_change_behavior = "fail"), variant = snapshot_variant("testthat"))
  expect_snapshot(bump_version(no_change_behavior = "noop"), variant = snapshot_variant("testthat"))
  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9001")
  expect_equal(get_last_tag()$name, "v0.0.0.9001")
  expect_snapshot(bump_version(no_change_behavior = "bump"), variant = snapshot_variant("testthat"))
  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9002")
  expect_equal(get_last_tag()$name, "v0.0.0.9002")
  expect_snapshot_file("NEWS.md", "NEWS2.md", compare = compare_file_text)
})

test_that("bump_version() works -- not dev", {
  skip_if_not_installed("rlang", "1.0.1")
  skip_if_not_installed("testthat", "3.1.2")

  local_demo_project(quiet = TRUE)

  create_remote()
  use_r("bla")
  gert::git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")
  expect_equal(as.character(desc::desc_get_version()), "0.0.0.9000")
  expect_snapshot(bump_version(which = "major"), variant = snapshot_variant("testthat"))
  expect_equal(as.character(desc::desc_get_version()), "1.0.0")
  expect_snapshot_file("NEWS.md", "NEWS-nondev.md", compare = compare_file_text)
})

test_that("bump_version() errors informatively for forbidden notifications", {
  skip_if_not_installed("rlang", "1.0.1")

  local_demo_project(quiet = TRUE)

  use_r("bla")
  gert::git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")
  desc::desc_set_dep("bla")
  expect_snapshot_error(bump_version())
})

test_that("bump_version() errors informatively for wrong branch", {
  skip_if_not_installed("rlang", "1.0.1")

  local_demo_project(quiet = TRUE)

  use_r("bla")
  gert::git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")
  gert::git_branch_create("bla")
  expect_snapshot_error(bump_version())
})
