pkgload::load_all()
# not opening anything ----
rlang::local_options(rlang_interactive = FALSE)

# initial state ----
# Avoid cleanup
project_dir <- tempfile(pattern = "fledge")
dir.create(project_dir)
local_demo_project(project_dir, quiet = TRUE)
# local_demo_project(quiet = TRUE)

term <- rstudioapi::terminalCreate()
rstudioapi::terminalSend(term, paste0("cd ", getwd(), "\n"))

# create remote ----
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
finalize_version(push = TRUE)

# init release ----
withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
plan_release()
gert::git_branch()
gert::git_branch_list(local = TRUE)
desc::desc_get_version()
gert::git_status()

# check boxes ----
cran_comments <- get_cran_comments_text()
writeLines(cran_comments)
cran_comments <- gsub("- \\[ \\]", "- \\[x\\]", cran_comments)
brio::write_lines(cran_comments, "cran-comments.md")

gert::git_branch_checkout("main")
system("git merge cran-0.0.0.9900 --no-ff -m 'fledge: Bump'")

# prep release ----
plan_release("patch")

# release ----
withr::local_envvar("FLEDGE_DONT_BOTHER_CRAN_THIS_IS_A_TEST" = "yes-a-test")
release()
gert::git_status()
fs::dir_tree()

# post release ----
withr::local_envvar("FLEDGE_TEST_NOGH" = "no-github-no-mocking-needed-yay")
post_release()

# back to fledge directory and project ----
back_to_start()

