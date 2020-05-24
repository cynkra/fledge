#' Automating CRAN release
#'
#' `pre_release()` is run when development of a package is finished
#' and it is ready to be sent to CRAN.
#'
#' @name release
#' @export
pre_release <- function(which = "patch") {
  check_only_modified(character())

  stopifnot(which %in% c("patch", "minor", "major"))

  with_repo(pre_release_impl(which))
}

pre_release_impl <- function(which) {
  bump_version(which)
  update_cran_comments()
  ui_todo("Run {ui_code('devtools::check_win_devel()')}")
  ui_todo("Run {ui_code('rhub::check_for_cran()')}")
  ui_todo("Check all items in {ui_path('cran-comments.md')}")
  ui_todo("Run {ui_code('fledge:::release()')}")
  send_to_console("callr::r(function() { devtools::check_win_devel(); rhub::check_for_cran() })")
}

update_cran_comments <- function() {
  package <- desc::desc_get("Package")
  crp_date <- get_crp_date()
  cransplainer <- get_cransplainer(package)

  unlink("cran-comments.md")
  use_template(
    "cran-comments.md",
    package = "fledge",
    data = list(
      package = package,
      version = desc::desc_get_version(),
      crp_date = crp_date,
      rversion = glue("{version$major}.{version$minor}"),
      latest_rversion = rversions::r_release()[["version"]],
      cransplainer = cransplainer
    ),
    ignore = TRUE,
    open = TRUE
  )

  # FIXME: CRP compare
  # https://github.com/octo-org/wikimania/compare/master@%7B07-22-16%7D...master@%7B08-04-16%7D

  git2r::add(path = "cran-comments.md")
  git2r::commit(message = "Update CRAN comments")
}

get_crp_date <- function() {
  cmt <- gh::gh("/repos/eddelbuettel/crp/commits")[[1]]
  date <- cmt$commit$committer$date
  as.Date(date)
}

get_cransplainer <- function(package) {
  local_options(repos = c(CRAN = "https://cran.r-project.org"))

  checked_on <- paste0("Checked on ", Sys.Date())

  details <- foghorn::cran_details(package)
  details <- details[details$result != "OK", ]
  if (nrow(details) == 0) {
    return(paste0("- [x] ", checked_on, ", no errors found."))
  }

  cransplainer <- paste0(
    "- [x] ", checked_on, ", errors found: ", url, "\n",
    paste0("- [ ] ", details$result, ": ", details$flavors, collapse = "\n")
  )

  url <- foghorn::visit_cran_check(package)
  ui_done("Review {ui_path(url)}")

  paste0(cransplainer, "\n\nCheck results at: ", url)
}

#' @description
#' `release()` sends to CRAN after performing several checks,
#' and offers help with accepting the submission.
#'
#' @export
release <- function() {
  check_only_modified(character())

  stopifnot(is_news_consistent())
  stopifnot(is_cran_comments_good())
  stopifnot(is_pushed())

  devtools::submit_cran()
  auto_confirm()
}

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

is_cran_comments_good <- function() {
  text <- readLines("cran-comments.md")
  !any(grepl("- [ ]", text, fixed = TRUE))
}

is_pushed <- function() {
  head <- git2r::repository_head()
  stopifnot(git2r::is_branch(head))

  upstream <- git2r::branch_get_upstream(head)
  stopifnot(git2r::is_branch(upstream))

  all(git2r::ahead_behind(head, upstream) == 0)
}

auto_confirm <- function() {
  ui_todo("Check your inbox for a confirmation e-mail from CRAN")
  ui_todo("Copy the URL to your clipboard")

  tryCatch(
    repeat {
      url <- clipr::read_clip()
      if (has_length(url, 1) && grepl("^https://xmpalantir\\.wu\\.ac\\.at/cransubmit/conf_mail\\.php[?]code=", url)) {
        break
      }
      Sys.sleep(0.01)
    },
    interrupt = function(e) {
      ui_todo("Restart with `fledge:::auto_confirm()` (or confirm manually), rerelease with `fledge:::release()`.")
      return()
    }
  )

  code <- paste0('browseURL("', get_confirm_url(url), '")')
  ui_todo("Run {ui_code(code)}")
  send_to_console(code)
}

confirm_submission <- function(url) {
  url <- get_confirm_url(url)

  ui_done("Visiting {ui_path(url)}")
  utils::browseURL(url)
}

get_confirm_url <- function(url) {
  parsed <- httr::parse_url(url)

  parsed$query$policy_check2 <- "on"
  parsed$query$policy_check3 <- "on"
  parsed$query$policy_check4 <- "on"
  parsed$query$confirm_submit <- "Upload Package to CRAN"

  httr::build_url(parsed)
}

#' @description
#' `post_release()` should be called after the submission has been accepted.
#'
#' @rdname release
#' @export
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
