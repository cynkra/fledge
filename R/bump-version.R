#' @rdname bump_version
#' @usage NULL
bump_version_impl <- function(which,
                              no_change_behavior,
                              fledgeling = NULL,
                              edit = TRUE,
                              no_change_message = NULL) {
  #' @description
  #' 1. Verify that the current branch is the main branch.
  check_main_branch()
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
      cli::cli_alert_info("No change since last version.")
      return(invisible(FALSE))
    }
  }
  #' 1. [update_news()], using the `which` argument
  update_news_impl(
    default_commit_range(),
    which = which,
    fledgeling = fledgeling,
    no_change_message = no_change_message
  )
  #' 1. Depending on the `which` argument:
  if (which == "dev") {
    #'     - If `"dev"`, [finalize_version()] with `push = FALSE`
    finalize_version_impl(push = FALSE, suggest_finalize = edit)
  } else {
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

  invisible(TRUE)
}

bump_version_to_dev_with_force <- function(force, which) {
  update_news(which = which)

  force <- commit_version() || force
  tag <- tag_version(force)
  push_tag(tag)
  push_head()
}

check_main_branch <- function() {
  if (gert::git_branch() != get_main_branch()) {
    cli::cli_abort(
      c(
        x = "Must be on the main branch ({.val {get_main_branch()}}) for running fledge functions.",
        i = "Currently on branch {.val {gert::git_branch()}}."
      )
    )
  }
}

get_main_branch <- function() {
  remote <- "origin"
  if (remote %in% gert::git_remote_list()$name) {
    remote_main <- get_main_branch_remote(remote)
    if (length(remote_main)) {
      return(remote_main)
    }
  }

  get_main_branch_config()
}

get_main_branch_remote <- function(remote) {
  remotes <- gert::git_remote_ls(verbose = FALSE, remote = remote)
  basename(as.character(remotes$symref[remotes$ref == "HEAD"]))
}

get_main_branch_config <- function() {
  config <- gert::git_config()
  init <- config[config$name == "init.defaultbranch", ]
  local <- init[init$level == "local", ]

  if (length(local)) {
    return(local$value)
  }

  global <- init[init$level == "global"]
  return(global$value)
}

no_change <- function() {
  # At most, one commit from the latest bump_version() run
  nrow(default_commit_range()) <= 1
}
