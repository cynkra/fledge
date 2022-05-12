test_that("Can parse conventional commits", {
  repo <- withr::local_tempdir()
  withr::local_dir(repo)
  create_cc_repo(repo)
  messages <- get_top_level_commits_impl(since = NULL)$message
  expect_snapshot(collect_news(messages))
})
