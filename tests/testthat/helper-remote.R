create_remote <- function() {
  # assuming this is a temporary directory :-)
  parent_dir <- dirname(getwd())
  dir.create(file.path(parent_dir, "remote"))
  gert::git_init(file.path(parent_dir, "remote"), bare = TRUE)
  remote_url <- file.path(parent_dir, "remote")
  gert::git_remote_add(remote_url, name = "origin")
  gert::git_push(remote = "origin")
  remote_url
}

show_tags <- function(remote_url) {
  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  withr::with_dir(tempdir_remote, {
    gert::git_clone(remote_url)
    gert::git_tag_list(repo = "remote")[,c("name", "ref")]
  })
}
show_files <- function(remote_url) {
  if (!gert::user_is_configured()) {
    usethis::use_git_config(user.name = "Jane Doe", user.email = "jane@example.com")
  }

  git_config <- gert::git_config_global()
  if (! "init.defaultbranch" %in% git_config$name) {
    gert::git_config_global_set("init.defaultbranch", "main")
  }

  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  withr::with_dir(tempdir_remote, {
    gert::git_clone(remote_url)
    print(gert::git_status(repo = "remote"))
    print(gert::git_info(repo = "remote"))
    fs::dir_ls("remote", recurse = TRUE)
  })
}
