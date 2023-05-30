test_that("extract_version_pr() works", {
  expect_equal(extract_version_pr("CRAN release v1.2.3"), "1.2.3")
  expect_equal(extract_version_pr("Let's get 1.42.3 on CRAN"), "1.42.3")
  expect_equal(extract_version_pr(" fledge 1.2.3"), "1.2.3")
})
