# release abandon

    Code
      plan_release()
    Message
      > Pulling main.
      Resetting main to origin/main
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

---

    Code
      plan_release(force = TRUE)
    Condition
      Error in `check_main_branch()`:
      x Must be on the main branch ("main") for running `plan_release()`.
      i Currently on branch "cran-0.0.0.9900".

---

    Code
      plan_release(force = FALSE)
    Message
      > Pulling main.
      Resetting main to origin/main
      > Digesting messages from 1 commits.
    Condition
      Error in `check_release_branch()`:
      x The branch "cran-0.0.0.9900" already exists.
      i Do you need `plan_release(force = TRUE)`?

---

    Code
      plan_release(force = TRUE)
    Message
      > Pulling main.
      Resetting main to origin/main
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

