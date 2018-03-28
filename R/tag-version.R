tag_version_impl <- function() {
  stopifnot(length(git2r::status(".", unstaged = FALSE, untracked = FALSE)$staged) == 0)

  current_news <- get_current_news()
  desc <- desc::desc(file = "DESCRIPTION")
  version <- desc$get_version()

  tag <- paste0("v", version)
  if (tag %in% names(git2r::tags())) {
    message("Deleting tag ", tag)
    git2r::tag_delete(".", tag)

    if (grepl("^fledge: Bump version to ", git2r::last_commit()$message)) {
      message("Resetting to previous commit")
      git2r::reset(git2r::revparse_single(revision = "HEAD^"))
    }
  }

  git2r::add(".", c("DESCRIPTION", "NEWS.md"))
  if (length(git2r::status(unstaged = FALSE, untracked = FALSE)$staged) > 0) {
    message("Committing changes")
    git2r::commit(".", paste0("fledge: Bump version to ", version))
  }

  message("Creating tag ", tag)
  msg_header <- paste0(desc$get("Package"), " ", version)
  git2r::tag(".", tag, message = paste0(msg_header, "\n\n", current_news))
}

get_current_news <- function() {
  news_path <- "NEWS.md"
  news <- readLines(news_path)
  top_level_headers <- grep("^# [a-zA-Z][a-zA-Z0-9.]+[a-zA-Z0-9] [0-9.-]+", news)
  stopifnot(top_level_headers[[1]] == 1)

  if (length(top_level_headers) == 1) {
    current_news <- news[-1]
  } else {
    current_news <- news[seq.int(top_level_headers[[1]] + 1, top_level_headers[[2]] - 1)]
  }

  stopifnot(current_news[[1]] == "")
  current_news <- current_news[-1]

  stopifnot(current_news[[length(current_news)]] == "")
  stopifnot(current_news[[length(current_news) - 1]] == "")
  current_news <- current_news[seq_len(length(current_news) - 2)]
  paste(current_news, collapse = "\n")
}
