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

# init_release() works

    Code
      init_release()
    Output
      +------------------+
      |                  |
      |   init-release   |
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
      * Run `rhub::check_for_cran()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Run `fledge::release()`.
    Output
      NULL

# init_release() -- force

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
      +------------------+
      |                  |
      |   init-release   |
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
      * Run `rhub::check_for_cran()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Run `fledge::release()`.
    Output
      NULL

# full cycle

    Code
      init_release()
    Message
      > Checking presence and scope of `GITHUB_PAT`.
    Output
      +------------------+
      |                  |
      |   init-release   |
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
      * Run `rhub::check_for_cran()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Run `fledge::release()`.
    Output
      NULL

---

    Code
      release()
    Message
      > Checking presence and scope of `GITHUB_PAT`.
      > Pushing cran-0.0.1.
      
      -- Tagging Version --
      
      > Creating tag v0.0.1 with tag message derived from 'NEWS.md'.
      > Force-pushing tag v0.0.1.
      i Building
    Output
      -- R CMD build -----------------------------------------------------------------
      * checking for file DESCRIPTION
      * preparing 'tea'
      * checking DESCRIPTION meta-information ... OK
      * checking for LF line-endings in source and make files and shell scripts
      * checking for empty or unneeded directories
      * building 'tea_0.0.1.tar.gz'
      
    Message
      i Submitting file: 'tea_0.0.1.tar.gz'
      i File size: "some hundreds of bytes"
      i Uploading package & comments
      Not submitting for real o:-)
      > Switching to branch main.
      > Pulling main.
      Resetting main to origin/main
      > Merging release branch.
      > Push main branch after the release.
      i Check your inbox for a confirmation e-mail from CRAN.
      > Copy the URL to the clipboard.
      Not submitting for real o:-)

---

    Code
      post_release()
    Message
      > Creating GitHub release "v0.0.1".
      > Omitting in test.

# full cycle pre-minor

    Code
      init_release()
    Message
      > Checking presence and scope of `GITHUB_PAT`.
    Output
      +------------------+
      |                  |
      |   init-release   |
      |                  |
      +------------------+
    Message
      
      -- 1. Creating a release branch and getting ready ------------------------------
      > Creating branch cran-0.1.0.
      > Switching to branch cran-0.1.0.
      > Committing changes.
      
      -- 2. Opening Pull Request for release branch ----------------------------------
      > Pushing cran-0.1.0 to remote origin.
      > Opening draft pull request with contents from 'cran-comments.md'.
      
      -- 3. User Action Items --------------------------------------------------------
      * Run `devtools::check_win_devel()`.
      * Run `rhub::check_for_cran()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Run `fledge::release()`.
    Output
      NULL

---

    Code
      release()
    Message
      > Checking presence and scope of `GITHUB_PAT`.
      > Pushing cran-0.1.0.
      
      -- Tagging Version --
      
      > Creating tag v0.1.0 with tag message derived from 'NEWS.md'.
      > Force-pushing tag v0.1.0.
      i Building
    Output
      -- R CMD build -----------------------------------------------------------------
      * checking for file DESCRIPTION
      * preparing 'tea'
      * checking DESCRIPTION meta-information ... OK
      * checking for LF line-endings in source and make files and shell scripts
      * checking for empty or unneeded directories
      * building 'tea_0.0.1.tar.gz'
      
    Message
      i Submitting file: 'tea_0.0.1.tar.gz'
      i File size: "some hundreds of bytes"
      i Uploading package & comments
      Not submitting for real o:-)
      > Switching to branch main.
      > Pulling main.
      Resetting main to origin/main
      > Merging release branch.
      i Check your inbox for a confirmation e-mail from CRAN.
      > Copy the URL to the clipboard.
      Not submitting for real o:-)

---

    Code
      post_release()
    Message
      > Creating GitHub release "v0.1.0".
      > Omitting in test.

# release abandon

    Code
      init_release(force = TRUE)
    Condition
      Error in `check_main_branch()`:
      x Must be on the main branch ("main") for running `init_release()`.
      i Currently on branch "cran-0.0.1".

---

    Code
      init_release(force = FALSE)
    Message
      > Checking presence and scope of `GITHUB_PAT`.
    Condition
      Error in `check_release_branch()`:
      x The branch "cran-0.0.1" already exists.
      i Do you need `init_release(force = TRUE)`?

---

    Code
      init_release(force = TRUE)
    Message
      > Checking presence and scope of `GITHUB_PAT`.
    Output
      +------------------+
      |                  |
      |   init-release   |
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
      * Run `rhub::check_for_cran()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Run `fledge::release()`.
    Output
      NULL

# full cycle, add more to main

    Code
      post_release()
    Message
      > Omitting in test.

---

    Code
      post_release()
    Message
      > Omitting in test.

---

    Code
      post_release()
    Message
      > Omitting in test.

---

    Code
      post_release()
    Message
      > Omitting in test.

---

    Code
      post_release()
    Message
      > Omitting in test.

---

    Code
      post_release()
    Message
      > Omitting in test.

# full cycle, add more to main NO PUSH

    Code
      post_release()
    Message
      > Omitting in test.

---

    Code
      post_release()
    Message
      > Omitting in test.

---

    Code
      post_release()
    Message
      > Omitting in test.

