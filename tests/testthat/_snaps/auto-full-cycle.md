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
      Not submitting for real o:-)

---

    Code
      post_release()
    Message
      > Omitting in test.

