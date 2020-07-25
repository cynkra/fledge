update_version_impl <- function(which) {
  desc <- desc::desc(file = "DESCRIPTION")

  if (desc$has_fields("Date")) {
    desc$set("Date", Sys.Date())
  }

  # https://github.com/r-lib/desc/issues/93
  suppressMessages(desc$bump_version(which))

  new_version <- desc$get_version()

  ui_done("Package version bumped to {ui_value(new_version)}")

  ui_done("Adding header to {ui_path('NEWS.md')}")

  add_to_news(paste0(
    "# ", desc$get("Package"), " ", new_version, "\n"
  ))
  desc$write()
}

get_news_headers <- function() {
  news <- readLines(news_path)
  rx <- "^# +(?<package>[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9]) +(?<version>[0-9][0-9.-]*) *(?<extra>.*)$"
  out <- rematch2::re_match(news, rx)
  out[!is.na(out$package), grep("^[^.]", names(out), value = TRUE)]
}
