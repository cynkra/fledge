# check_only_modified() works

    Code
      check_only_modified("NEWS.md")
    Condition
      Error in `check_only_modified()`:
      x Found untracked/unstaged/staged file in the git index: 'blop.R'.
      i Please commit or discard it and try again.

---

    Code
      check_only_modified("NEWS.md")
    Condition
      Error in `check_only_modified()`:
      x Found untracked/unstaged/staged files in the git index: 'blop.R' and 'onemore.R'.
      i Please commit or discard them and try again.

