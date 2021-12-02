# bump_version() works -- dev

    Code
      bump_version()
    Message <cliMessage>
      > Scraping 3 commit messages.
      v Found 1 NEWS-worthy entries.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Update Version --
      
      v Package version bumped to 0.0.0.9001.
      > Adding header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
    Message <message>
      * Edit 'NEWS.md'
    Message <cliMessage>
      ! Call `fledge::finalize_version(push = TRUE)`.
    Output
      NULL

# bump_version() works -- not dev

    Code
      bump_version(which = "major")
    Message <cliMessage>
      > Scraping 3 commit messages.
      v Found 1 NEWS-worthy entries.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Update Version --
      
      v Package version bumped to 1.0.0.
      > Adding header to 'NEWS.md'.
      > Committing changes.
      i Preparing package for release (CRAN or otherwise).
    Message <message>
      * Edit 'NEWS.md'
    Message <cliMessage>
      ! Convert the change log in 'NEWS.md' to release notes.
      ! After CRAN release, call `fledge::tag_version()` and
      `fledge::bump_version()` to re-enter development mode

# bump_version() errors informatively for forbidden notifications

    Unindexed change(s) in `DESCRIPTION`.
    i Commit the change(s) before running any fledge function again.

# bump_version() errors informatively for wrong branch

    Must be on the main branch (main) for running fledge functions.
    i Currently on branch bla.

