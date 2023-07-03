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

# init_release() works

    Code
      bump_version()
    Message
      > Digesting messages from 2 commits.
      i Internal changes only.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.0.9001.
      > Added header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
      ! Call `fledge::finalize_version()`.

# init_release() -- force

    Code
      bump_version()
    Message
      > Digesting messages from 2 commits.
      i Internal changes only.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.0.9001.
      > Added header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
      ! Call `fledge::finalize_version()`.

---

    Code
      init_release()
    Condition
      Error in `check_gh_pat()`:
      x Can't find a GitHub Personal Access Token (PAT).
      i See for instance `?gh::gh_token` or <https://usethis.r-lib.org/reference/github-token.html>

