# create_release_branch() works

    Code
      create_release_branch("0.0.1", ref = "bla")
    Message
      > Creating branch cran-0.0.1.
    Output
      [1] "cran-0.0.1"

---

    Code
      create_release_branch("0.0.1", ref = "blop", force = TRUE)
    Message
      > Creating branch cran-0.0.1.
    Condition
      Error in `gert::git_branch_create()`:
      ! Failed to find git reference 'blop'

# plan_release() -- force

    Code
      plan_release()
    Message
      > Digesting messages from 1 commits.
    Condition
      Error in `check_release_branch()`:
      x The branch "cran-0.0.0.9900" already exists.
      i Do you need `plan_release(force = TRUE)`?

---

    Code
      plan_release(force = TRUE)
    Message
      > Digesting messages from 1 commits.
    Output
      +------------------+
      |                  |
      |   plan_release   |
      |                  |
      +------------------+
    Message
      
      -- 1. Creating a release branch and getting ready ------------------------------
      > Creating branch cran-0.0.0.9900.
      > Switching to branch cran-0.0.0.9900.
      > Committing changes.
      
      -- 2. Opening Pull Request for release branch ----------------------------------
      > Pushing cran-0.0.0.9900 to remote origin.
      > Opening pull request with instructions.
      
      -- 3. User Action Items --------------------------------------------------------
      * Run `devtools::check_win_devel()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Run `fledge::finalize_version(push = TRUE)`.
      * Merge the PR.
      * Restart with `fledge::plan_release("next")`.

