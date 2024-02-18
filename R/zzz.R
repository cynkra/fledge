.onLoad <- function(libname, pkgname) {
  get_main_branch <<- memoise::memoise(get_main_branch)
}
