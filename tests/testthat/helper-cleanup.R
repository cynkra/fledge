# to use when you run a test interactively
# and have changed the local directory
# and local usethis project

back_to_start <- function() {
  current_dev_project <- rstudioapi::getActiveProject()
  setwd(current_dev_project)
  usethis::proj_set(current_dev_project)
}
