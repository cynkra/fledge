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
gert::git_branch()
gert::git_branch_list()
desc::desc_get_version()
gert::git_status()
gert::git_diff()$patch[[1]] |> cat()
gert::git_diff()$patch[[2]] |> cat()
gert::git_diff()$patch[[3]] |> cat()

# prep release ----
pre_release()

# release ----
cran_comments <- get_cran_comments_text()
cran_comments <- gsub("- \\[ \\]", "- \\[x\\]", cran_comments)
brio::write_lines(cran_comments, "cran-comments.md")
gert::git_add("cran-comments.md")
gert::git_commit("this is how we check boxes")
withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
release()
gert::git_status()
fs::dir_tree()

# post release ----
withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
post_release()
# why conflict?
brio::write_lines(
  c(
  "#", "",
  "- Add cool bla.", "",
  "- Added a `NEWS.md` file to track changes to the package."
  ),
  "NEWS.md"
)
gert::git_add("NEWS.md")
gert::git_commit("Fix conflicts in changelog")
gert::git_push()

# back to fledge directory and project ----
back_to_start()

