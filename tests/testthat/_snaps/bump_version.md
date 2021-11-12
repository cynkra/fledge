# bump_version() works

    Code
      bump_version()
    Message <cliMessage>
      > Scraping 3 commit messages.
      v Found 1 NEWS-worthy entries.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
    Output
      [1] "NEWS.md"
    Message <cliMessage>
      
      -- Update Version --
      
      v Package version bumped to 0.0.0.9001.
      > Adding header to 'NEWS.md'.
    Output
      [1] "NEWS.md"
    Message <cliMessage>
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
    Message <rlang_message>
      * Edit 'NEWS.md'
    Message <cliMessage>
      ! Call `fledge::finalize_version()`.
    Output
      NULL

