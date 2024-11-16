shut_up_fledge <- function(code) {
  withr::with_options(
    new = list("fledge.quiet" = TRUE, "usethis.quiet" = TRUE),
    code
  )
}

local_fledge_quiet <- function(quiet = TRUE, .frame = caller_env()) {
  local_options(
    "fledge.quiet" = quiet,
    "usethis.quiet" = quiet,
    .frame = .frame
  )
}

expect_fledge_snapshot <- function(...) {
  local_fledge_quiet(FALSE)
  expect_snapshot(...)
}
