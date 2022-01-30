if (require(testthat)) {
  library(fledge)
  test_check("fledge")
} else {
  message("testthat not available.")
}
