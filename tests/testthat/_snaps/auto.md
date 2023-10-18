# guess_next_impl() works

    Code
      guess_next_impl("1.2.3.9007")
    Output
      [1] "patch"
    Code
      guess_next_impl("1.2.99.9008")
    Output
      [1] "minor"
    Code
      guess_next_impl("1.99.99.9009")
    Output
      [1] "major"

# create_release_branch() works

    Code
      create_release_branch(fledgeling, ref = "bla")
    Message
      > Creating branch cran-0.0.0.9000.
    Output
      [1] "cran-0.0.0.9000"

---

    Code
      create_release_branch(fledgeling, ref = "blop", force = TRUE)
    Message
      > Creating branch cran-0.0.0.9000.
    Condition
      Error in `gert::git_branch_create()`:
      ! Failed to find git reference 'blop'

# init_release() works

    Code
      bump_version()
    Message
      > Digesting messages from 2 commits.
      i Internal changes only.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.0.9001.
      > Added header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
      ! Call `fledge::finalize_version()`.

---

    Code
      init_release()
    Output
      +-----------------+
      |                 |
      |   pre-release   |
      |                 |
      +-----------------+
    Message
      
      -- 1. Wrapping up development --------------------------------------------------
      i No change since last version.
      > Digesting messages from 1 commits.
      i Initiated release of version 0.0.1 from version 0.0.0.9001
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.0.9002.
      > Added header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9002 with tag message derived from 'NEWS.md'.
      
      -- 2. Creating a release branch and getting ready ------------------------------
      > Creating branch cran-0.0.1.
      > Switching to branch cran-0.0.1.
      
      -- 3. User Action Items --------------------------------------------------------
      * Run `devtools::check_win_devel()`.
      * Run `rhub::check_for_cran()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Call `pre_release()`.
    Output
      NULL

# init_release() -- force

    Code
      bump_version()
    Message
      > Digesting messages from 2 commits.
      i Internal changes only.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.0.9001.
      > Added header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
      ! Call `fledge::finalize_version()`.

---

    Code
      init_release()
    Condition
      Error in `check_release_branch()`:
      x The branch "cran-0.0.1" already exists.
      i Do you need `init_release(force = TRUE)`?

---

    Code
      init_release(force = TRUE)
    Output
      +-----------------+
      |                 |
      |   pre-release   |
      |                 |
      +-----------------+
    Message
      
      -- 1. Wrapping up development --------------------------------------------------
      i No change since last version.
      > Digesting messages from 1 commits.
      i Initiated release of version 0.0.1 from version 0.0.0.9001
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.0.9002.
      > Added header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9002 with tag message derived from 'NEWS.md'.
      
      -- 2. Creating a release branch and getting ready ------------------------------
      > Creating branch cran-0.0.1.
      > Switching to branch cran-0.0.1.
      
      -- 3. User Action Items --------------------------------------------------------
      * Run `devtools::check_win_devel()`.
      * Run `rhub::check_for_cran()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Call `pre_release()`.
    Output
      NULL

