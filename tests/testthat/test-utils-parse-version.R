test_that("fledge_guess_version() works", {
  expect_error(fledge_guess_version("1.1.1", "1.0.0"))

  expect_equal(fledge_guess_version("1.0.0", "2.0.0"), "2.0.0")

  expect_equal(fledge_guess_version("1.0.0", "dev"), "1.0.0.9000")
  expect_equal(fledge_guess_version("1.0.0.9000", "dev"), "1.0.0.9001")
  expect_equal(fledge_guess_version("1.0.0.9000", "patch"), "1.0.1")
  expect_equal(fledge_guess_version("1.0.0.9000", "minor"), "1.1.0")
  expect_equal(fledge_guess_version("1.0.0.9000", "major"), "2.0.0")
})
