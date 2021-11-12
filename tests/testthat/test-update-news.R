test_that("add_to_news works when news file still empty", {
  temp_dir <- withr::local_tempdir()
  temp_news <- file.path(temp_dir, "NEWS-empty.md")
  file.create(temp_news)
  mockery::stub(
    where = add_to_news,
    what = "news_path",
    how = temp_news,
    depth = 3
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
    how = temp_news,
    depth = 3
  )
  add_to_news("* Cool stuff!")
  expect_snapshot_file(temp_news)
})
