test_that("get_top_level_commits_impl() works", {
  tempdir <- withr::local_tempdir(pattern = "fledge-top-level")
  repo <- create_repo(tempdir)

  withr::local_dir(repo$repo)

  expect_snapshot({
    get_top_level_commits_impl(NULL)["message"]
    get_top_level_commits_impl(repo$a)["message"]
    get_top_level_commits_impl(repo$b)["message"]
    get_top_level_commits_impl(repo$c)["message"]
    get_top_level_commits_impl(repo$d)["message"]
    get_top_level_commits_impl(repo$e)["message"]
  })
})
