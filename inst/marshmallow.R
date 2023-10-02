load_all()
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
init_release()
gert::git_branch()
gert::git_branch_list()
desc::desc_get_version()
gert::git_status()
gert::git_diff()$patch[[1]] |> cat()
gert::git_diff()$patch[[2]] |> cat()
gert::git_diff()$patch[[3]] |> cat()

# prep release ----
withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
pre_release()

# release ----

# back to fledge directory and project ----
back_to_start()

