% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api-commit-version.R
\name{commit_version}
\alias{commit_version}
\title{Commits NEWS.md and DESCRIPTION to Git}
\usage{
commit_version()
}
\value{
Invisibly: \code{TRUE} if a previous commit for that version has been
amended, \code{FALSE} if not.
}
\description{
Commits changes to \code{NEWS.md} and \code{DESCRIPTION}, amending a previous commit
created by \pkg{fledge} if necessary.
}
\examples{
# Create mock package in a temporary directory.
# Set open to TRUE if you want to play in the mock package.
with_demo_project({
  # Use functions as if inside the newly created package project.
  # (Or go and actually run code inside the newly created package project!)
  # Add a new R file.
  usethis::use_r("cool-function", open = FALSE)
  # Pretend we added useful code inside it.
  # Track the new R file with Git.
  gert::git_add("R/cool-function.R")
  gert::git_commit("- Add cool function.")
  # Bump version with fledge.
  fledge::bump_version()
  desc::desc_add_author(given = "Jane", family = "Doe", role = "ctb")
  fledge::commit_version()
})
}
