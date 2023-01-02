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

test_that("normalize_news() works", {
  repo <- withr::local_tempdir()
  withr::local_dir(repo)
  usethis::with_project(
    repo,
    usethis::use_description(fields = list(Package = "fledge")),
    force = TRUE
  )
  df <- tibble::tribble(
    ~description,
    "fledge has better support.",
    "fledge's interface was improved!",
    "fledged bird?",
    "`update_news()` capitalize items",
    "2 new functions for bla",
    "harvest PR title"
  )
  expect_snapshot_tibble(normalize_news(df))
})
