#' @rdname bump_version
#' @usage NULL
bump_version_impl <- function(which) {
  #' @description
  #' 1. Verify that the current branch is the main branch.
  stopifnot(gert::git_branch() == get_main_branch())
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

    cli_h2("Preparing package for CRAN release")
    edit_news()
    cli_ul("Convert the changelog in {.file {news_path}} to release notes.")
  }

  cli_par()
  cli_end()
}

bump_version_to_dev_with_force <- function(force) {
  update_news()
  update_version()

  head <- get_head_branch()
  force <- commit_version() || force
  tag <- tag_version(force)
  push_tag(tag)
  push_head(head)
}

bump_version_to_dev_with_force <- function(force) {
  update_news()
  update_version()

  force <- commit_version() || force
  tag <- tag_version(force)
  push_tag(tag)
  push_head()
}

get_main_branch <- function() {
  remote <- "origin"
  if (remote %in% gert::git_remote_list()$name) {
    get_main_branch_remote(remote)
  } else {
    get_main_branch_config()
  }
}

get_main_branch_remote <- function(remote) {
  remotes <- gert::git_remote_ls(verbose = FALSE, remote = remote)
  basename(as.character(remotes$symref[remotes$ref == "HEAD"]))
}

get_main_branch_config <- function() {
  config <- gert::git_config()
  config$value[config$name == "init.defaultbranch"]
}
