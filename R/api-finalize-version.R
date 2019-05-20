#' Finalize package version
#'
#' @description
#' Calls the following functions:
#'
#' @export
finalize_version <- function() {
  finalize_version_impl()
  ui_todo("If you edit {ui_path('NEWS.md')} again, save the file and call {ui_code('fledge::finalize_version()')}")
}
