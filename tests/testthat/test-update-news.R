test_that("update_news() works when news file absent", {
  withr::local_options("fledge.quiet" = TRUE)
  withr::local_options("usethis.quiet" = TRUE)
  local_demo_project(news = FALSE, quiet = TRUE)
  expect_no_error(update_news(which = "patch"))
})

test_that("update_news() works when news file still empty", {
  withr::local_options("usethis.quiet" = TRUE)
  withr::local_envvar("FLEDGE_DATE" = "2023-01-23")

  local_demo_project(news = FALSE, quiet = TRUE)
  file.create("NEWS.md")
  expect_no_error(update_news(which = "patch"))
  expect_snapshot(read_fledgling())
})

test_that("normalize_news() works", {
  withr::local_options("usethis.quiet" = TRUE)
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

test_that("regroup_news() works", {
  withr::local_options("usethis.quiet" = TRUE)
  news_list1 <- list(
    Uncategorized = c("- blop", "- etc"),
    Documentation = c("- stuff", "- other")
  )
  news_list2 <- list(
    Features = c("- feat1", "- feat2"),
    `Custom type` = "cool right",
    Uncategorized = c("- pof", "- ok"),
    Documentation = "- again"
  )
  combined <- c(news_list1, news_list2)
  regrouped <- regroup_news(combined)

  expect_equal(
    names(regrouped),
    c("Custom type", "Features", "Documentation", "Uncategorized")
  )
  expect_length(regrouped[["Documentation"]], 3)
  expect_length(regrouped[["Uncategorized"]], 4)
})

test_that("Can update dev version news item", {
  withr::local_options("usethis.quiet" = TRUE)
  repo <- withr::local_tempdir(pattern = "devpkg")

  create_cc_repo(
    repo,
    commit_messages = "feat: new stuff"
  )

  usethis::with_project(
    repo,
    {
      usethis::use_description(
        fields = list(Package = "fledge", Version = "0.1.0")
      )
      usethis::use_news_md()
      usethis::use_dev_version()
    },
    force = TRUE
  )
  usethis::local_project(repo, force = TRUE, setwd = FALSE)
  withr::with_dir(repo, update_news())
  expect_snapshot_file(
    file.path(repo, "NEWS.md"),
    name = "dev-NEWS.md"
  )

  # regrouping!
  sort_of_commit("fix: horrible bug", repo = repo)
  sort_of_commit("feat: neat helper", repo = repo)
  withr::with_dir(repo, update_news())
  expect_snapshot_file(
    file.path(repo, "NEWS.md"),
    name = "dev-updated-NEWS.md"
  )
})
