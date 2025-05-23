#' Automating CRAN release
#'
#' `plan_release()` is run
#' when a milestone in the development of a package is reached
#' and it is ready to be sent to CRAN.
#' By default, this function will initiate a pre-release, indicated by `9900`
#' in the fourth component of the version number.
#' Pass `which = "patch"`, `which = "minor"`, or `which = "major"` to
#' initiate a release with the corresponding version number.
#'
#' `plan_release()`:
#' - Ensures that no modified files are in the Git index.
#' - Creates a pre-release or release branch and bumps the version accordingly.
#' - Writes/updates `cran-comments.md` with useful information about the current
#'   release process.
#' - Runs `urlchecker::url_update()`, `devtools::check_win_devel()`,
#'   and `rhub::rhub_check(platforms = rhub::rhub_platforms()$name)`
#'   in the background of the RStudio IDE, or prompts the user to do so.
#' - Opens a pull request for the release branch for final checks.
#'
#' @param which Component of the version number to update. Supported
#'   values are
#'   * `"pre-patch"` (default, `x.y.z.9900`)
#'   * `"pre-minor"` (`x.y.99.9900`),
#'   * `"pre-major"` (`x.99.99.9900`),
#'   * `"next"` (`"major"` if the current version is `x.99.99.9yyy`,
#'     `"minor"` if the current version is `x.y.99.9zzz`,
#'     `"patch"` otherwise),
#'   * `"patch"`
#'   * `"minor"`,
#'   * `"major"`.
#' @param force Create branches and tags even if they exist.
#'   Useful to recover from a previously failed attempt.
#' @rdname release
#' @export
plan_release <- function(
  which = c("pre-patch", "pre-minor", "pre-major", "next", "patch", "minor", "major"),
  force = FALSE
) {
  which <- arg_match(which)

  # Check PAT early
  check_gh_pat("repo")

  local_repo()
  check_main_branch("plan_release()")
  check_only_modified(character())
  check_gitignore("cran-comments.md")
  pull_head()

  check_suggested(
    c("job", "devtools", "rhub", "urlchecker", "pkgbuild", "foghorn"),
    "plan_release"
  )

  if (which == "next") {
    which <- guess_next()
  }

  local_options(usethis.quiet = TRUE)

  plan_release_impl(which, force)
}

plan_release_impl <- function(which, force) {
  # Checking if it's an orphan branch: https://github.com/r-lib/gert/issues/139
  stopifnot(get_branch_name() != "HEAD")

  orig_fledgeling <- read_fledgling()

  fledgeling <- update_news_impl(
    default_commit_range(current_version = orig_fledgeling$version),
    which = "dev",
    fledgeling = orig_fledgeling,
    no_change_message = NA_character_
  )

  if (!identical(fledgeling, orig_fledgeling)) {
    write_fledgling(fledgeling)
    finalize_version_impl(push = TRUE)
  }

  new_version <- fledge_guess_version(fledgeling[["version"]], which)

  if (!force) {
    check_release_branch(new_version)
  }

  if (fledge_chatty()) {
    cat(boxx("plan_release", border_style = "double"))
  }

  # Begin extension points
  # End extension points

  # Don't bump here, want to be compatible with merge queues at some point

  if (fledge_chatty()) {
    cli_h1("1. Creating a release branch and getting ready")
  }

  # regroup dev news
  fledgeling <- merge_dev_news(fledgeling, new_version)

  # switch to release branch and update cran-comments
  release_branch <- create_release_branch(new_version, force)
  switch_branch(release_branch)

  update_cran_comments(new_version)
  gert::git_add(c("cran-comments.md", ".Rbuildignore"))
  gert::git_commit("CRAN comments")

  write_fledgling(fledgeling)
  commit_version_impl()

  edit_news()
  edit_cran_comments()

  check_only_modified(c("NEWS.md", "cran-comments.md"))
  gert::git_add(c("NEWS.md", "cran-comments.md"))
  if (nrow(gert::git_status(staged = TRUE)) > 0) {
    gert::git_commit("NEWS and CRAN comments")
  }

  if (fledge_chatty()) {
    cli_h1("2. Opening Pull Request for release branch")
  }

  main_branch <- get_main_branch()
  remote_name <- get_remote_name(main_branch)

  # push main branch, bump to devel version and push again
  push_to_new(remote_name, force)

  if (fledge_chatty()) {
    cli_alert("Opening pull request with instructions.")
  }

  create_pull_request(get_branch_name(), main_branch, remote_name, force)

  has_src <- pkgbuild::pkg_has_src()

  if (is_installed("job") && rstudioapi::isAvailable() && !nzchar(Sys.getenv("FLEDGE_TEST_NOGH"))) {
    inject(job::empty(title = "check_win_devel", {
      devtools::check_win_devel()
    }))
    if (has_src) {
      inject(job::empty(title = "rhub", {
        rhub::rhub_check(platforms = rhub::rhub_platforms()$name, branch = !!release_branch)
      }))
    }
    inject(job::empty(title = "url_update", {
      urlchecker::url_update()
    }))

    if (fledge_chatty()) {
      cli_h1("3. User Action Items")
      cli_div(theme = list(ul = list(color = "magenta")))
      cli_ul("Check all items in {.file cran-comments.md}.")
      cli_ul("Review {.file NEWS.md}.")

      if (is_dev_version(fledgeling$version)) {
        # FIXME: Is this the right code?
        cli_ul("Run {.run fledge::finalize_version(push = TRUE)}.")
        cli_ul("Merge the PR.")
        cli_ul('Restart with {.run fledge::plan_release("next")}.')
      } else {
        cli_ul("Run {.run fledge::release()}.")
      }

      cli_end()
    }
  } else {
    # user action items
    if (fledge_chatty()) {
      cli_h1("3. User Action Items")
      cli_div(theme = list(ul = list(color = "magenta")))
      cli_ul("Run {.run devtools::check_win_devel()}.")
      if (has_src) cli_ul("Run {.run rhub::rhub_check(platforms = rhub::rhub_platforms()$name, branch = '{release_branch}')}.")
      cli_ul("Run {.run urlchecker::url_update()}.")
      cli_ul("Check all items in {.file cran-comments.md}.")
      cli_ul("Review {.file NEWS.md}.")

      url_update_code <- "urlchecker <- urlchecker::url_update()"
      winbuilder_code <- "winbuilder = devtools::check_win_devel(quiet = TRUE)"
      if (has_src) {
        rhub_code <- ", rhub = if (FALSE) rhub::rhub_check(platforms = rhub::rhub_platforms()$name, branch = '{release_branch}')"
      } else {
        rhub_code <- ""
      }
      send_to_console(
        glue("{url_update_code}; fledge:::bg_r({winbuilder_code}{rhub_code})")
      )

      if (is_dev_version(fledgeling$version)) {
        # FIXME: Is this the right code?
        cli_ul("Run {.run fledge::finalize_version(push = TRUE)}.")
        cli_ul("Merge the PR.")
        cli_ul('Restart with {.run fledge::plan_release("next")}.')
      } else {
        cli_ul("Run {.run fledge::release()}.")
      }

      cli_end()
    }
  }

  # Begin extension points
  # End extension points
}

guess_next <- function() {
  desc <- desc::desc(file = "DESCRIPTION")
  guess_next_impl(desc$get_version())
}

guess_next_impl <- function(version) {
  version_components <- get_version_components(version)
  if (version_components[["patch"]] == 99) {
    if (version_components[["minor"]] == 99) {
      which <- "major"
    } else {
      which <- "minor"
    }
  } else {
    which <- "patch"
  }

  return(which)
}

get_branch_name <- function() {
  gert::git_branch()
}

get_remote_name <- function(branch = get_main_branch()) {
  branch_info <- gert::git_branch_list()
  # branch_info$name is unique: remote branches are prefixed with their remote name.
  branch_info$upstream[branch_info$name == branch]
  upstream <- branch_info$upstream[branch_info$name == branch]

  # The third path component of the full upstream branch
  remote <- gsub("^refs/remotes/([^/]+)/.*$", "\\1", upstream)
  stopifnot(remote != upstream)
  remote
}

merge_dev_news <- function(fledgeling, new_version) {
  dev_idx <- grepl("^[0-9]+[.][0-9]+[.][0-9]+[.][0-9]+$", fledgeling[["news"]]$version)
  stopifnot(dev_idx[[1]])

  n_dev <- rle(dev_idx)$lengths[[1]]

  raw <- write_news_sections(fledgeling[["news"]][seq_len(n_dev), ])
  versions <- parse_news_md(raw)
  news <- news_from_versions(versions)

  news <- regroup_news(unlist(news, recursive = FALSE))

  raw <- format_news_subsections(news, header_level = 2)

  new_section <- tibble::tibble(
    start = 3,
    end = NA,
    h2 = any(fledgeling[["news"]][["h2"]][seq_len(n_dev)]),
    version = new_version,
    date = maybe_date(fledgeling[["news"]]),
    nickname = NA,
    raw = raw,
    title = "",
    section_state = "new"
  )

  fledgeling[["version"]] <- as.package_version(new_version)
  fledgeling[["news"]] <- vctrs::vec_rbind(
    new_section,
    fledgeling[["news"]][-seq_len(n_dev), ]
  )

  fledgeling
}

get_release_branch_from_version <- function(version) {
  paste0("cran-", version)
}

check_release_branch <- function(new_version) {
  branch_name <- get_release_branch_from_version(new_version)

  if (gert::git_branch_exists(branch_name)) {
    cli_abort(c(
      x = "The branch {.val {branch_name}} already exists.",
      i = "Do you need {.code plan_release(force = TRUE)}?"
    ))
  }
}

create_release_branch <- function(version,
                                  force,
                                  ref = "HEAD") {
  branch_name <- get_release_branch_from_version(version)

  if (fledge_chatty()) cli_alert("Creating branch {.field {branch_name}}.")

  if (gert::git_branch_exists(branch_name) && force) {
    gert::git_branch_delete(branch_name)
  }

  # Fails if not force and branch exists
  gert::git_branch_create(branch = branch_name, ref = ref)

  branch_name
}

switch_branch <- function(name) {
  if (fledge_chatty()) cli_alert("Switching to branch {.field {name}}.")
  gert::git_branch_checkout(branch = name)
}

update_cran_comments <- function(new_version) {
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

  unlink("cran-comments.md")
  local_options(usethis.quiet = TRUE)
  use_template(
    "cran-comments.md",
    package = "fledge",
    data = list(
      package = package,
      version = new_version,
      # FIXME: Add additional info if re-release
      re_release = "",
      crp_date = crp_date,
      crp_cross = crp_cross,
      crp_changes = crp_changes
    ),
    ignore = TRUE
  )
}

get_crp_date <- function() {
  if (nzchar(Sys.getenv("FLEDGE_TEST_NOGH"))) {
    return(as.Date(NA))
  }

  cmt <- gh("/repos/eddelbuettel/crp/commits")[[1]]
  date <- cmt$commit$committer$date
  as.Date(date)
}

get_old_crp_date <- function() {
  if (!file.exists("cran-comments.md")) {
    return(as.Date(NA))
  }
  text <- get_cran_comments_text()

  rx <- "^.* CRP .*([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]).*$"

  crp <- grep(rx, text)
  if (length(crp) == 0) {
    return(as.Date(NA))
  }
  crp <- crp[[1]]
  date <- gsub(rx, "\\1", text[[crp]])
  as.Date(date)
}

get_cransplainer <- function() {
  package <- desc::desc_get("Package")

  if (!is_new_submission(package)) {
    get_cransplainer_update(package)
  } else {
    "Initial release."
  }
}

is_new_submission <- function(package) {
  if (nzchar(Sys.getenv("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST"))) {
    return(TRUE)
  }

  !(package %in% rownames(utils::available.packages(repos = c(CRAN = "https://cran.r-project.org"))))
}

get_cransplainer_update <- function(package) {
  local_options(repos = c(CRAN = "https://cran.r-project.org"))

  checked_on <- paste0("Checked on ", get_date())

  details <- foghorn::cran_details(package)
  details <- details[details$result != "OK", ]

  # We know that installation size warnings are fine
  is_size_problem <- grepl("installed size", details$message)
  details <- details[!is_size_problem, ]

  if (nrow(details) == 0) {
    return(paste0(
      "- [x] ",
      checked_on,
      ", no problems ",
      if (any(is_size_problem)) "(other than installation size) ",
      "found."
    ))
  }

  url <- foghorn::visit_cran_check(package)
  if (fledge_chatty()) cli_ul("Review {.url {url}}.")

  cransplainer <- paste0(
    "- [x] ", checked_on, ", problems found: ", url, "\n",
    paste0("- [ ] ", details$result, ": ", details$flavors, "\n", substr(details$message, 1, 2000), collapse = "\n")
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
  check_only_modified(character())

  stopifnot(is_news_consistent())
  stopifnot(is_cran_comments_good())

  # Begin extension points
  # End extension points

  push_head()

  tag <- tag_version(force = TRUE)
  push_tag(tag)

  submit_cran()
  auto_confirm()

  # Begin extension points
  # End extension points
}

is_news_consistent <- function() {
  headers <- get_news_headers()

  is_release <- version_is_release(utils::head(headers$version, 3))
  # One entry is fine, zero entries are an error
  length(is_release) > 0 && all(is_release)
}

get_cran_comments_text <- function() {
  brio::read_lines("cran-comments.md")
}

is_cran_comments_good <- function() {
  text <- get_cran_comments_text()
  !any(grepl("- [ ]", text, fixed = TRUE))
}

auto_confirm <- function() {
  if (fledge_chatty()) {
    cli_alert_info("Check your inbox for a confirmation e-mail from CRAN.")
  }
  if (fledge_chatty()) cli_alert("Copy the URL to the clipboard.")
  if (nzchar(Sys.getenv("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST"))) {
    cli::cli_inform("Not submitting for real o:-)")
    return(invisible(NULL))
  }
  tryCatch(
    repeat {
      suppressWarnings(url <- clipr::read_clip())
      if (has_length(url, 1) && grepl("^https://xmpalantir\\.wu\\.ac\\.at/cransubmit/conf_mail\\.php[?]code=", url)) {
        break
      }
      Sys.sleep(0.1)
    },
    interrupt = function(e) {
      cli_ul("Restart with {.fun fledge:::auto_confirm} (or confirm manually), re-release with {.fun fledge:::release}.")
      rlang::cnd_signal(e)
    }
  )

  clipr::write_clip("")

  code <- paste0('utils::browseURL("', get_confirm_url(url), '")')
  if (fledge_chatty()) cli_ul("Run {.run {code}}.")
  send_to_console(code)

  invisible()
}

confirm_submission <- function(url) {
  url <- get_confirm_url(url)

  if (fledge_chatty()) cli_alert("Visiting {.url {url}}.")
  utils::browseURL(url)
}

get_confirm_url <- function(url) {
  parsed <- httr2::url_parse(url)

  parsed$query$policy_check2 <- "on"
  parsed$query$policy_check3 <- "on"

  package <- desc::desc_get("Package")
  if (!is_new_submission(package)) {
    parsed$query$policy_check4 <- "on"
  }
  parsed$query$confirm_submit <- utils::URLencode("Upload Package to CRAN")

  httr2::url_build(parsed)
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
  check_only_modified(c(".Rbuildignore"))
  # Need PAT for creating GitHub release
  check_gh_pat("repo")

  # Begin extension points
  # End extension points

  create_github_release()

  # Begin extension points
  # End extension points
}

create_github_release <- function(version) {
  fledgling <- read_fledgling()

  version <- get_last_release_version(fledgling)
  tag <- paste0("v", version)

  if (fledge_chatty()) {
    cli_alert("Creating GitHub release {.val {tag}}.")
  }

  if (nzchar(Sys.getenv("FLEDGE_TEST_NOGH"))) {
    cli_alert("Omitting in test.")
    return(invisible())
  }

  slug <- github_slug()

  existing_releases <- gh(glue("/repos/{slug}/releases"))
  existing_tags <- map_chr(existing_releases, "tag_name")

  if (any(existing_tags == tag)) {
    release <- existing_releases[[which(existing_tags == tag)]]
    if (fledge_chatty()) {
      cli_alert("Release {.url {release$html_url}} already exists.")
    }
    return(invisible())
  }

  stopifnot(sum(fledgling[["news"]]$version == version) == 1)
  header <- paste0(fledgling$name, " ", version)
  body <- fledgling[["news"]]$raw[fledgling[["news"]]$version == version]

  body <- gsub("^# [^\n]*\n+", "", body)

  out <- gh(
    glue("POST /repos/{slug}/releases"),
    tag_name = tag,
    name = header,
    body = body
  )

  if (rlang::is_interactive()) {
    url <- out$html_url

    if (fledge_chatty()) cli_alert("Opening release URL {.url {url}}.")
    utils::browseURL(url)

    edit_url <- gsub("/tag/", "/edit/", url)

    if (fledge_chatty()) cli_alert("Opening release edit URL {.url {edit_url}}.")
    utils::browseURL(edit_url)
  }

  invisible()
}

merge_branch <- function(other_branch) {
  if (fledge_chatty()) cli_alert("Merging release branch.")
  if (fledge_chatty()) {
    cli_alert_info("If this fails, resolve the conflict manually and push.")
  }

  # https://github.com/r-lib/gert/issues/198
  stopifnot(system2("git", c("merge", "--no-ff", "--no-edit", "--commit", other_branch)) == 0)

  # FIXME add the conflict resolution
}

check_post_release <- function() {
  check_only_modified(character())
  check_cran_branch("post_release()")

  # Check that this and the main branch are in sync
  # FIXME add the conflict resolution
  gert::git_fetch(get_remote_name())
  ab_this <- gert::git_ahead_behind()
  if (ab_this[["behind"]] != 0) {
    cli::cli_abort(c(
      "Local release branch behind by {ab_this[['behind']]} commit{?s}."
    ))
  }
  if (ab_this[["ahead"]] != 0) {
    ncommit <- ab_this[['ahead']]
    cli::cli_abort(c(
      "Local release branch ahead by {ncommit} commit{?s}."
    ))
  }
  main_branch <- get_main_branch()
  remote_name <- get_remote_name(main_branch)
  remote_main <- paste0(remote_name, "/", main_branch)
  ab_main <- gert::git_ahead_behind(remote_main, main_branch)
  if (ab_main[["behind"]] != 0) {
    ncommit <- ab_main[['behind']]
    cli::cli_abort(c(
      "Local main branch behind by {ncommit} commit{?s}."
    ))
  }
  if (ab_main[["ahead"]] != 0) {
    ncommit <- ab_main[["ahead"]]
    cli::cli_abort(c(
      "Local main branch ahead by {ncommit} commit{?s}."
    ))
  }

  if (fledge_chatty()) {
    cli_alert("Checking presence and scope of {.var GITHUB_PAT}.")
  }

  # Need PAT for creating GitHub release
  check_gh_pat("repo")

  if (!no_change()) {
    cli_abort(c(
      "The main branch contains newsworthy commits.",
      i = "Run {.run fledge::bump_version()} on the main branch."
    ))
  }

  invisible()
}

merge_main_into_post_release <- function() {
  main_branch <- get_main_branch()

  if (gert::git_ahead_behind(main_branch)$behind != 0) {
    if (system2("git", c("merge", "--no-ff", "--no-commit", main_branch)) != 0) {
      cli_abort(c(
        "Merging the main branch into the release branch failed.",
        i = "Resolve the conflict manually and push."
      ))
    }

    stopifnot(system2("git", c("merge", "--abort")) == 0)
  }

  invisible()
}

check_gitignore <- function(files) {
  is_ignored <- map_lgl(files, is_ignored)

  if (any(is_ignored)) {
    files_ignored <- files[is_ignored]
    cli::cli_alert_warning("The following files are listed in {.file .gitignore}:")
    cli::cli_ul("{files_ignored}")
    cli::cli_text("Certain {.pkg fledge} automation steps might fail due to this.")
    cli::cli_abort('Remove {glue_collapse(files_ignored, ", ")} from .gitignore.')
  }
}

is_ignored <- function(path) {
  system2("git", c("check-ignore", "-q", path), stdout = FALSE) != 1
}

create_pull_request <- function(release_branch, main_branch, remote_name, force) {
  if (nzchar(Sys.getenv("FLEDGE_TEST_NOGH"))) {
    return(invisible())
  }

  # FIXME: Use gh() to determine if we need to create the pull request
  create <- TRUE

  if (create) {
    info <- github_info(remote = remote_name)
    ## create PR ----
    template_path <- system.file("templates", "pr.md", package = "fledge")
    template <- whisker::whisker.render(
      readLines(template_path),
      list(cransplainer = get_cransplainer())
    )
    body <- glue_collapse(template, sep = "\n")

    pr <- gh(
      "POST /repos/:owner/:repo/pulls",
      owner = info$owner$login,
      repo = info$name,
      title = cran_release_pr_title(
        strsplit(gert::git_branch(), "cran-")[[1]][2]
      ),
      head = release_branch,
      base = main_branch,
      maintainer_can_modify = TRUE,
      body = body
    )

    ## ensure that label exists ----
    labels <- gh(
      "GET /repos/:owner/:repo/labels",
      owner = info$owner$login,
      repo = info$name
    )
    label_names <- purrr::map_chr(labels, "name")
    cran_release_label <- label_names[grepl("^cran release", tolower(label_names))]
    no_cran_release_label <- (length(cran_release_label) == 0)
    if (no_cran_release_label) {
      cran_release_label <- "CRAN release :station:"
      gh(
        "POST /repos/:owner/:repo/labels",
        owner = info[["owner"]][["login"]],
        repo = info[["name"]],
        color = "d3d3d3",
        name = cran_release_label
      )
    }

    ## add label to PR ----
    gh(
      "PATCH /repos/:owner/:repo/issues/:issue_number",
      owner = info[["owner"]][["login"]],
      repo = info[["name"]],
      issue_number = pr[["number"]],
      labels = as.list(cran_release_label)
    )
  }

  utils::browseURL(pr[["html_url"]])
}

# FIXME: Align with new-style release
release_after_cran_built_binaries <- function() {
  pkg <- read_package()

  last_release_version <- get_last_release_version()

  if (length(last_release_version) == 0) {
    if (fledge_chatty()) {
      cli_alert_info("No previous release found.")
    }
    return(invisible())
  }

  ppm_packages <- utils::available.packages(repos = "https://packagemanager.posit.co/cran/latest")

  if (!(pkg %in% rownames(ppm_packages))) {
    if (fledge_chatty()) {
      cli_alert_info("Package not found on PPM.")
    }
    return(invisible())
  }

  ppm_version <- ppm_packages[pkg, "Version"]

  if (ppm_version == last_release_version) {
    if (fledge_chatty()) {
      cli_alert_info("PPM version matches the most recent version, releasing.")
    }
    post_release()
    return(invisible(TRUE))
  } else {
    if (fledge_chatty()) {
      cli_alert_info("PPM version {.val {ppm_version}} don't match the most recent version {.val {last_release_version}}.")
    }
    return(invisible(FALSE))
  }
}

get_last_release_version <- function(fledgling = NULL) {
  if (is.null(fledgling)) {
    fledgling <- read_fledgling()
  }

  is_release <- which(version_is_release(fledgling$news$version))

  if (length(is_release) == 0) {
    return(NULL)
  }

  fledgling$news$version[[is_release[[1]]]]
}

version_is_release <- function(x) {
  grepl("^[0-9]+[.][0-9]+[.][0-9]+(?:[.-][0-9]{1,3})?$", x)
}

cran_release_pr_title <- function(version) {
  if (is_dev_version(version)) {
    paste0("fledge: CRAN pre-release v", version)
  } else {
    paste0("fledge: CRAN release v", version)
  }
}

extract_version_pr <- function(title) {
  matches <- regexpr("(?<=v)[0-9]+[.][0-9]+[.][0-9]+([.][0-9]+)?$", title, perl = TRUE)
  regmatches(title, matches)
}

no_change <- function(ref) {
  # Only review meaningful comments
  news <- collect_news(default_commit_range(ref = ref), no_change_message = NA_character_)
  NROW(news) == 0
}
