test_that("tag_version() works", {
  with_demo_project({
    use_r("bla")
    gert::git_add("R/bla.R")
    gert::git_commit("* Add cool bla.")
    expect_snapshot(tag_version())
    expect_snapshot(get_last_tag()[, c("name", "ref")])
    expect_snapshot_error(tag_version())
    expect_snapshot(tag_version(force = TRUE))
    expect_snapshot(get_last_tag()[, c("name", "ref")])
  })

})
