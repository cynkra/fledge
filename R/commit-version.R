commit_version_impl <- function() {
  check_only_staged(c("DESCRIPTION", news_path))

  if (is_last_commit_bump()) {
    cli_alert("Resetting to previous commit.")
    gert::git_reset_soft(gert::git_log(max = 2)[2, "commit"])
    amending <- TRUE
  } else {
    amending <- FALSE
  }

  # need to get paths from git status to account for subdirs
  news_path = grep("DESCRIPTION", gert::git_status()$file, value = TRUE)
  descr_path = grep("NEWS.md", gert::git_status()$file, value = TRUE)

  gert::git_add(c(descr_path, news_path))

  if (length(gert::git_status(staged = TRUE)$staged) > 0) {
    cli_alert("Committing changes.")
    gert::git_commit(get_commit_message())
  }

  amending
}

is_last_commit_bump <- function() {
  gert::git_log(max = 1)$message == get_commit_message()
}

get_commit_message <- function(version) {
  desc <- desc::desc(file = "DESCRIPTION")
  version <- desc$get_version()

  paste0("Bump version to ", version, "\n")
}

check_clean <- function(forbidden_modifications) {
  status <- gert::git_status()
  stopifnot(!any(forbidden_modifications %in% basename(status$file)))
}

check_only_staged <- function(allowed_modifications) {
  staged <- gert::git_status(staged = TRUE)
  stopifnot(all(staged$status == "modified"))

  modified <- basename(staged$file)
  stopifnot(all(modified %in% allowed_modifications))
}
