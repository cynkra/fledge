# bump_version() works -- dev

    Code
      bump_version()
    Message
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
      ! Call `fledge::finalize_version(push = TRUE)`.
    Output
      NULL

# bump_version() works -- not dev

    Code
      bump_version(which = "major")
    Message
      > Scraping 3 commit messages.
      v Found 1 NEWS-worthy entries.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Update Version --
      
      v Package version bumped to 1.0.0.
      > Adding header to 'NEWS.md'.
      > Committing changes.
      i Preparing package for release (CRAN or otherwise).
      ! Convert the change log in 'NEWS.md' to release notes.
      ! After CRAN release, call `fledge::tag_version()` and
      `fledge::bump_version()` to re-enter development mode

