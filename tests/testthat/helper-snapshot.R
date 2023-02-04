snapshot_variant <- function(...) {
  matrix <- c(...)

  bad_variants <- setdiff(matrix, c("testthat", "os"))
  if (length(bad_variants) > 0) {
    abort(paste0("Unknown variant selector: ", bad_variants[[1]]))
  }

  variant <- NULL

  if ("testthat" %in% matrix) {
    # testthat stable now, no need to specify a variant here
    # variant <- c(variant, paste0("testthat_", packageVersion("testthat")))
  }

  if ("os" %in% matrix) {
    variant <- c(variant, testthat_os())
  }

  if (is.null(variant)) {
    return(NULL)
  }
  paste(variant, collapse = "-")
}

testthat_os <- function() {
  os <- tolower(Sys.info()[["sysname"]])
  switch(os,
    darwin = "mac",
    sunos = "solaris",
    os
  )
}

expect_snapshot_tibble <- function(code) {
  json <- eval(code) %>%
    jsonlite::toJSON(pretty = TRUE, na = "string", null = "null")
  expect_snapshot_output(json)
}
