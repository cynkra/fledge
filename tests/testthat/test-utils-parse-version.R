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

test_that("fledge_guess_version() works", {
  expect_snapshot(error = TRUE, {
    fledge_guess_version("1.1.1", "1.0.0")
  })

  # FIXME: Should this really be an error?
  expect_snapshot(error = TRUE, {
    fledge_guess_version("1.1.1", "pre-minor")
  })

  # FIXME: Should this really be an error?
  expect_snapshot(error = TRUE, {
    fledge_guess_version("1.1.1", "pre-major")
  })

  expect_snapshot(error = TRUE, {
    fledge_guess_version("1.1.1", "boo")
  })

  expect_equal(fledge_guess_version("1.0.0", "2.0.0"), "2.0.0")

  expect_equal(fledge_guess_version("1.0.0", "dev"), "1.0.0.9000")
  expect_equal(fledge_guess_version("1.0.0.9000", "dev"), "1.0.0.9001")
  expect_equal(fledge_guess_version("1.0.0.9000", "patch"), "1.0.1")
  expect_equal(fledge_guess_version("1.0.0.9001", "pre-minor"), "1.0.99.9000")
  expect_equal(fledge_guess_version("1.0.0.9001", "minor"), "1.1.0")
  expect_equal(fledge_guess_version("1.0.0.9001", "pre-major"), "1.99.99.9000")
  expect_equal(fledge_guess_version("1.0.0.9001", "major"), "2.0.0")
})
