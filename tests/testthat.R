deps <- c("testthat", "foghorn", "httptest2")
deps_availability <- purrr::map_lgl(deps, rlang::is_installed)
all_deps_available <- all(deps_availability)

if (all_deps_available) {
  library(testthat)
  library(fledge)
  test_check("fledge")
} else {
  message(
    sprintf(
      "%s not available.",
      toString(deps[!deps_availability])
    )
  )
}
