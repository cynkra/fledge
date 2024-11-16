test_that("full cycle pre-minor", {
  ## not opening anything ----
  rlang::local_options(rlang_interactive = FALSE)

  ## initial state ----
  local_demo_project(quiet = TRUE)

  ## create remote ----
  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  ## some edits ----
  use_r("bla")
  fast_git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")
  shut_up_fledge(bump_version(which = "pre-minor"))
  shut_up_fledge(finalize_version(push = TRUE))

  expect_equal(
    as.character(desc::desc_get_version()),
    "0.0.99.9000"
  )

  ## init release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  expect_snapshot(init_release())
  expect_equal(gert::git_branch(), "cran-0.1.0")
  expect_setequal(
    gert::git_branch_list(local = TRUE)[["name"]],
    c("cran-0.1.0", "main")
  )
  expect_equal(as.character(desc::desc_get_version()), "0.1.0")
  expect_equal(nrow(gert::git_status()), 0)

  ## prep release ----
  expect_snapshot(pre_release())

  ## check boxes ----
  cran_comments <- get_cran_comments_text()
  writeLines(cran_comments)
  cran_comments <- gsub("- \\[ \\]", "- \\[x\\]", cran_comments)
  brio::write_lines(cran_comments, "cran-comments.md")
  fast_git_add("cran-comments.md")
  gert::git_commit("this is how we check boxes")

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
    c("v0.0.99.9000", "v0.1.0")
  )
})
