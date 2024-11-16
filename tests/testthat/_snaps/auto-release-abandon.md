# release abandon

    Code
      init_release()
    Output
      +-----------------+
      |                 |
      |   pre-release   |
      |                 |
      +-----------------+
    Message
      
      -- 1. Creating a release branch and getting ready ------------------------------
      > Creating branch cran-0.0.1.
      > Switching to branch cran-0.0.1.
      > Committing changes.
      
      -- 2. User Action Items --------------------------------------------------------
      * Run `devtools::check_win_devel()`.
      * Run `rhub::check_for_cran()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Run `fledge::pre_release()`.
    Output
      NULL

---

    Code
      init_release(force = TRUE)
    Condition
      Error in `check_main_branch()`:
      x Must be on the main branch ("main") for running `init_release()`.
      i Currently on branch "cran-0.0.1".

---

    Code
      init_release(force = FALSE)
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
      
      -- 1. Creating a release branch and getting ready ------------------------------
      > Creating branch cran-0.0.1.
      > Switching to branch cran-0.0.1.
      > Committing changes.
      
      -- 2. User Action Items --------------------------------------------------------
      * Run `devtools::check_win_devel()`.
      * Run `rhub::check_for_cran()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Run `fledge::pre_release()`.
    Output
      NULL

