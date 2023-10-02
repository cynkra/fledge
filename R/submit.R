# From release.R in devtools

# Copyright (c) 2021 devtools authors

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.


cran_comments <- function(pkg = ".") {
  path <- fs::path(pkg, "cran-comments.md")
  if (!fs::file_exists(path)) {
    warning("Can't find cran-comments.md.\n",
      "This file gives CRAN volunteers comments about the submission,\n",
      "Create it with use_cran_comments().\n",
      call. = FALSE
    )
    return(character())
  }

  brio::read_file(path)
}

cran_submission_url <- "https://xmpalantir.wu.ac.at/cransubmit/index2.php"

submit_cran <- function(pkg = ".", args = NULL) {
  built_path <- build_cran(pkg, args = args)
  upload_cran(pkg, built_path)
}

build_cran <- function(pkg, args) {
  cli::cli_alert_info("Building")
  built_path <- pkgbuild::build(pkg, tempdir(), manual = TRUE, args = args)
  cli::cli_alert_info("Submitting file: {.file {built_path}}")
  size <- format(as.object_size(fs::file_info(built_path)$size), units = "auto")
  cli::cli_alert_info("File size: {.val {size}}")
  built_path
}

extract_cran_msg <- function(msg) {
  # Remove "CRAN package Submission" and "Submit package to CRAN"
  msg <- gsub("CRAN package Submission|Submit package to CRAN", "", msg)

  # remove all html tags
  msg <- gsub("<[^>]+>", "", msg)

  # remove tabs
  msg <- gsub("\t+", "", msg)

  # Remove extra newlines
  msg <- gsub("\n+", "\n", msg)

  msg
}

upload_cran <- function(pkg, built_path) {
  maint <- utils::as.person(desc::desc_get_maintainer(pkg))
  maint_name <- paste(maint$given, maint$family)
  maint_email <- maint$email
  comments <- cran_comments(pkg)

  # Initial upload ---------
  cli::cli_alert_info("Uploading package & comments")

  # impossible as fledge imports httr2 that imports curl :-)
  if (!rlang::is_installed("curl")) {
    cli::cli_abort("Must install the curl package")
  }
  body <- list(
    pkg_id = "",
    name = maint_name,
    email = maint_email,
    uploaded_file = curl::form_file(built_path, type = "application/x-gzip"),
    comment = comments,
    upload = "Upload the package"
  )
  request <- httr2::request(cran_submission_url) %>%
    httr2::req_body_multipart(!!!body)

  if (nzchar(Sys.getenv("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST"))) {
    cli::cli_inform("Not submitting for real o:-)")
    return(invisible(NULL))
  }

  r <- httr2::req_perform(request)

  # If a 404 likely CRAN is closed for maintenance, try to get the message
  if (httr2::resp_status(r) == 404) {
    msg <- "<Can't extract error message>"
    try({
      r2 <- httr2::request(sub("index2", "index", cran_submission_url)) %>%
        httr2::req_perform()
      msg <- extract_cran_msg(httr2::resp_body_string(r2))
    })
    stop("Submission failed: ", msg, call. = FALSE)
  }

  httr2::resp_check_status(r)
  new_url <- httr2::url_parse(r$url)

  if (!is.null(new_url$query$strErr) && new_url$query$strErr != "99") {
    msg <- "<Can't extract error message>"
    try({
      r2 <- httr::GET(r$url)
      html <- httr::content(r2, "text")
      msg <-
        html %>%
        xml2::read_html() %>%
        xml2::xml_find_all('./body//font[@color="red"]') %>%
        xml2::xml_text()
    })
    stop("Submission failed: ", msg, call. = FALSE)
  }

  # Confirmation -----------
  cli::cli_alert_info("Confirming submission")
  body <- list(
    pkg_id = new_url$query$pkg_id,
    name = maint_name,
    email = maint_email,
    policy_check = "1/",
    submit = "Submit package"
  )
  r <- httr2::request(cran_submission_url) %>%
    httr2::req_body_multipart(!!!body)
  httr2::resp_check_status(r)
  new_url <- httr2::url_parse(r$url)
  if (new_url$query$submit == "1") {
    cli::cli_alert_success("Package submission successful")
    cli::cli_alert_info("Check your email for confirmation link.")
  } else {
    stop("Package failed to upload.", call. = FALSE)
  }

  invisible(TRUE)
}

as.object_size <- function(x) structure(x, class = "object_size")

# Silence CRAN check about unused devtools
flag_devtools_as_used <- function() {
  devtools::submit_cran()
}
