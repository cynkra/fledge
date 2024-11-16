test_that("full cycle, add more to main", {
  rlang::local_options("fledge.quiet" = TRUE)
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
  shut_up_fledge(bump_version())
  shut_up_fledge(finalize_version(push = TRUE))

  ## init release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  shut_up_fledge(init_release())

  ## add stuff on main and push ----
  gert::git_branch_checkout("main")

  brio::write_lines('"boo"', "R/bla.R")
  fast_git_add("R/bla.R")
  gert::git_commit("* Booing bla.")
  gert::git_push()

  gert::git_branch_checkout("cran-0.0.1")

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

  ## post release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  expect_snapshot(post_release())

  gert::git_branch_checkout("main")
  shut_up_fledge(fledge::bump_version())
  gert::git_push()
  gert::git_branch_checkout("cran-0.0.1")

  expect_snapshot(post_release())
})
