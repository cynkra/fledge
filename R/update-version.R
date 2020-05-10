update_version_impl <- function(which) {
  desc <- desc::desc(file = "DESCRIPTION")

  if (desc$has_fields("Date")) {
    desc$set("Date", Sys.Date())
  }

  desc$bump_version(which)
  new_version <- desc$get_version()

  ui_done("Package version bumped to {ui_value(new_version)}")

  ui_done("Adding header to {ui_path('NEWS.md')}")

  add_to_news(paste0(
    "# ", desc$get("Package"), " ", new_version, "\n"
  ))
  desc$write()
}
