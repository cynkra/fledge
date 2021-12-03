test_that("tag_version() works", {
  with_demo_project(quiet = TRUE, {
    use_r("bla")
    gert::git_add("R/bla.R")
    gert::git_commit("* Add cool bla.")
    expect_snapshot(tag_version())
    expect_snapshot(get_last_tag()[, c("name", "ref")])

    shut_up_fledge(expect_error(tag_version(force = FALSE)))

    expect_snapshot(tag_version(force = TRUE))
    expect_snapshot(get_last_tag()[, c("name", "ref")])

    use_r("pof")
    gert::git_add("R/pof.R")
    gert::git_commit("* Add cool pof.")
    expect_snapshot_error(tag_version(force = FALSE))
  })

})
