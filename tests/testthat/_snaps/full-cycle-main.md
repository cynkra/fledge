# full cycle, add more to main

    Code
      pre_release()
    Message
      
      -- 1. Opening Pull Request for release branch ----------------------------------
      > Pushing cran-0.0.1 to remote origin.

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

---

    Code
      post_release()
    Message
      > Omitting in test.

