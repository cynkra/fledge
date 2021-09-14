#' Create example repo for fledge demos
#'
#' @param open Whether to open the new project.
#' @param name Package name.
#' @param maintainer Name for DESCRIPTION and git.
#' @param email Email for DESCRIPTION and git.
#' @param date String of time for DESCRIPTION and git.
#' @param dir Directory within which to create the mock package folder.
#' @param news If TRUE, create a NEWS.md file.
#'
#' @return The path to the newly created mock package.
#' @export
#'
create_demo_project <- function(open = rlang::is_interactive(),
                                name = "tea",
                                maintainer = whoami::fullname(fallback = "Kirill M\u00fcller"),
                                email = whoami::email_address(fallback = "mail@example.com"),
                                date = "2020-12-12",
                                dir = file.path(tempdir(check = TRUE), "fledge"),
                                news = FALSE
                              ) {

  if (!dir.exists(dir)) dir.create(dir)

  withr::local_options(usethis.quiet = TRUE)

  set_usethis_desc(maintainer = maintainer, email = email, date = date)
  pkg <- usethis::create_package(
    file.path(dir, name),
    fields = list(Date = as.Date(date)),
    open = open
  )

  withr::local_dir(new = pkg)
  gert::git_init()
  gert::git_config_set("user.name", maintainer)
  gert::git_config_set("user.email", email)
  gert::git_add(".")
  gert::git_commit("First commit")
  current_branch <- gert::git_branch()
  if (current_branch != "main") {
    gert::git_branch_move(current_branch, "main")
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


set_usethis_desc <- function(maintainer, email, date) {
  withr::local_options(
    usethis.full_name = maintainer,
    usethis.protocol  = "ssh",
    usethis.description = list(
      "Authors@R" = utils::person(
        maintainer,
        email = email,
        role = c("aut", "cre"),
      ),
      Version = "0.0.0.9000",
      context = "fledge-example"
    ),
    .local_envir = parent.frame(n = 2)
  )
}
