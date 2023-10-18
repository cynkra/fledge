with_mock_dir <- function(name, ...) {
  httptest2::with_mock_dir(file.path("../fixtures", name), ...)
}
