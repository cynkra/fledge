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
        stop("Tag ", tag, " exists and points to a different commit, use `force = TRUE` to overwrite.", call. = FALSE)
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
  news_path <- "NEWS.md"
  news <- readLines(news_path)
  top_level_headers <- grep("^# [a-zA-Z][a-zA-Z0-9.]+[a-zA-Z0-9] [0-9.-]+", news)
  if (length(top_level_headers) == 0) return(character())

  stopifnot(top_level_headers[[1]] == 1)

  if (length(top_level_headers) == 1) {
    current_news <- news[-1]
  } else {
    current_news <- news[seq.int(top_level_headers[[1]] + 1, top_level_headers[[2]] - 1)]
  }

  current_news <- paste(current_news, collapse = "\n")
  gsub("^\n*(.*[^\n])\n*$", "\\1", current_news)
}
