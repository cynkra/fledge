#' Automating CRAN release
#'
#' `pre_release()` is run when development of a package is finished
#' and it is ready to be sent to CRAN.
#'
#' `pre_release()`:
#' - Ensures that no modified files are in the git index.
#' - Bumps version to a non-development version which should be sent to CRAN.
#' - Writes/updates `cran-comments.md` with useful information about the current
#' release process.
#' - Prompts the user to run `devtools::check_win_devel()`.
#' - Prompts the user to run `rhub::check_for_cran()`.
#'
#' @inheritParams bump_version
#' @param force Create branches and tags even if they exist.
#'   Useful to recover from a previously failed attempt.
#' @name release
#' @export
pre_release <- function(which = "patch", force = FALSE) {
  check_only_modified(character())

  check_gitignore("cran-comments.md")

  stopifnot(which %in% c("patch", "minor", "major"))

  local_options(usethis.quiet = TRUE)
  with_repo(pre_release_impl(which, force))
}

pre_release_impl <- function(which, force) {
  # FIXME: Needs repair in create_release_branch()
  stopifnot(!force)

  cat(boxx("pre-release", border_style = "double"))

  # https://github.com/r-lib/gert/issues/139
  stopifnot(gert::git_branch() != "HEAD")

  # check PAT scopes for PR for early abort
  check_gh_scopes()

  # Begin extension points
  # End extension points

  # We expect that this branch is pushed already, ok to fail here
  main_branch <- get_branch_name()
  remote_name <- get_remote_name(main_branch)

  # Commit ignored files as early as possible
  usethis::use_git_ignore("CRAN-RELEASE")
  usethis::use_build_ignore("CRAN-RELEASE")
  commit_ignore_files()

  cli_h1("1. Creating a release branch and getting ready")

  # bump version on main branch to version set by user
  bump_version(which)

  # switch to release branch and update cran-comments
  release_branch <- create_release_branch()
  switch_branch(release_branch)
  update_cran_comments()

  push_to_new(remote_name)
  switch_branch(main_branch)
  push_head(main_branch)

  cli_h1("2. Bumping main branch to dev version and updating NEWS")
  # manual implementation of bump_version(), it doesn't expose `force` yet
  bump_version_to_dev_with_force(force)
  push_head(main_branch)

  cli_h1("3. Opening Pull Request for release branch")
  # switch to release branch and init pre_release actions
  switch_branch(release_branch)
  cli_alert("Opening draft pull request with contents from {.file cran-comments.md}.")
  create_pull_request(release_branch, main_branch, remote_name, force)

  # user action items
  cli_h1("4. User Action Items")

  cli_div(theme = list(ul = list(color = "magenta")))
  cli_ul("Run {.code devtools::check_win_devel()}.")
  cli_ul("Run {.code rhub::check_for_cran()}.")
  cli_ul("Run {.code urlchecker::url_update()}.")
  cli_ul("Check all items in {.file cran-comments.md}.")
  cli_ul("Convert {.file NEWS.md} from changelog format to release notes.")
  cli_ul("Run {.code fledge::release()}.")
  cli_end()

  Sys.sleep(2)

  send_to_console("checks <- callr::r_bg(function() { devtools::check_win_devel(quiet = TRUE); rhub::check_for_cran(); urlchecker::url_update() })")

  # Begin extension points
  # End extension points
}

get_branch_name <- function() {
  gert::git_branch()
}

get_remote_name <- function(branch) {
  branch_info <- gert::git_branch_list()
  # branch_info$name is unique: remote branches are prefixed with their remote name.
  branch_info$upstream[branch_info$name == branch]
  upstream <- branch_info$upstream[branch_info$name == branch]

  # The third path component of the full upstream branch
  remote <- gsub("^refs/remotes/([^/]+)/.*$", "\\1", upstream)
  stopifnot(remote != upstream)
  remote
}

create_release_branch <- function(force) {
  branch_name <- paste0("cran-", desc::desc_get_version())

  cli_alert("Creating branch {.field {branch_name}}.")

  # FIXME: Obey `force` argument
  stopifnot(!force)

  # if (gert::git_branch_exists(branch_name)) {
  #   if (force) {
  #     gert::git_branch_delete(branch_name)
  #   } else {
  #     abort(...)
  #   }
  # }
  gert::git_branch_create(branch = branch_name)
  branch_name
}

switch_branch <- function(name) {
  cli_alert("Switching to branch {.field {name}}.")
  gert::git_branch_checkout(branch = name)
}

update_cran_comments <- function() {
  package <- desc::desc_get("Package")
  crp_date <- get_crp_date()
  old_crp_date <- get_old_crp_date()

  if (!is.na(old_crp_date) && crp_date != old_crp_date) {
    url <- glue("https://github.com/eddelbuettel/crp/compare/master@%7B{old_crp_date}%7D...master@%7B{crp_date}%7D")
    utils::browseURL(url)

    crp_cross <- " "
    crp_changes <- glue("\n\nSee changes at {url}", .trim = FALSE)
  } else {
    crp_cross <- "x"
    crp_changes <- ""
  }

  cransplainer <- get_cransplainer(package)

  unlink("cran-comments.md")
  local_options(usethis.quiet = TRUE)
  use_template(
    "cran-comments.md",
    package = "fledge",
    data = list(
      package = package,
      version = desc::desc_get_version(),
      crp_date = crp_date,
      crp_cross = crp_cross,
      crp_changes = crp_changes,
      rversion = glue("{version$major}.{version$minor}"),
      latest_rversion = rversions::r_release()[["version"]],
      cransplainer = cransplainer
    ),
    ignore = TRUE,
    open = TRUE
  )

  gert::git_add(files = "cran-comments.md")
  gert::git_commit(message = "Update CRAN comments")
}

get_crp_date <- function() {
  cmt <- gh::gh("/repos/eddelbuettel/crp/commits")[[1]]
  date <- cmt$commit$committer$date
  as.Date(date)
}

get_old_crp_date <- function() {
  if (!file.exists("cran-comments.md")) {
    return(NA)
  }
  text <- get_cran_comments_text()

  rx <- "^.* CRP .*([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]).*$"

  crp <- grep(rx, text)
  if (length(crp) == 0) {
    return(NA)
  }
  crp <- crp[[1]]
  date <- gsub(rx, "\\1", text[[crp]])
  as.Date(date)
}

get_cransplainer <- function(package) {
  if (!is_new_submission(package)) {
    get_cransplainer_update(package)
  } else {
    "Initial release."
  }
}

is_new_submission <- function(package) {
  !(package %in% rownames(utils::available.packages(repos = c(CRAN = "https://cran.r-project.org"))))
}

get_cransplainer_update <- function(package) {

  local_options(repos = c(CRAN = "https://cran.r-project.org"))

  checked_on <- paste0("Checked on ", get_date())

  details <- foghorn::cran_details(package)
  details <- details[details$result != "OK", ]
  if (nrow(details) == 0) {
    return(paste0("- [x] ", checked_on, ", no problems found."))
  }

  url <- foghorn::visit_cran_check(package)
  cli_ul("Review {.url {url}}.")

  cransplainer <- paste0(
    "- [x] ", checked_on, ", problems found: ", url, "\n",
    paste0("- [ ] ", details$result, ": ", details$flavors, collapse = "\n")
  )

  paste0(cransplainer, "\n\nCheck results at: ", url)
}

#' @description
#' `release()` sends to CRAN after performing several checks,
#' and offers help with accepting the submission.
#'
#' @export
release <- function() {
  with_repo(release_impl())
}

release_impl <- function() {

  check_for_rc()
  check_only_modified(character())

  stopifnot(is_news_consistent())
  stopifnot(is_cran_comments_good())

  # Begin extension points
  # End extension points

  push_head()
  # FIXME: Copy code from devtools, silent release
  devtools::submit_cran()
  tag <- tag_release_candidate()
  push_tag(tag)
  auto_confirm()

  # Begin extension points
  # End extension points
}

is_news_consistent <- function() {
  headers <- with_repo(get_news_headers())

  # One entry is fine, zero entries are an error
  if (length(headers$version) <= 1) {
    return(length(headers$version) == 1)
  }

  versions <- package_version(headers$version[1:2], strict = TRUE)

  all(lengths(unclass(versions)) <= 3)
}

get_cran_comments_text <- function() {
  readLines("cran-comments.md")
}

is_cran_comments_good <- function() {
  text <- get_cran_comments_text()
  !any(grepl("- [ ]", text, fixed = TRUE))
}

auto_confirm <- function() {
  cli_alert_info("Check your inbox for a confirmation e-mail from CRAN.")
  cli_alert("Copy the URL to the clipboard.")

  tryCatch(
    repeat {
      url <- clipr::read_clip()
      if (has_length(url, 1) && grepl("^https://xmpalantir\\.wu\\.ac\\.at/cransubmit/conf_mail\\.php[?]code=", url)) {
        break
      }
      Sys.sleep(0.01)
    },
    interrupt = function(e) {
      cli_ul("Restart with {.fun fledge:::auto_confirm} (or confirm manually), re-release with {.fun fledge:::release}.")
      rlang::cnd_signal(e)
    }
  )

  code <- paste0('browseURL("', get_confirm_url(url), '")')
  cli_ul("Run {.cdoe {code}}.")
  send_to_console(code)
}

confirm_submission <- function(url) {
  url <- get_confirm_url(url)

  cli_alert("Visiting {.url {url}}.")
  utils::browseURL(url)
}

get_confirm_url <- function(url) {
  parsed <- httr::parse_url(url)

  parsed$query$policy_check2 <- "on"
  parsed$query$policy_check3 <- "on"

  package <- desc::desc_get("Package")
  if (!is_new_submission(package)) {
    parsed$query$policy_check4 <- "on"
  }
  parsed$query$confirm_submit <- utils::URLencode("Upload Package to CRAN")

  httr::build_url(parsed)
}

#' @description
#' `post_release()` should be called after the submission has been accepted.
#'
#' @rdname release
#' @export
post_release <- function() {
  with_repo(post_release_impl())
}

post_release_impl <- function() {

  cli_h2("Post-release actions")

  check_only_modified(c(".Rbuildignore", "CRAN-RELEASE"))

  check_post_release()

  # Begin extension points
  # End extension points

  tag <- tag_version(force = TRUE)

  push_tag(tag)

  delete_release_candidate_tags()

  usethis::use_github_release()

  # FIXME: Check if PR open, if yes merge PR instead
  release_branch <- get_branch_name()
  switch_branch(get_main_branch())
  merge_branch(release_branch)
  push_head()

  # Begin extension points
  # End extension points
}

merge_branch <- function(other_branch) {
  gert::git_merge(other_branch)
}

check_post_release <- function() {
  cli_alert("Checking scope of {.var GITHUB_PAT} environment variable.")

  # FIXME: Distinguish between public and private repo?
  check_gh_scopes()

  cli_alert("Checking contents of {.file CRAN-RELEASE}.")
  if (!file.exists("CRAN-RELEASE")) {
    abort("File `CRAN-RELEASE` not found. Recreate with `devtools:::flag_release()`.")
  }

  release <- paste(readLines("CRAN-RELEASE"), collapse = "\n")
  rx <- "^.*[(]commit ([0-9a-f]+)[)].*$"
  commit <- grepl(rx, release)
  if (!commit) {
    abort("Unexpected format of `CRAN-RELEASE` file. Recreate with `devtools:::flag_release()`.")
  }
  sha <- gsub(rx, "\\1", release)

  sha_rx <- paste0("^", sha)
  repo_head_sha <- gert::git_log(max = 1)$commit
  if (!grepl(sha_rx, repo_head_sha)) {
    msg <- paste0(
      "Commit recorded in `CRAN-RELEASE` file (", sha, ") ",
      "different from HEAD (", repo_head_sha, "). ",
      "Reset to the correct commit or overwrite with `devtools:::flag_release()`."
    )

    abort(msg)
  }

  return(invisible(repo_head_sha))
}

check_gh_scopes <- function() {
  if (!("repo" %in% gh_scopes())) {
    abort('Please set `GITHUB_PAT` to a PAT that has at least the "repo" scope.')
  }
}

gh_scopes <- function() {
  out <- attr(gh::gh("/user"), "response")$"x-oauth-scopes"
  if (out == "") {
    return(character())
  }
  strsplit(out, ", *")[[1]]
}

check_for_rc <- function() {

  # check if current commit is on a RC tag
  sha_commit <- gert::git_commit_id()
  sha_last_tag <- tail(gert::git_tag_list(), 1)$commit


  if (sha_commit == sha_last_tag) {
    if ("-rc" %in% tail(gert::git_tag_list(), 1)$name) {
      stop("Running on a release candidate commit, terminating.")
      cli_alert_warning("The branch must be at least one commit ahead of the
                        last release candidate tag to initiate a new release.")
    }
  }
}

check_gitignore <- function(files) {
  is_ignored <- map_lgl(files, is_ignored)

  if (any(is_ignored)) {
    files_ignored <- files[is_ignored]
    cli::cli_alert_warning("The following files are listed in {.file .gitignore}:")
    cli::cli_ul("{files_ignored}")
    cli::cli_text("Certain {.pkg fledge} automation steps might fail due to this.")
    abort(paste0("Remove ", glue_collapse(files_ignored, ", "), " from .gitignore."))
  }
}

is_ignored <- function(path) {
  system2("git", c("check-ignore", "-q", path), stdout = FALSE) != 1
}

create_pull_request <- function(release_branch, main_branch, remote_name, force) {
  if (force) {
    # Remove cached config so that pr_url() always checks
    # if we happened to overwrite the branch
    config_url <- glue("branch.{release_branch}.pr-url")
    gert::git_config_set(config_url, NULL)

    create <- is.null(usethis:::pr_url())
  } else {
    create <- TRUE
  }

  if (create) {
    info <- github_info(remote = remote_name)
    template_path <- system.file("templates", "pr.md", package = "fledge")
    body <- glue_collapse(readLines(template_path), sep = "\n")

    gh::gh("POST /repos/:owner/:repo/pulls",
      owner = info$owner$login,
      repo = info$name,
      title = sprintf(
        "CRAN release v%s",
        strsplit(gert::git_branch(), "cran-")[[1]][2]
      ),
      head = release_branch,
      base = main_branch,
      maintainer_can_modify = TRUE,
      draft = TRUE,
      body = body
    )
  }
  usethis::pr_view()
}

commit_ignore_files <- function() {
  gert::git_add(files = c(".gitignore", ".Rbuildignore"))


  if (nrow(gert::git_status(staged = TRUE)) > 0) {
    cli_alert("Committing {.file .gitignore} and {.file .Rbuildignore}.")
    gert::git_commit(message = "Update `.gitignore` and/or `.Rbuildignore`")
  }
}
