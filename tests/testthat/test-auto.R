test_that("extract_version_pr() works", {
  expect_equal(extract_version_pr("CRAN release v1.2.3"), "1.2.3")
  expect_equal(extract_version_pr("Let's get 1.42.3 on CRAN"), "1.42.3")
  expect_equal(extract_version_pr(" fledge 1.2.3"), "1.2.3")
})

test_that("guess_next_impl() works", {
  expect_equal(guess_next_impl("1.2.3.9007"), "patch")
  expect_equal(guess_next_impl("1.2.99.9008"), "minor")
  expect_equal(guess_next_impl("1.99.99.9009"), "major")
})

test_that("merge_dev_news() works", {
  skip_if_not_installed("rlang", "1.0.1")
  local_options(repos = NULL) # because of usethis::use_news_md() -> available.packages()
  local_demo_project(quiet = TRUE)

  use_r("bla")
  gert::git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")
  shut_up_fledge(bump_version())

  use_r("blop")
  gert::git_add("R/blop.R")
  gert::git_commit("* Add cool blop.")
  shut_up_fledge(bump_version())

  fledgeling <- read_fledgling()
  fledgeling <- merge_dev_news(fledgeling, "2.0.0")
  write_fledgling(fledgeling)
  expect_snapshot_file("NEWS.md")
})

test_that("create_release_branch() works", {
  local_demo_project(quiet = TRUE)
  gert::git_branch_create("bla")
  gert::git_branch_checkout("main")
  fledgeling <- read_fledgling()
  expect_snapshot({
    create_release_branch(fledgeling, ref = "bla")
  })

  gert::git_branch_checkout("main")
  expect_snapshot(error = TRUE, {
    create_release_branch(fledgeling, ref = "blop", force = TRUE)
  })
})

test_that("init_release() works", {
  withr::local_envvar("FLEDGE_TEST_NOGH" = "blop")
  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  shut_up_fledge(bump_version())
  expect_snapshot(init_release())
  expect_true(gert::git_branch_exists("cran-0.0.1"))
})

test_that("init_release() -- force", {
  withr::local_envvar("FLEDGE_TEST_NOGH" = "blop")
  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  shut_up_fledge(bump_version())

  gert::git_branch_create("cran-0.0.1", checkout = FALSE)

  expect_snapshot(init_release(), error = TRUE)
  expect_snapshot(init_release(force = TRUE))
  expect_true(gert::git_branch_exists("cran-0.0.1"))
})

test_that("pre_release() pre-flight checks", {
  withr::local_envvar("FLEDGE_TEST_NOGH" = "blop")

  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  shut_up_fledge(bump_version())

  expect_snapshot(pre_release(), error = TRUE)

  shut_up_fledge(init_release())
  use_r("blop")
  expect_snapshot(error = TRUE, pre_release())
})

test_that("pre_release() works", {
  withr::local_envvar("FLEDGE_TEST_NOGH" = "blop")
  withr::local_envvar("FLEDGE_FORCE_NEWS_MD" = "bla")
  withr::local_envvar("FLEDGE_TEST_NOPUSH_PRERELEASE" = "blop")

  local_demo_project(quiet = TRUE)

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  ## TODO: add test for bump_version() not run?
  shut_up_fledge(bump_version())
  shut_up_fledge(init_release())
  expect_true(gert::git_branch_exists("cran-0.0.1"))

  with_mock_dir("prerelease", {
    expect_snapshot(pre_release())
  })
})

test_that("full cycle", {
  ## not opening anything ----
  rlang::local_options(rlang_interactive = FALSE)

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
  gert::git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")
  shut_up_fledge(bump_version())
  shut_up_fledge(finalize_version(push = TRUE))

  ## init release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  expect_snapshot(init_release())
  expect_equal(gert::git_branch(), "cran-0.0.1")
  expect_setequal(
    gert::git_branch_list(local = TRUE)[["name"]],
    c("cran-0.0.1", "main")
  )
  expect_equal(as.character(desc::desc_get_version()), "0.0.1")
  expect_equal(nrow(gert::git_status()), 0)

  ## prep release ----
  expect_snapshot(pre_release())

  ## check boxes ----
  cran_comments <- get_cran_comments_text()
  writeLines(cran_comments)
  cran_comments <- gsub("- \\[ \\]", "- \\[x\\]", cran_comments)
  brio::write_lines(cran_comments, "cran-comments.md")
  gert::git_add("cran-comments.md")
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
  expect_equal(nrow(gert::git_status()), 0)
  expect_equal(gert::git_branch(), "main")
  expect_setequal(
    gert::git_tag_list()[["name"]],
    c("v0.0.0.9001", "v0.0.1", "v0.0.1.9000")
  )
})

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
  gert::git_add("R/bla.R")
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
  gert::git_add("cran-comments.md")
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
  expect_equal(nrow(gert::git_status()), 0)
  expect_equal(gert::git_branch(), "main")
  expect_setequal(
    gert::git_tag_list()[["name"]],
    c("v0.0.99.9000", "v0.1.0", "v0.1.0.9000")
  )
})

test_that("release abandon", {
  ## not opening anything ----
  rlang::local_options(rlang_interactive = FALSE)

  ## initial state ----
  local_demo_project(quiet = TRUE)

  ## create remote ----
  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  create_remote(tempdir_remote)

  ## some edits ----
  use_r("bla")
  gert::git_add("R/bla.R")
  gert::git_commit("* Add cool bla.")
  shut_up_fledge(bump_version())
  shut_up_fledge(finalize_version(push = TRUE))

  ## init release ----
  withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
  withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
  try(init_release())

  expect_snapshot(error = TRUE, {
    init_release(force = TRUE)
  })

  gert::git_branch_checkout("main")

  expect_snapshot(error = TRUE, {
    init_release(force = FALSE)
  })

  expect_snapshot(init_release(force = TRUE))
})

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
  gert::git_add("R/bla.R")
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
  gert::git_add("R/bla.R")
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
  gert::git_add("cran-comments.md")
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
  expect_snapshot(error = TRUE, post_release())

  gert::git_branch_checkout("main")
  shut_up_fledge(fledge::bump_version())
  gert::git_push()
  gert::git_branch_checkout("cran-0.0.1")

  expect_snapshot(error = TRUE, post_release())
})
