test_that("update_news() works when news file absent", {
  withr::local_options("fledge.quiet" = TRUE)
  local_demo_project(news = FALSE, quiet = TRUE)
  expect_no_error(update_news(which = "patch"))
})

test_that("update_news() works when news file still empty", {
  local_demo_project(news = FALSE, quiet = TRUE)
  file.create("NEWS.md")
  expect_no_error(update_news(which = "patch"))
  expect_snapshot(read_fledgling())
})

test_that("normalize_news() works", {
  repo <- withr::local_tempdir()
  withr::local_dir(repo)
  usethis::with_project(
    repo,
    usethis::use_description(fields = list(Package = "fledge")),
    force = TRUE
  )
  df <- tibble::tribble(
    ~description,
    "fledge has better support.",
    "fledge's interface was improved!",
    "fledged bird?",
    "`update_news()` capitalize items",
    "2 new functions for bla",
    "harvest PR title"
  )
  expect_snapshot_tibble(normalize_news(df))
})
