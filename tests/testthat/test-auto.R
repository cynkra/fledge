test_that("extract_version_pr() works", {
  expect_equal(extract_version_pr("CRAN release v1.2.3"), "1.2.3")
  expect_equal(extract_version_pr("Let's get 1.42.3 on CRAN"), "1.42.3")
  expect_equal(extract_version_pr(" fledge 1.2.3"), "1.2.3")
})

test_that("guess_next_impl() works", {
  expect_snapshot({
    guess_next_impl("1.2.3.9007")
    guess_next_impl("1.2.99.9008")
    guess_next_impl("1.99.99.9009")
  })
})
