# tag_version() works

    Code
      tag_version()
      get_last_version_tag()[, c("name", "ref")]
    Output
      # A tibble: 1 x 2
        name        ref                  
        <chr>       <chr>                
      1 v0.0.0.9000 refs/tags/v0.0.0.9000

---

    Code
      tag_version(force = FALSE)
    Condition
      Error in `tag_version_impl()`:
      ! Tag "v0.0.0.9000" exists, use `force = TRUE` to overwrite.

---

    Code
      tag_version(force = TRUE)
    Message
      
      -- Tagging Version --
      
      > Deleting existing tag v0.0.0.9000.
      > Creating tag v0.0.0.9000 with tag message derived from 'NEWS.md'.
    Code
      get_last_version_tag()[, c("name", "ref")]
    Output
      # A tibble: 1 x 2
        name        ref                  
        <chr>       <chr>                
      1 v0.0.0.9000 refs/tags/v0.0.0.9000

