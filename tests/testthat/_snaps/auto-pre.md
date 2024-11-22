# plan_release() pre-flight checks

    Code
      plan_release()
    Condition
      Error in `check_only_modified()`:
      x Found untracked/unstaged/staged file in the git index: 'R/'.
      i Please commit or discard it and try again.

# plan_release() works

    Code
      plan_release("next")
    Message
      > Digesting messages from 2 commits.
    Output
      +------------------+
      |                  |
      |   plan_release   |
      |                  |
      +------------------+
    Message
      
      -- 1. Creating a release branch and getting ready ------------------------------
      > Creating branch cran-0.0.1.
      > Switching to branch cran-0.0.1.
      > Committing changes.
      
      -- 2. Opening Pull Request for release branch ----------------------------------
      > Pushing cran-0.0.1 to remote origin.
      > Opening draft pull request with contents from 'cran-comments.md'.
      
      -- 3. User Action Items --------------------------------------------------------
      * Run `devtools::check_win_devel()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Run `fledge::release()`.

