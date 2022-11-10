test_that("read_news() works with usual format", {
  news_lines <- c(
    "# fledge v2.0.0", "",
    "* blop", "",
    "* lala", "",
    "# fledge v1.0.0", "",
    "* blip", "",
    "* lili", ""
  )
  expect_snapshot_tibble(parse_news(news_lines))
})

test_that("read_news() works with other formats", {
  news_lines <- c(
    "<!-- Hands off, please -->",
    "",
    "# Changes in v2.0.0", "",
    "* blop", "",
    "* lala", "",
    "",
    "# Changes in v1.0.0", "",
    "* blip", "",
    "* lili", ""
  )
  expect_snapshot_tibble(parse_news(news_lines))
})

test_that("read_news() works with nicknames", {
  news_lines <- c(
    '# Changes in v2.0.0 "Vigorous Calisthenics"', "",
    "* blop", "",
    "* lala", "",
    '# Changes in v1.0.0 "Pumpkin Helmet"', "",
    "* blip", "",
    "* lili", ""
  )
  expect_snapshot_tibble(parse_news(news_lines))
})

test_that("read_news() works with h2", {
  news_lines <- c(
    '## Changes in v2.0.0 "Vigorous Calisthenics"', "",
    "* blop", "",
    "* lala", "",
    '## Changes in v1.0.0 "Pumpkin Helmet"', "",
    "* blip", "",
    "* lili", ""
  )
  expect_snapshot_tibble(parse_news(news_lines))
})
