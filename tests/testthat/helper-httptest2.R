with_mock_dir <- function(name, ...) {
  skip_if_not_installed("httptest2") # Needed for httptest2::with_mock_dir
  httptest2::with_mock_dir(file.path("../fixtures", name), ...)
}
