create_remote <- function(tempdir_remote) {

  gert::git_init(tempdir_remote, bare = TRUE)

  current_remotes <- gert::git_remote_list()
  origin_exists <- "origin" %in% current_remotes[["name"]]
  if (origin_exists) {
    cli::cli_abort(c(
      "Found an origin, we're in {getwd()}, was this expected?",
      i = "Did you forget to set up a local toy repo?"
    ))
  }

  gert::git_remote_add(tempdir_remote, name = "origin")
  gert::git_push(remote = "origin")

  tempdir_remote
}

show_tags <- function(remote_url) {

  tempdir_remote <- withr::local_tempdir(pattern = "remote")

  withr::with_dir(tempdir_remote, {
    gert::git_clone(remote_url, path = "remote")
    gert::git_tag_list(repo = "remote")[, c("name", "ref")]
  })
}

show_files <- function(remote_url) {
  if (!gert::user_is_configured()) {
    usethis::use_git_config(
      user.name = "Jane Doe",
      user.email = "jane@example.com"
    )
  }

  git_config <- gert::git_config_global()
  if (!"init.defaultbranch" %in% git_config$name) {
    gert::git_config_global_set("init.defaultbranch", "main")
  }

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  withr::with_dir(tempdir_remote, {
    gert::git_clone(remote_url, path = "remote")
    suppressMessages(gert::git_branch_checkout("main", force = TRUE, repo = "remote"))
    fs::dir_ls("remote", recurse = TRUE)
  })
}
