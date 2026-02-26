snapshot_variant <- function(...) {
  matrix <- c(...)

  bad_variants <- setdiff(matrix, c("testthat", "os"))
  if (length(bad_variants) > 0) {
    cli::cli_abort("Unknown variant selector: {.val {bad_variants[[1]]}}")
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

expect_snapshot_tibble <- function(data) {
  json <- jsonlite::toJSON(
    deep_clean(data),
    pretty = TRUE,
    na = "string",
    null = "null"
  )
  expect_snapshot_output(json)
}

deep_clean <- function(data) {
  if (is.data.frame(data)) {
    is_list <- purrr::map_lgl(data, is.list)
    data[is_list] <- purrr::map(data[is_list], purrr::map_chr, ~ {
      paste(format(.x), collapse = "\n")
    })
    data
  } else if (is.list(data)) {
    purrr::map(data, deep_clean)
  } else {
    data
  }
}
