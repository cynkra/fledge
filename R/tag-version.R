tag_version_impl <- function(force) {
  check_only_staged(character())

  if (fledge_chatty()) {
    cli_h2("Tagging Version")
  }

  tag_info <- get_tag_info()

  tag <- tag_info$name

  if (tag_already_exist(tag)) {
    # Tagging would do nothing as the tag points to the current commit
    if (gert::git_commit_info(tag)$id == gert::git_log(max = 1)$commit) {
      if (fledge_chatty()) {
        cli_alert_info("Tag {.field {tag}} exists and points to the current commit.")
      }
      return(invisible(tag))
    }

    # Tagging would fail
    if (!force) {
      cli::cli_abort("Tag {.val {tag}} exists, use {.code force = TRUE} to overwrite.")
    }

    if (fledge_chatty()) {
      cli_alert("Deleting existing tag {.field {tag}}.")
    }
    gert::git_tag_delete(tag)
  }

  if (fledge_chatty()) {
    cli_alert(
      "Creating tag {.field {tag}} with tag message derived from {.file NEWS.md}.",
      wrap = TRUE
    )
  }

  gert::git_tag_create(tag, message = paste0(tag_info$header, "\n\n", tag_info$body))

  invisible(tag)
}

get_tag_info <- function() {
  desc <- desc::desc(file = "DESCRIPTION")
  version <- desc$get_version()
  name <- paste0("v", version)
  header <- paste0(desc$get("Package"), " ", version)
  body <- sub("^[^\n]+\n\n", "", get_current_news())

  list(
    name = name,
    header = header,
    body = body
  )
}

get_current_news <- function() {
  headers <- get_news_headers()
  if (nrow(headers) == 0) {
    return(character())
  }
  # FIXME: Add body column to get_news_headers()?
  stopifnot(headers$start[[1]] %in% 1:3)

  if (nrow(headers) == 1) {
    n <- -1L
  } else {
    n <- headers$start[[2]] - 1L
  }

  current_news <- readLines(news_path(), n)[-1]
  current_news <- paste(current_news, collapse = "\n")
  gsub("^\n*(.*[^\n])\n*$", "\\1", current_news)
}

tag_already_exist <- function(tag) {
  tag %in% gert::git_tag_list()$name
}
