shut_up_fledge <- function(code) {
  withr::with_options(
    new = list("fledge.quiet" = TRUE, "usethis.quiet" = TRUE),
    code
  )
}

local_fledge_quiet <- function(envir = parent.frame()) {
  withr::local_options(
    fledge.quiet = TRUE, usethis.quiet = TRUE,
    .local_envir = envir
  )
}
