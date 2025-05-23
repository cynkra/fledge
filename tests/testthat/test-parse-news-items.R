test_that("Can parse conventional commits", {
  local_fledge_quiet()
  withr::local_envvar("FLEDGE_DATE" = "2023-01-23")
  withr::local_options(usethis.quiet = TRUE)

  repo <- withr::local_tempdir()
  withr::local_dir(repo)

  create_cc_repo()
  messages <- get_top_level_commits_impl(since = NULL)[["message"]]

  usethis::with_project(
    repo,
    usethis::use_description(fields = list(Package = "fledge")),
    force = TRUE
  )

  update_news(messages, which = "patch")

  expect_snapshot_file("NEWS.md")
})

test_that("Will use commits", {
  local_fledge_quiet()
  local_demo_project(quiet = TRUE)
  commits_df <- tibble::tibble(
    message = c("one", "two"),
    merge = c(TRUE, FALSE)
  )

  local_mocked_bindings(
    default_commit_range = function() commits_df
  )

  update_news(which = "minor")

  expect_snapshot_file("NEWS.md", "NEWS-merge.md")
})

test_that("Can parse Co-authored-by", {
  expect_snapshot(
    extract_newsworthy_items(
      "- blop\n-blip\n\nCo-authored-by: Person (<person@users.noreply.github.com>)"
    )
  )

  expect_snapshot(
    extract_newsworthy_items(
      "- blop\n\nCo-authored-by: Person (<person@users.noreply.github.com>)\nCo-authored-by: Someone Else (<else@users.noreply.github.com>)"
    )
  )

  expect_snapshot(
    extract_newsworthy_items(
      "feat: blop\n\nCo-authored-by: Person (<person@users.noreply.github.com>)"
    )
  )
})

test_that("Can parse PR merge commits", {
  withr::local_envvar("FLEDGE_TEST_GITHUB_SLUG" = "cynkra/fledge")

  with_mock_dir("pr", {
    withr::local_envvar("FLEDGE_YES_INTERNET_TEST" = "yes")
    withr::local_envvar("FLEDGE_TEST_SCOPES" = "bla")
    withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
    expect_snapshot_tibble(
      extract_newsworthy_items(
        "Merge pull request #332 from cynkra/conventional-parsing"
      )
    )
  })
})

test_that("Can parse PR merge commits - external contributor", {
  withr::local_envvar("FLEDGE_TEST_GITHUB_SLUG" = "cynkra/fledge")

  with_mock_dir("pr0", {
    withr::local_envvar("FLEDGE_YES_INTERNET_TEST" = "yes")
    withr::local_envvar("FLEDGE_TEST_SCOPES" = "bla")
    withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
    expect_snapshot(suppressMessages(
      # https://github.com/nealrichardson/httptest/issues/75
      extract_newsworthy_items("Merge pull request #18 from someone/conventional-parsing")
    ))
  })
})

test_that("Can parse PR merge commits - linked issues", {
  withr::local_envvar("FLEDGE_TEST_GITHUB_SLUG" = "cynkra/fledge")

  with_mock_dir("pr2", {
    withr::local_envvar("FLEDGE_YES_INTERNET_TEST" = "yes")
    withr::local_envvar("FLEDGE_TEST_SCOPES" = "bla")
    withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
    expect_snapshot_tibble(
      extract_newsworthy_items("Merge pull request #328 from cynkra/blop")
    )
  })
})


test_that("Can parse PR merge commits - internet error", {
  withr::local_envvar("FLEDGE_TEST_SCOPES" = "bla")
  withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
  withr::local_envvar("FLEDGE_TEST_GITHUB_SLUG" = "cynkra/fledge")
  withr::local_envvar("FLEDGE_NO_INTERNET_TEST" = "no")

  expect_snapshot(
    extract_newsworthy_items("Merge pull request #332 from cynkra/conventional-parsing")
  )
})

test_that("Can parse PR merge commits - PAT absence", {
  skip_if_offline()
  withr::local_envvar("FLEDGE_TEST_SCOPES" = "bla")
  withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
  withr::local_envvar("FLEDGE_TEST_NO_PAT" = "blop")
  expect_snapshot(error = TRUE, {
    extract_newsworthy_items("Merge pull request #332 from cynkra/conventional-parsing")
  })
})

test_that("Can parse PR merge commits - other error", {
  withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
  withr::local_envvar("FLEDGE_TEST_GITHUB_SLUG" = "cynkra/fledge")
  withr::local_envvar("FLEDGE_TEST_SCOPES" = "bla")

  local_mocked_bindings(gh = function(...) stop("bla"))

  with_mock_dir("pr", {
    expect_snapshot_tibble(
      harvest_pr_data("Merge pull request #332 from cynkra/conventional-parsing")
    )
  })
})

test_that("Can parse PR squash commits - linked issues", {
  withr::local_envvar("FLEDGE_TEST_GITHUB_SLUG" = "cynkra/fledge")

  with_mock_dir("pr2", {
    withr::local_envvar("FLEDGE_YES_INTERNET_TEST" = "yes")
    withr::local_envvar("FLEDGE_TEST_SCOPES" = "bla")
    withr::local_envvar("GITHUB_PAT" = "ghp_111111111111111111111111111111111111111")
    expect_snapshot_tibble(
      extract_newsworthy_items("feat: blop (#328)\n")
    )
  })
})
