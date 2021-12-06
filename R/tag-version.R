tag_version_impl <- function(force) {
  check_only_staged(character())

  current_news <- get_current_news()
  desc <- desc::desc(file = "DESCRIPTION")
  version <- desc$get_version()

  if (fledge_chatty()) cli_h2("Tagging Version")

  tag <- paste0("v", version)

  if (tag_already_exist(tag)) {

    # Tagging would do nothing as the tag points to the current commit
    if (gert::git_commit_info(tag)$id == gert::git_log(max = 1)$commit) {
      if (fledge_chatty()) {
        cli_alert_info("Tag {.field {tag}} exists and points to the current commit.")
      }
      return()
    }

    # Tagging would fail
    if (!force) {
      abort(paste0("Tag ", tag, " exists, use `force = TRUE` to overwrite."))
    }

    if (fledge_chatty()) cli_alert("Deleting existing tag {.field {tag}}.")
    gert::git_tag_delete(tag)
  }

  if (fledge_chatty()) {
    cli_alert(
      "Creating tag {.field {tag}} with tag message derived from {.file NEWS.md}.",
      wrap = TRUE
    )
  }

  msg_header <- paste0(desc$get("Package"), " ", version)
  gert::git_tag_create(tag, message = paste0(msg_header, "\n\n", current_news))

  invisible(tag)
}

get_current_news <- function() {
  headers <- get_news_headers()
  if (nrow(headers) == 0) {
    return(character())
  }
  # FIXME: Add body column to get_news_headers()?
  stopifnot(headers$line[[1]] %in% 1:3)

  if (nrow(headers) == 1) {
    n <- -1L
  } else {
    n <- headers$line[[2]] - 1L
  }

  current_news <- readLines(news_path(), n)[-1]
  current_news <- paste(current_news, collapse = "\n")
  gsub("^\n*(.*[^\n])\n*$", "\\1", current_news)
}

tag_already_exist <- function(tag) {
  tag %in% gert::git_tag_list()$name
}
