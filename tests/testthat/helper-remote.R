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
