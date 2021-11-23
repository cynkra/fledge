update_version_impl <- function(which) {
  desc <- desc::desc(file = "DESCRIPTION")

  if (desc$has_fields("Date")) {
    desc$set("Date", get_date())
  }

  # https://github.com/r-lib/desc/issues/93
  suppressMessages(desc$bump_version(which))

  new_version <- desc$get_version()

  cli_h2("Update Version")

  cli_alert_success("Package version bumped to {.field {new_version}}.")

  cli_alert("Adding header to {.file {news_path()}}.")

  header <- paste0(
    "# ", desc$get("Package"), " ", new_version,
    if (date_in_news_headers()) paste0(" (", get_date(), ")"),
    "\n"
  )
  add_to_news(header)

  desc$write()
}

date_in_news_headers <- function() {
  headers <- get_news_headers()
  if (nrow(headers) == 0) {
    # Add date by default
    return(TRUE)
  }

  dates <- grep("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", headers$extra)
  length(dates) > 0
}

get_news_headers <- function() {
  news <- readLines(news_path())
  rx <- "^# +(?<package>[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9]) +(?<version>[0-9][0-9.-]*) *(?<extra>.*)$"
  out <- rematch2::re_match(news, rx)
  out <- tibble::add_column(out, line = seq_len(nrow(out)), .before = 1)
  out[!is.na(out$package), grep("^[^.]", names(out), value = TRUE)]
}

get_date <- function() {
  # For stable Rmarkdown output
  if (Sys.getenv("IN_PKGDOWN") == "") {
    return(Sys.Date())
  }
  author_time <- parsedate::parse_iso_8601(Sys.getenv("GIT_COMMITTER_DATE"))
  as.Date(author_time)
}
