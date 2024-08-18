#' @rdname bump_version
#' @usage NULL
bump_version_impl <- function(fledgeling,
                              which,
                              no_change_behavior,
                              check_default_branch = TRUE,
                              edit = TRUE,
                              no_change_message = NULL) {
  #' @description
  #' 1. Verify that the current branch is the main branch
  #'    if `check_default_branch = TRUE` (the default).
  if (check_default_branch) {
    check_main_branch("bump_version()")
  }
  #' 1. Check if there were changes since the last version.
  if (no_change()) {
    if (no_change_behavior == "fail") {
      cli::cli_abort(
        message = c(
          x = "No change since last version.",
          i = 'Use {.code no_change_behavior = "bump"} to force a version bump, or
          {.code no_change_behavior = "noop"} to do nothing.'
        )
      )
    }
    if (no_change_behavior == "noop") {
      if (fledge_chatty()) cli::cli_alert_info("No change since last version.")
      return(invisible(fledgeling))
    }
  }
  #' 1. [update_news()], using the `which` argument
  out <- update_news_impl(
    default_commit_range(),
    which = which,
    fledgeling = fledgeling,
    no_change_message = no_change_message
  )
  #' 1. Depending on the `which` argument:
  if (which == "dev") {
    write_fledgling(out)
    #'     - If `"dev"`, [finalize_version()] with `push = FALSE`
    finalize_version_impl(push = FALSE, suggest_finalize = edit)
  } else {
    write_fledgling(out)
    #'     - Otherwise, [commit_version()].
    commit_version()

    if (fledge_chatty()) {
      cli_h2("Preparing package for CRAN release")
    }

    if (edit) {
      edit_news()

      if (fledge_chatty()) {
        cli_ul("Convert the change log in {.file {news_path()}} to release notes.")
      }
    }
  }

  invisible(out)
}

bump_version_to_dev_with_force <- function(force, which) {
  update_news(which = which)

  force <- commit_version() || force
  tag <- tag_version(force)
  push_head()
  push_tag(tag)
}

check_cran_branch <- function(reason) {
  if (!grepl("^cran-", get_branch_name())) {
    cli::cli_abort(
      c(
        x = "Must be on the a release branch that starts with {.val cran-} for running {.code {reason}}.",
        i = "Currently on branch {.val {get_branch_name()}}."
      )
    )
  }
}

get_main_branch <- function(repo = getwd()) {
  remote <- "origin"
  remote_list <- gert::git_remote_list(repo)
  if (remote %in% remote_list$name) {
    remote_main <- get_main_branch_remote(remote, repo)
    if (length(remote_main)) {
      return(remote_main)
    }
  }

  get_main_branch_config(repo)
}

get_main_branch_remote <- function(remote, repo) {
  remotes <- gert::git_remote_ls(repo = repo, verbose = FALSE, remote = remote)
  basename(as.character(remotes$symref[remotes$ref == "HEAD"]))
}

get_main_branch_config <- function(repo) {
  config <- gert::git_config(repo)
  init <- config[config$name == "init.defaultbranch", ]

  if ("local" %in% init$level) {
    return(init[init$level == "local", ]$value)
  } else {
    return(init[init$level == "global", ]$value)
  }
}

no_change <- function(ref = "HEAD") {
  # At most, one commit from the latest bump_version() run
  # FIXME: Should be <= 0?
  nrow(default_commit_range(ref)) <= 1
}
