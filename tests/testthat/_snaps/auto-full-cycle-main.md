# full cycle, add more to main

    Code
      plan_release("next")
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
      > Creating branch cran-0.0.1.
      > Switching to branch cran-0.0.1.
      > Committing changes.
      
      -- 2. Opening Pull Request for release branch ----------------------------------
      > Pushing cran-0.0.1 to remote origin.
      > Opening pull request with instructions.
      
      -- 3. User Action Items --------------------------------------------------------
      * Run `devtools::check_win_devel()`.
      * Run `urlchecker::url_update()`.
      * Check all items in 'cran-comments.md'.
      * Review 'NEWS.md'.
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
      i Check your inbox for a confirmation e-mail from CRAN.
      > Copy the URL to the clipboard.
      Not submitting for real o:-)

---

    Code
      post_release()
    Message
      > Creating GitHub release "v0.0.1".
      > Omitting in test.

---

    Code
      post_release()
    Message
      > Creating GitHub release "v0.0.1".
      > Omitting in test.

