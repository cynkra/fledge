# pre_release() pre-flight checks

    Code
      pre_release()
    Condition
      Error in `check_cran_branch()`:
      x Must be on the a release branch that starts with "cran-" for running `pre_release()`.
      i Currently on branch "main".

---

    Code
      pre_release()
    Condition
      Error in `check_only_modified()`:
      x Found untracked/unstaged/staged file in the git index: 'R/'.
      i Please commit or discard it and try again.

# pre_release() works

    Code
      pre_release()
    Message
      
      -- 1. Opening Pull Request for release branch ----------------------------------
      > Pushing cran-0.0.1 to remote origin.
      > Opening draft pull request with contents from 'cran-comments.md'.
      
      -- 2. User Action Items --------------------------------------------------------
      * Run `fledge::release()`.

