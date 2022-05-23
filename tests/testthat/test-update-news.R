test_that("add_to_news works when news file still empty", {
  temp_dir <- withr::local_tempdir()
  temp_news <- file.path(temp_dir, "NEWS-empty.md")
  file.create(temp_news)
  mockery::stub(
    where = add_to_news,
    what = "news_path",
    how = temp_news
  )
  add_to_news("* Cool stuff!")
  expect_snapshot_file(temp_news)
})


test_that("add_to_news works when no news file yet", {
  temp_dir <- withr::local_tempdir()
  temp_news <- file.path(temp_dir, "NEWS-new.md")
  mockery::stub(
    where = add_to_news,
    what = "news_path",
    how = temp_news
  )
  add_to_news("* Cool stuff!")
  expect_snapshot_file(temp_news)
})

test_that("Can parse conventional commits", {
  repo <- withr::local_tempdir()
  withr::local_dir(repo)
  create_cc_repo(repo)
  messages <- get_top_level_commits_impl(since = NULL)$message
  update_news(messages)
  expect_snapshot_file("NEWS.md")
})

test_that("Can parse PR merge commits", {
  withr::local_envvar("FLEDGE_TEST_GITHUB_SLUG" = "cynkra/fledge")
  httptest::with_mock_dir("pr", {
    withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
    expect_snapshot(extract_newsworthy_items("Merge pull request #332 from cynkra/conventional-parsing"))
  })
})

test_that("Can parse PR merge commits - internet error", {
  withr::local_envvar("FLEDGE_TEST_GITHUB_SLUG" = "cynkra/fledge")
  withr::local_envvar("NO_INTERNET_TEST_FLEDGE" = "blop")
  expect_snapshot(extract_newsworthy_items("Merge pull request #332 from cynkra/conventional-parsing"))
})

test_that("Can parse PR merge commits - PAT error", {
  withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
  withr::local_envvar("FLEDGE_TEST_NO_PAT" = "blop")
  expect_snapshot_error(extract_newsworthy_items("Merge pull request #332 from cynkra/conventional-parsing"))
})

test_that("Can parse PR merge commits - other error", {
  withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
  withr::local_envvar("FLEDGE_TEST_GITHUB_SLUG" = "cynkra/fledge")
  bla <- function(...) stop("bla")
  mockery::stub(harvest_pr_data, "gh::gh", bla)
  expect_snapshot(harvest_pr_data("Merge pull request #332 from cynkra/conventional-parsing"))
})
