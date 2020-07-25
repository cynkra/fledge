tag_version_impl <- function(force) {
  check_only_staged(character())

  current_news <- get_current_news()
  desc <- desc::desc(file = "DESCRIPTION")
  version <- desc$get_version()

  tag <- paste0("v", version)
  if (tag %in% names(git2r::tags())) {
    if (!force) {
      if (git2r::sha(get_repo_head(tag)) == git2r::sha(get_repo_head())) {
        ui_info("Tag {ui_value(tag)} exists and points to the current commit.")
      } else {
        abort(paste0("Tag ", tag, " exists, use `force = TRUE` to overwrite."))
      }
    } else {
      ui_done("Deleting tag {ui_value(tag)}")
      git2r::tag_delete(".", tag)
    }
  }

  ui_done("Creating tag {ui_value(tag)} with tag message derived from {ui_path('NEWS.md')}")
  msg_header <- paste0(desc$get("Package"), " ", version)
  git2r::tag(".", tag, message = paste0(msg_header, "\n\n", current_news))

  invisible(tag)
}

get_current_news <- function() {
  headers <- get_news_headers()
  if (nrow(headers) == 0) return(character())
  # FIXME: Add body column to get_news_headers()?
  stopifnot(headers$line[[1]] == 1)

  if (nrow(headers) == 1) {
    n <- -1L
  } else {
    n <- headers$line[[2]] - 1L
  }

  current_news <- readLines(news_path, n)[-1]
  current_news <- paste(current_news, collapse = "\n")
  gsub("^\n*(.*[^\n])\n*$", "\\1", current_news)
}
