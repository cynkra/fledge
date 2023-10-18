# check_only_modified() works

    Code
      check_only_modified("NEWS.md")
    Condition
      Error in `check_only_modified()`:
      ! Found untracked/unstaged/staged files in the git index: 'blop.R'. Please commit or discard them and try again.

---

    Code
      check_only_modified("NEWS.md")
    Condition
      Error in `check_only_modified()`:
      ! Found untracked/unstaged/staged files in the git index: 'blop.R' and 'onemore.R'. Please commit or discard them and try again.

---

    Code
      check_only_modified(c("blop.R", "NEWS.md"))
    Condition
      Error in `check_only_modified()`:
      ! Found untracked/unstaged/staged files in the git index: 'onemore.R'. Please commit or discard them and try again.

