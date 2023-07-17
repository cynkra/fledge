library("httptest2")

test_path <- normalizePath(testthat::test_path())
Sys.setenv("fledge.test.path" = test_path)
with_mock_dir <- function(name, ...) {
  dir <- file.path(dirname(Sys.getenv("fledge.test.path")), "fixtures", name)
  httptest2::with_mock_dir(dir, ...)
}
