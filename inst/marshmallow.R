pkgload::load_all()
# not opening anything ----
rlang::local_options(rlang_interactive = FALSE)

# initial state ----
local_demo_project(quiet = TRUE)
tempdir_remote <- withr::local_tempdir(pattern = "remote")
create_remote(tempdir_remote)

fs::dir_tree()
desc::desc()
gert::git_remote_list()

# some edits ----
use_r("bla", open = FALSE)
gert::git_add("R/bla.R")
gert::git_commit("* Add cool bla.")
bump_version()

# init release ----
withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
init_release()


# back to fledge directory and project ----
back_to_start()

