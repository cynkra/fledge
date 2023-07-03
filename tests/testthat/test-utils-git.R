test_that("check_main_branch() works", {
  local_options(repos = NULL) # because of usethis::use_news_md() -> available.packages()
  local_demo_project(quiet = TRUE)
  gert::git_branch_create("blop")
  expect_snapshot(check_main_branch("this piece of code"), error = TRUE)
})
