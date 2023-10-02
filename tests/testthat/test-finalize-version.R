test_that("finalize_version(push = FALSE)", {
  skip_if_not_installed("rlang", "1.0.1")
  skip_if_not_installed("testthat", "3.1.2")

  local_options(repos = NULL) # because of usethis::use_news_md() -> available.packages()
  local_demo_project(quiet = TRUE)

  use_r("bla")
  gert::git_add("R/bla.R")
  gert::git_commit("* Ad cool bla.")
  shut_up_fledge(bump_version())

  news <- readLines("NEWS.md")
  news <- sub("Ad cool", "Add cool", news)
  writeLines(news, "NEWS.md")

  expect_snapshot(finalize_version(push = FALSE), variant = snapshot_variant("testthat"))

  expect_snapshot_file("NEWS.md", "NEWS-push-false.md", compare = compare_file_text)
})

test_that("finalize_version(push = TRUE)", {
  skip_if_not_installed("rlang", "1.0.1")
  skip_if_not_installed("testthat", "3.1.2")

  local_options(repos = NULL) # because of usethis::use_news_md() -> available.packages()
  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  remote_url <- create_remote(tempdir_remote)
  use_r("bla")
  gert::git_add("R/bla.R")
  gert::git_commit("* Ad cool bla.")
  shut_up_fledge(bump_version())

  news <- readLines("NEWS.md")
  news <- sub("Ad cool", "Add cool", news)
  writeLines(news, "NEWS.md")

  expect_snapshot(variant = snapshot_variant("testthat"), {
    finalize_version(push = TRUE)
    show_tags(remote_url)
    show_files(remote_url)
  })

  expect_snapshot_file("NEWS.md", "NEWS-push-true.md", compare = compare_file_text)
})
