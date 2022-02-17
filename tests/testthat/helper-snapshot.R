snapshot_variant <- function(...) {
  matrix <- c(...)

  bad_variants <- setdiff(matrix, c("testthat", "os"))
  if (length(bad_variants) > 0) {
    abort(paste0("Unknown variant selector: ", bad_variants[[1]]))
  }

  variant <- NULL

  if ("testthat" %in% matrix) {
    variant <- c(variant, paste0("testthat_", packageVersion("testthat")))
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
