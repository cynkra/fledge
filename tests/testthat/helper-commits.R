touch <- function(file, bullet = TRUE) {
  writeLines(character(), file)

  fast_git_add(file)
  gert::git_commit(message = paste0(if (bullet) "- ", file))
  invisible(gert::git_log(max = 1)$commit)
}

create_repo <- function(repo) {
  unlink(repo, recursive = TRUE, force = TRUE)

  tryCatch(
    gert::git_init(repo),
    error = function(e) {
      skip("Can't init repository")
    }
  )

  withr::local_dir(repo)
  system("git branch -m main") # No equivalent gert command

  gert::git_config_set("user.name", "Test")
  gert::git_config_set("user.email", "my@test.user")

  touch(".gitignore", bullet = FALSE)

  main <- gert::git_branch()

  gert::git_branch_create("b1", checkout = FALSE)

  gert::git_branch_checkout(main)

  a <- touch("a")
  b <- touch("b")

  gert::git_branch_checkout("b1")

  c <- touch("c")
  d <- touch("d")

  gert::git_branch_checkout(main)

  suppressMessages(gert::git_merge("b1", commit = FALSE))
  gert::git_commit(message = "- merge")

  e <- gert::git_log(max = 1)$commit

  tibble::lst(repo, a, b, c, d, e)
}
