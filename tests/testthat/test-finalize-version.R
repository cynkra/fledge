test_that("finalize_version(push = FALSE)", {

  local_demo_project(quiet = TRUE)

  use_r("bla")
  gert::git_add("R/bla.R")
  gert::git_commit("* Ad cool bla.")

  shut_up_fledge(bump_version())

  news <- brio::read_lines("NEWS.md")
  news <- sub("Ad cool", "Add cool", news)
  brio::write_lines(news, "NEWS.md")

  expect_snapshot(finalize_version(push = FALSE))

  expect_snapshot_file(
    "NEWS.md", "NEWS-push-false.md",
    compare = compare_file_text
  )
})

test_that("finalize_version(push = TRUE)", {

  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  remote_url <- create_remote(tempdir_remote)

  use_r("bla")
  gert::git_add("R/bla.R")
  gert::git_commit("* Ad cool bla.")

  shut_up_fledge(bump_version())

  news <- brio::read_lines("NEWS.md")
  news <- sub("Ad cool", "Add cool", news)
  brio::write_lines(news, "NEWS.md")

  expect_snapshot({
    finalize_version(push = TRUE)
    show_tags(remote_url)
    show_files(remote_url)
  })

  expect_snapshot_file(
    "NEWS.md", "NEWS-push-true.md",
    compare = compare_file_text
  )
})
