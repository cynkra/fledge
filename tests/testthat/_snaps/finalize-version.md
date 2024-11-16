# finalize_version(push = FALSE)

    Code
      finalize_version(push = FALSE)
    Message
      > Resetting to previous commit.
      > Committing changes.
      
      -- Tagging Version --
      
      > Deleting existing tag v0.0.0.9001.
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.

# finalize_version(push = TRUE)

    Code
      finalize_version(push = TRUE)
    Message
      > Resetting to previous commit.
      > Committing changes.
      
      -- Tagging Version --
      
      > Deleting existing tag v0.0.0.9001.
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
      > Pushing main.
      > Force-pushing tag v0.0.0.9001.
    Code
      show_tags(remote_url)
    Output
      # A tibble: 1 x 2
        name        ref                  
        <chr>       <chr>                
      1 v0.0.0.9001 refs/tags/v0.0.0.9001
    Code
      show_files(remote_url)
    Output
      remote/DESCRIPTION remote/NAMESPACE   remote/NEWS.md     remote/R           
      remote/R/bla.R     remote/tea.Rproj   

