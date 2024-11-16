test_that("full cycle", {
  ## not opening anything ----
  local_options(rlang_interactive = FALSE)

  ## initial state ----
  local_demo_project(quiet = TRUE)

  ## create remote ----
  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  expect_setequal(
    fs::dir_ls(),
    c("DESCRIPTION", "NAMESPACE", "NEWS.md", "R", "tea.Rproj")
  )
  expect_contains(gert::git_remote_list()[["name"]], "origin")

  ## some edits ----
  use_r("bla")
  fast_git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")

  local_fledge_quiet()
  bump_version()
  finalize_version(push = TRUE)

  ## init release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  expect_fledge_snapshot({
    init_release()
  })
  expect_equal(gert::git_branch(), "cran-0.0.1")
  expect_setequal(
    gert::git_branch_list(local = TRUE)[["name"]],
    c("cran-0.0.1", "main")
  )
  expect_equal(as.character(desc::desc_get_version()), "0.0.1")
  expect_equal(nrow(gert::git_status()), 0)

  ## check boxes first ----
  cran_comments <- get_cran_comments_text()
  cran_comments <- gsub("- \\[ \\]", "- \\[x\\]", cran_comments)
  brio::write_lines(cran_comments, "cran-comments.md")

  ## prep release ----
  expect_fledge_snapshot({
    pre_release()
  })

  ## release ----
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  expect_snapshot(
    release(),
    transform = clean_submission_messages
  )
  expect_equal(nrow(gert::git_status()), 0)

  gert::git_branch_checkout("main")
  expect_equal(nrow(gert::git_status()), 0)

  ## post release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  expect_snapshot(post_release())
  expect_equal(nrow(gert::git_status()), 0)
  expect_setequal(
    gert::git_tag_list()[["name"]],
    c("v0.0.0.9001", "v0.0.1")
  )
})
