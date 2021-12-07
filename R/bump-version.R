#' @rdname bump_version
#' @usage NULL
bump_version_impl <- function(which) {
  #' @description
  #' 1. Verify that the current branch is the main branch.
  if (gert::git_branch() != get_main_branch()) {
    rlang::abort(
      c(
        x = sprintf("Must be on the main branch (%s) for running fledge functions.", get_main_branch()),
        i = sprintf("Currently on branch %s.", gert::git_branch())
      )
    )
  }
  #' 1. [update_news()]
  update_news()
  #' 1. [update_version()], using the `which` argument
  update_version(which = which)
  #' 1. Depending on the `which` argument:
  if (which == "dev") {
    #'     - If `"dev"`, [finalize_version()] with `push = FALSE`
    finalize_version_impl(push = FALSE)
  } else {
    #'     - Otherwise, [commit_version()].
    commit_version()
    if (fledge_chatty()) {
      cli_alert_info("Preparing package for release (CRAN or otherwise).")
    }

    edit_news()

    if (fledge_chatty()) {
      cli_alert_warning("Convert the change log in {.file {news_path()}} to release notes.")
      cli_alert_warning("After CRAN release, call {.fun fledge::tag_version} and
           {.fun fledge::bump_version} to re-enter development mode")
    }
  }
}

get_main_branch <- function() {
  remote <- "origin"
  if (remote %in% gert::git_remote_list()$name) {
    remote_main <- get_main_branch_remote(remote)
    if (length(remote_main)) return(remote_main)
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
