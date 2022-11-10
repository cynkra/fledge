test_that("read_news() works with usual format", {
  temp_dir <- withr::local_tempdir()
  withr::local_dir(temp_dir)
  news_lines <- c(
    "## fledge v2.0.0", "",
    "* blop", "",
    "* lala", "",
    "## fledge v1.0.0", "",
    "* blip", "",
    "* lili", ""
  )
  brio::write_lines(news_lines, "NEWS.md")
  expect_snapshot_tibble(read_news())
})

test_that("read_news() works with other formats", {
  temp_dir <- withr::local_tempdir()
  withr::local_dir(temp_dir)
  news_lines <- c(
    "## Changes in v2.0.0", "",
    "* blop", "",
    "* lala", "",
    "## Changes in v1.0.0", "",
    "* blip", "",
    "* lili", ""
  )
  brio::write_lines(news_lines, "NEWS.md")
  expect_snapshot_tibble(read_news())
})

test_that("read_news() works with nicknames", {
  temp_dir <- withr::local_tempdir()
  withr::local_dir(temp_dir)
  news_lines <- c(
    '## Changes in v2.0.0 "Vigorous Calisthenics"', "",
    "* blop", "",
    "* lala", "",
    '## Changes in v1.0.0 "Pumpkin Helmet"', "",
    "* blip", "",
    "* lili", ""
  )
  brio::write_lines(news_lines, "NEWS.md")
  expect_snapshot_tibble(read_news())
})
