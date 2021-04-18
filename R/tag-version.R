tag_version_impl <- function(force) {
  check_only_staged(character())

  current_news <- get_current_news()
  desc <- desc::desc(file = "DESCRIPTION")
  version <- desc$get_version()

  cli_h2("Tagging Version")

  tag <- paste0("v", version)
  if (tag %in% gert::git_tag_list()$name) {
    if (!force) {
      if (gert::git_commit_info(tag)$id == gert::git_log(max = 1)$commit) {
        cli_alert_info("Tag {.field {tag}} exists and points to the current commit.")
      } else {
        abort(paste0("Tag ", tag, " exists, use `force = TRUE` to overwrite."))
      }
    } else {
      cli_alert("Deleting tag {.field {tag}}.")
      gert::git_tag_delete(tag)
    }
  }

  cli_alert("Creating tag {.field {tag}} with tag message derived from
                    {.file NEWS.md}.", wrap = TRUE)
  msg_header <- paste0(desc$get("Package"), " ", version)
  gert::git_tag_create(tag, message = paste0(msg_header, "\n\n", current_news))

  invisible(tag)
}

tag_release_candidate_impl <- function(force) {
  check_only_staged(character())

  current_news <- get_current_news()
  desc <- desc::desc(file = "DESCRIPTION")
  version <- desc$get_version()

  cli_h2("Tagging Release Candidate")

  suffix <- check_existing_rc()

  tag <- paste0("v", version, "-rc", suffix)
  if (tag %in% names(git2r::tags())) {
    if (!force) {
      if (git2r::sha(get_repo_head(tag)) == git2r::sha(get_repo_head())) {
        cli_alert_info("Tag {.field {tag}} exists and points to the current commit.")
      } else {
        abort(paste0("Tag ", tag, " exists, use `force = TRUE` to overwrite."))
      }
    } else {
      cli_alert("Deleting tag {.field {tag}}.")
      git2r::tag_delete(".", tag)
    }
  }

  msg_header <- paste0(desc$get("Package"), " ", version)
  git2r::tag(".", tag, message = paste0(msg_header, "-rc\n\n", current_news))

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

  current_news <- readLines(news_path, n)[-1]
  current_news <- paste(current_news, collapse = "\n")
  gsub("^\n*(.*[^\n])\n*$", "\\1", current_news)
}

check_existing_rc <- function() {

  tags_filtered <- grep("rc", names(git2r::tags()), value = T)

  if (length(tags_filtered != 0)) {
    index <- length(tags_filtered) + 1

  } else {
    index <- 1
  }
  return(index)

}
