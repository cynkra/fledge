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

