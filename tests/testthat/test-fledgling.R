test_that("read_news() works with usual format", {
  news_lines <- c(
    "# fledge v2.0.0", "",
    "* blop", "",
    "* lala", "",
    "# fledge v1.0.0", "",
    "* blip", "",
    "* lili", ""
  )
  expect_snapshot_tibble(read_news(news_lines))
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
  expect_snapshot_tibble(read_news(news_lines))
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
  expect_snapshot_tibble(read_news(news_lines))
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
  expect_snapshot_tibble(read_news(news_lines))
})

test_that("correct handling of the preamble", {
  # no preamble ----
  news_lines <- c(
    "# fledge v2.0.0", "",
    "* blop", ""
  )
  expect_equal(read_news(news_lines)[["preamble"]], news_preamble())

  # old preamble ----
  news_lines <- c(
    "<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->", "",
    "# fledge v2.0.0", "",
    "* blop", ""
  )
  expect_equal(read_news(news_lines)[["preamble"]], news_preamble())

  # current preamble ----
  news_lines <- c(
    news_preamble(), "",
    "# fledge v2.0.0", "",
    "* blop", ""
  )
  expect_equal(read_news(news_lines)[["preamble"]], news_preamble())

  # custom preamble ----
  fancy <- "<!-- NEWS.md is maintained by a fancy package, do not edit -->"
  news_lines <- c(
    fancy, "",
    "# fledge v2.0.0", "",
    "* blop", ""
  )
  expect_equal(read_news(news_lines)[["preamble"]], fancy)
})
