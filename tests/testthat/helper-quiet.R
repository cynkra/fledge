shut_up_fledge <- function(code) {
  withr::with_options(
    new = list("fledge.quiet" = TRUE, "usethis.quiet" = TRUE),
    code
  )
}
