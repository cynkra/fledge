#' Create example repo for fledge demos
#'
#' @param open Whether to open the new project.
#' @param pkg Package name.
#' @param name Name for DESCRIPTION and git.
#' @param email Email for DESCRIPTION and git.
#' @param date String of time for DESCRIPTION and git.
#' @param tempdir Directory within which to create the mock package folder.
#' @param news If TRUE, create a NEWS.md file.
#'
#' @return
#' @export
#'
create_fledge_mock_repo <- function(open = rlang::is_interactive(),
                               pkg = "tea",
                               name = "Kirill M\u00fcller",
                               email = "mail@example.com",
                               date = "2020-12-12",
                               tempdir = withr::local_tempdir(
                                 pattern = "fledge",
                                 .local_envir = parent.frame(n = 2)
                                 ),
                               news = FALSE
                              ) {

  withr::local_options(usethis.quiet = TRUE)

  set_usethis_desc(name = name, email = email, date = date)
  pkg <- usethis::create_package(
    file.path(tempdir, pkg),
    fields = list(Date = as.Date(date)),
    open = open
  )

  withr::local_dir(new = pkg)
  gert::git_init()
  gert::git_config_set("user.name", name)
  gert::git_config_set("user.email", email)
  gert::git_add(".")
  gert::git_commit("First commit")
  if ("master" %in% gert::git_branch_list()$name) {
    gert::git_branch_create("main")
    gert::git_branch_delete("master")
  }

  if (news) {
    usethis::with_project(
      path = pkg, {
        rlang::with_interactive({usethis::use_news_md()}, value = FALSE)
        gert::git_add("NEWS.md")
        gert::git_commit("Add NEWS.md to track changes.")
      }
    )
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
