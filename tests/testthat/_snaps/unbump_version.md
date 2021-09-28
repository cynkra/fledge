# unbump_version() works

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
      ! Call `fledge::finalize_version()`.
    Output
      NULL
    Code
      unbump_version()
    Message <cliMessage>
      i Checking if working copy is clean.
      i Checking if last tag points to last commit.
      i Checking if commit messages match.
      v Safety checks complete.
      > Deleting tag v0.0.0.9001.
      v Resetting to parent commit 4c21f09bf056df7bbab3b591811ab36ee12940b4.
    Code
      use_r("blop")
      gert::git_add("R/blop.R")
    Output
      # A tibble: 1 x 3
        file     status staged
        <chr>    <chr>  <lgl> 
      1 R/blop.R new    TRUE  
    Code
      c <- gert::git_commit("* Add cool blop.", author = default_gert_author(),
      committer = default_gert_committer())
      bump_version()
    Message <cliMessage>
      > Scraping 4 commit messages.
      v Found 2 NEWS-worthy entries.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Update Version --
      
      v Package version bumped to 0.0.0.9001.
      > Adding header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
      ! Call `fledge::finalize_version()`.
    Output
      NULL

