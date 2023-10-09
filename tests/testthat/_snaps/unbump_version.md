# unbump_version() works

    Code
      bump_version()
    Message
      > Digesting messages from 3 commits.
      v Found 1 NEWS-worthy entry.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.0.9001.
      > Added header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
      ! Run `fledge::finalize_version()`.
    Code
      unbump_version()
    Message
      i Checking if working copy is clean.
      i Checking if last tag points to last commit.
      i Checking if commit messages match.
      v Safety checks complete.
      > Deleting tag v0.0.0.9001.
      v Resetting to parent commit 42.
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
    Message
      > Digesting messages from 4 commits.
      v Found 2 NEWS-worthy entries.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.0.9001.
      > Added header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
      ! Run `fledge::finalize_version()`.

