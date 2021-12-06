test_that("tag_version() works", {
  with_demo_project(quiet = TRUE, {
    use_r("bla")
    gert::git_add("R/bla.R")
    gert::git_commit("* Add cool bla.")
    expect_snapshot(tag_version())
    expect_snapshot(get_last_tag()[, c("name", "ref")])

    # Attempting tagging again without any new commit
    shut_up_fledge(expect_silent(tag_version()))

    # Attempting tagging again
    # with a new commit but same version
    use_r("pof")
    gert::git_add("R/pof.R")
    gert::git_commit("* Add cool pof.")
    expect_snapshot_error(tag_version(force = FALSE))

    # Same, but forcing
    expect_snapshot(tag_version(force = TRUE))
    expect_snapshot(get_last_tag()[, c("name", "ref")])

  })

})
