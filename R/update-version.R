update_version_impl <- function(which) {
  new_version <- update_version_helper(which = which)

  ui_done("Package version bumped to {ui_value(new_version)}")

  ui_done("Adding header to {ui_path(news_path)}")

  header <- paste0(
    "# ", desc$get("Package"), " ", new_version,
    if (date_in_news_headers()) paste0(" (", Sys.Date(), ")"),
    "\n"
  )
  add_to_news(header)

  desc$write()
}

update_version_helper <- function(which) {
  desc <- desc::desc(file = "DESCRIPTION")

  if (desc$has_fields("Date")) {
    desc$set("Date", Sys.Date())
  }

  # https://github.com/r-lib/desc/issues/93
  suppressMessages(desc$bump_version(which))

  new_version <- desc$get_version()

  return(new_version)
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
  news <- readLines(news_path)
  rx <- "^# +(?<package>[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9]) +(?<version>[0-9][0-9.-]*) *(?<extra>.*)$"
  out <- rematch2::re_match(news, rx)
  out <- tibble::add_column(out, line = seq_len(nrow(out)), .before = 1)
  out[!is.na(out$package), grep("^[^.]", names(out), value = TRUE)]
}
