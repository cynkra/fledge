#' Create example repo for fledge demos
#'
#' @param open Whether to open the new project.
#' @param pkg Package name.
#' @param name Name for DESCRIPTION and git.
#' @param email Email for DESCRIPTION and git.
#' @param date String of time for DESCRIPTION and git.
#'
#' @return
#' @export
#'
create_fledge_mock_repo <- function(open = rlang::is_interactive(),
                               pkg = "tea",
                               name = "Kirill Müller",
                               email = "mail@example.com",
                               date = "2020-12-12",
                               tempdir = withr::local_tempdir(
                                 pattern = "fledge",
                                 .local_envir = parent.frame(n = 2)
                              )
                              ) {

  withr::local_options(usethis.quiet = TRUE)

  set_usethis_desc(name = name, email = email, date = date)
  pkg <- usethis::create_package(
    file.path(tempdir, pkg),
    fields = list(Date = as.Date(date)),
    open = open
  )

  gert::git_init(path = pkg)
  gert::git_add(".", repo = pkg)
  gert::git_commit("First commit", repo = pkg)
  if ("master" %in% gert::git_branch_list(repo = pkg)$name) {
    gert::git_branch_create("main", repo = pkg)
    gert::git_branch_delete("master", repo = pkg)
  }

  return(pkg)
}


set_usethis_desc <- function(name, email, date) {
  withr::local_options(
    usethis.full_name = name,
    usethis.protocol  = "ssh",
    usethis.description = list(
      "Authors@R" = utils::person(
        name,
        email = email,
        role = c("aut", "cre"),
      ),
      Version = "0.0.0.9000",
      context = "fledge-example"
    ),
    .local_envir = parent.frame(n = 2)
  )
}

