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

  usethis::with_project(
    repo,
    usethis::use_description(fields = list(Package = "fledge")),
    force = TRUE
  )
  update_news(messages)
  expect_snapshot_file("NEWS.md")
})

test_that("Can parse Co-authored-by", {
  expect_snapshot(extract_newsworthy_items("- blop\n-blip\n\nCo-authored-by: Person (<person@users.noreply.github.com>)"))
  expect_snapshot(extract_newsworthy_items("- blop (#42)\n\nCo-authored-by: Person (<person@users.noreply.github.com>)\nCo-authored-by: Someone Else (<else@users.noreply.github.com>)"))
  expect_snapshot(extract_newsworthy_items("feat: blop (#42)\n\nCo-authored-by: Person (<person@users.noreply.github.com>)"))
})

test_that("Can parse PR merge commits", {
  withr::local_envvar("FLEDGE_TEST_GITHUB_SLUG" = "cynkra/fledge")
  httptest::with_mock_dir("pr", {
    withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
    expect_snapshot_tibble(extract_newsworthy_items("Merge pull request #332 from cynkra/conventional-parsing"))
  })
})

test_that("Can parse PR merge commits - external contributor", {
  withr::local_envvar("FLEDGE_TEST_GITHUB_SLUG" = "cynkra/fledge")
  httptest::with_mock_dir("pr", {
    withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
    expect_snapshot_tibble(extract_newsworthy_items("Merge pull request #18 from someone/conventional-parsing"))
  })
})

test_that("Can parse PR merge commits - internet error", {
  withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
  withr::local_envvar("FLEDGE_TEST_GITHUB_SLUG" = "cynkra/fledge")
  withr::local_envvar("NO_INTERNET_TEST_FLEDGE" = "blop")
  expect_snapshot_tibble(extract_newsworthy_items("Merge pull request #332 from cynkra/conventional-parsing"))
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

test_that("capitalize_news() works" , {
  repo <- withr::local_tempdir()
  withr::local_dir(repo)
  usethis::with_project(
    repo,
    usethis::use_description(fields = list(Package = "fledge")),
    force = TRUE
  )
  df <- tibble::tribble(
    ~description,
    "fledge has better support",
    "fledge's interface was improved",
    "fledged bird",
    "`update_news()` capitalize items",
    "2 new functions for bla",
    "harvest PR title"
  )
  expect_snapshot(capitalize_news(df))
})
