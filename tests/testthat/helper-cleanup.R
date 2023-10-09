# to use when you run a test interactively
# and have changed the local directory
# and local usethis project

back_to_start <- function() {
  current_dev_project <- rstudioapi::getActiveProject()
  setwd(current_dev_project)
  usethis::proj_set(current_dev_project)
}

clean_submission_messages <- function(x) {
  x <- x[!grepl("pdflatex not found", x)]
  x[startsWith(x, "* checking for file")] <- "* checking for file DESCRIPTION"
  x[startsWith(x, "* building")] <- "* building 'tea_0.0.1.tar.gz'"
  x[startsWith(x, "i Submitting file:")] <- "i Submitting file: 'tea_0.0.1.tar.gz'"
  x[startsWith(x, "i File size:")] <- 'i File size: "some hundreds of bytes"'

  x
}
