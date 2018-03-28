update_version_impl <- function(which) {
  desc <- desc::desc(file = "DESCRIPTION")
  desc$bump_version(which)
  new_version <- desc$get_version()
  add_to_news(paste0("# ", desc$get("Package"), " ", new_version, "\n"))
  desc$write()
}
