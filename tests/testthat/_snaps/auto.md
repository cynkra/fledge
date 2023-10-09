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
      +-----------------+
      |                 |
      |   pre-release   |
      |                 |
      +-----------------+
    Message
      
      -- 1. Wrapping up development --------------------------------------------------
      i No change since last version.
      
      -- 2. Creating a release branch and getting ready ------------------------------
      > Creating branch cran-0.0.1.
      > Switching to branch cran-0.0.1.
      > Committing changes.
      
      -- 3. User Action Items --------------------------------------------------------
      * Run `devtools::check_win_devel()`.
      * Run `rhub::check_for_cran()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Run `fledge::pre_release()`.
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
      +-----------------+
      |                 |
      |   pre-release   |
      |                 |
      +-----------------+
    Message
      
      -- 1. Wrapping up development --------------------------------------------------
      i No change since last version.
      
      -- 2. Creating a release branch and getting ready ------------------------------
      > Creating branch cran-0.0.1.
      > Switching to branch cran-0.0.1.
      > Committing changes.
      
      -- 3. User Action Items --------------------------------------------------------
      * Run `devtools::check_win_devel()`.
      * Run `rhub::check_for_cran()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
      * Run `fledge::pre_release()`.
    Output
      NULL

# pre_release() pre-flight checks

    Code
      pre_release()
    Condition
      Error in `check_cran_branch()`:
      x Must be on the a release branch that starts with "cran-" for running `pre_release()`.
      i Currently on branch "main".
      i Do you need to call `init_release()` first?

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

# full cycle

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
      
      -- 2. Creating a release branch and getting ready ------------------------------
      > Creating branch cran-0.0.1.
      > Switching to branch cran-0.0.1.
      > Committing changes.
      
      -- 3. User Action Items --------------------------------------------------------
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
      pre_release()
    Message
      
      -- 1. Opening Pull Request for release branch ----------------------------------
      > Pushing cran-0.0.1 to remote origin.
      > Opening draft pull request with contents from 'cran-comments.md'.
      
      -- 2. User Action Items --------------------------------------------------------
      * Run `fledge::release()`.

---

    Code
      release()
    Message
      > Pushing cran-0.0.1.
      
      -- Tagging Version --
      
      > Creating tag v0.0.1 with tag message derived from 'NEWS.md'.
      > Force-pushing tag v0.0.1.
      i Building
    Output
      -- R CMD build -----------------------------------------------------------------
      * checking for file DESCRIPTION
      * preparing ‘tea’:
      * checking DESCRIPTION meta-information ... OK
      * checking for LF line-endings in source and make files and shell scripts
      * checking for empty or unneeded directories
      * building 'tea_0.0.1.tar.gz'
      
    Message
      i Submitting file: 'tea_0.0.1.tar.gz'
      i File size: "some hundreds of bytes"
      i Uploading package & comments
      Not submitting for real o:-)
      i Check your inbox for a confirmation e-mail from CRAN.
      > Copy the URL to the clipboard.
      Not submitting for real o:-)

---

    Code
      post_release()
    Message
      > Checking presence and scope of `GITHUB_PAT`.
      > Switching to branch main.
      > Pulling main.
      Resetting main to origin/main
      > Merging release branch.
      i If this fails, resolve the conflict manually and push.
      > Digesting messages from 2 commits.
      v Found 1 NEWS-worthy entry.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.1.9000.
      > Added header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.1.9000 with tag message derived from 'NEWS.md'.
      > Pushing main.

