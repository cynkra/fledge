test_that("tag_version() works", {
  with_demo_project(quiet = TRUE, {
    use_r("bla")
    gert::git_add("R/bla.R")
    gert::git_commit("* Add cool bla.")
    expect_snapshot(variant = snapshot_variant("testthat"), {
      tag_version()
      get_last_tag()[, c("name", "ref")]
    })

    # Attempting tagging again without any new commit
    expect_silent(shut_up_fledge(tag_version()))

    # Attempting tagging again
    # with a new commit but same version
    use_r("pof")
    gert::git_add("R/pof.R")
    gert::git_commit("* Add cool pof.")
    expect_snapshot_error(shut_up_fledge(tag_version(force = FALSE)))

    # Same, but forcing
    expect_snapshot(variant = snapshot_variant("testthat"), {
      tag_version(force = TRUE)
      get_last_tag()[, c("name", "ref")]
    })
  })
})
