is_news_consistent <- function() {
  headers <- with_repo(get_news_headers())

  versions <- package_version(headers, strict = TRUE)

  all(lengths(unclass(versions)) <= 3)
}


get_news_headers <- function() {
  news_path <- "NEWS.md"
  news <- readLines(news_path)
  top_level_headers <- grep("^# [a-zA-Z][a-zA-Z0-9.]+[a-zA-Z0-9] [0-9.-]+", news)
  top_level_headers <- utils::head(top_level_headers, 2)
  gsub("^# [^0-9]+", "", news[top_level_headers])
}


confirm_submission <- function(url) {
  parsed <- httr::parse_url(url)

  parsed$query$policy_check2 <- "on"
  parsed$query$policy_check3 <- "on"
  parsed$query$policy_check4 <- "on"
  parsed$query$confirm_submit <- "Upload Package to CRAN"

  url <- httr::build_url(parsed)
  ui_done("Visiting {ui_path(url)}")
  utils::browseURL(url)
}

post_release <- function() {
  check_only_modified(c(".Rbuildignore", "CRAN-RELEASE"))

  sha <- check_post_release()

  tag <- tag_version()

  push_tag(tag)

  usethis::use_github_release()

  bump_version()
}

check_post_release <- function() {
  ui_info("Checking scope of {ui_code('GITHUB_PAT')} environment variable")

  # FIXME: Distinguish between public and private repo?
  if (!("repo" %in% gh_scopes())) {
    abort('Please set `GITHUB_PAT` to a PAT that has at least the "repo" scope.')
  }

  ui_info("Checking contents of {ui_path('CRAN-RELEASE')}")
  if (!file.exists("CRAN-RELEASE")) {
    abort('File `CRAN-RELEASE` not found. Recreate with `devtools:::flag_release()`.')
  }

  release <- paste(readLines("CRAN-RELEASE"), collapse = "\n")
  rx <- "^.*[(]commit ([0-9a-f]+)[)].*$"
  commit <- grepl(rx, release)
  if (!commit) {
    abort('Unexpected format of `CRAN-RELEASE` file. Recreate with `devtools:::flag_release()`.')
  }
  sha <- gsub(rx, "\\1", release)

  sha_rx <- paste0("^", sha)
  repo_head <- get_repo_head()
  repo_head_sha <- git2r::sha(repo_head)
  if (!grepl(sha_rx, repo_head_sha)) {
    msg <- paste0(
      "Commit recorded in `CRAN-RELEASE` file (", sha, ") ",
      "different from HEAD (", repo_head_sha, ")."
    )

    abort(msg)
  }

  repo_head_sha
}

gh_scopes <- function() {
  out <- attr(gh::gh("/user"), "response")$"x-oauth-scopes"
  if (out == "") return(character())
  strsplit(out, ", *")[[1]]
}
