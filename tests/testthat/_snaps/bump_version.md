# bump_version() works -- dev

    number of characters is not computable in "bytes" encoding, element 1

# bump_version() works -- not dev

    Code
      bump_version(which = "major")
    Message
      > Scraping 3 commit messages.
      v Found 1 NEWS-worthy entry.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 1.0.0.
      > Adding header to 'NEWS.md'.
      > Committing changes.
      
      -- Preparing package for CRAN release --
      
      * Convert the change log in 'NEWS.md' to release notes.

# bump_version() errors informatively for forbidden notifications

    x Unindexed change(s) in `DESCRIPTION`.
    i Commit the change(s) before running any fledge function again.

# bump_version() errors informatively for wrong branch

    x Must be on the main branch (main) for running fledge functions.
    i Currently on branch bla.

# bump_version() errors well for wrong arguments

    `no_change_behavior` must be one of "bump", "noop", or "fail", not "blabla".

---

    `which` must be one of "dev", "patch", "minor", or "major", not "blabla".

