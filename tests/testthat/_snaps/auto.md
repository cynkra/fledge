# create_release_branch() works

    Code
      create_release_branch("0.0.1", ref = "blop", force = TRUE)
    Condition
      Error in `fledgeling$version`:
      ! $ operator is invalid for atomic vectors

# init_release() -- force

    Code
      init_release()
    Message
      i No change since last version.
    Condition
      Error in `check_release_branch()`:
      x The branch "cran-0.0.1" already exists.
      i Do you need `init_release(force = TRUE)`?

# pre_release() pre-flight checks

    Code
      pre_release()
    Condition
      Error in `check_cran_branch()`:
      x Must be on the a release branch that starts with "cran-" for running `pre_release()`.
      i Currently on branch "main".
      i Do you need to call `init_release()` first?

# release abandon

    Code
      init_release(force = TRUE)
    Message
      i No change since last version.
    Output
      +-----------------+
      |                 |
      |   pre-release   |
      |                 |
      +-----------------+
    Message
      
      -- 1. Wrapping up development --------------------------------------------------
      
      -- 2. Creating a release branch and getting ready ------------------------------
    Condition
      Error in `fledgeling$version`:
      ! $ operator is invalid for atomic vectors

---

    Code
      init_release(force = FALSE)
    Message
      i No change since last version.
    Output
      +-----------------+
      |                 |
      |   pre-release   |
      |                 |
      +-----------------+
    Message
      
      -- 1. Wrapping up development --------------------------------------------------
      
      -- 2. Creating a release branch and getting ready ------------------------------
    Condition
      Error in `fledgeling$version`:
      ! $ operator is invalid for atomic vectors

