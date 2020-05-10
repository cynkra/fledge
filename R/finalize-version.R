#' @rdname finalize_version
#' @usage NULL
finalize_version_impl <- function(push) {
  #' @description
  #' 1. [commit_version()]
  force <- commit_version()
  #' 1. [tag_version()], setting `force = TRUE` if and only if `commit_version()`
  #'   amended a commit.
  tag <- tag_version(force)
  #' 1. Force-pushes the created tag to the `"origin"` remote, if `push = TRUE`.
  if (push) {
    push_tag(tag)
  } else {
    ui_todo("Review {ui_path('NEWS.md')}")
    ui_todo("Call {ui_code('fledge::finalize_version(push = TRUE)')}")
    send_to_console("fledge::finalize_version(push = TRUE)")
  }
}

push_tag <- function(tag) {
  ui_done("Force-pushing tag {ui_value(tag)}")
  git2r::push(name = "origin", refspec = paste0("refs/tags/", tag), force = TRUE)
}

send_to_console <- function(code) {
  if (!is_installed("rstudioapi")) return()
  if (!is_interactive()) return()

  rstudioapi::sendToConsole(code, execute = FALSE)
}
