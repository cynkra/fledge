check_main_branch <- function(reason) {
  if (get_branch_name() != get_main_branch()) {
    cli::cli_abort(
      c(
        x = "Must be on the main branch ({.val {get_main_branch()}}) for running {.code {reason}}.",
        i = "Currently on branch {.val {get_branch_name()}}."
      )
    )
  }
}

# git_add() is very slow: https://github.com/r-lib/gert/issues/242
fast_git_add <- function(path) {
  stopifnot(system2("git", c("add", "--", path)) == 0)
}
