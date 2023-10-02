github_slug <- function(remote = "origin") {
  if (nzchar(Sys.getenv("FLEDGE_TEST_GITHUB_SLUG"))) {
    return(Sys.getenv("FLEDGE_TEST_GITHUB_SLUG"))
  }
  remote_url <- get_remote_url(remote)
  extract_repo(remote_url)
}

github_info <- function(remote = "origin") {
  repo <- github_slug(remote)
  get_repo_data(repo)
}

get_remote_url <- function(remote) {
  gert::git_remote_info(remote = remote)$url
}

extract_repo <- function(url) {
  # Borrowed from gh:::github_remote_parse
  re <- "github[^/:]*[/:]([^/]+)/(.*?)(?:\\.git)?$"
  m <- regexec(re, url)
  match <- regmatches(url, m)[[1]]

  if (length(match) == 0) {
    cli::cli_abort("Unrecognized repo format: {.val {url}}.")
  }

  paste0(match[2], "/", match[3])
}

get_repo_data <- function(repo) {
  req <- gh("/repos/:repo", repo = repo)
  return(req)
}
