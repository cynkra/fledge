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
