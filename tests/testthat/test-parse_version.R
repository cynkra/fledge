test_that("parse_version() works", {
  parsed <- parse_version("fledge 1.0.1 (2022-01-01)")
  expect_equal(parsed[["prefix"]], "fledge")
  expect_equal(parsed[["version"]], "1.0.1")
  expect_equal(parsed[["date"]], "(2022-01-01)")
  expect_true(is.na(parsed[["nickname"]]))

  parsed2 <- parse_version("fledge v1.0.1 'the one with new stuff'")
  expect_equal(parsed2[["prefix"]], "fledge")
  expect_equal(parsed2[["version"]], "1.0.1")
  expect_true(is.na(parsed2[["date"]]))
  expect_equal(parsed2[["nickname"]], "'the one with new stuff'")

  parsed3 <- parse_version("fledge (development version)")
  expect_equal(parsed3[["prefix"]], "fledge")
  expect_equal(parsed3[["version"]], "(development version)")
  expect_true(is.na(parsed3[["date"]]))
  expect_true(is.na(parsed3[["nickname"]]))
})
