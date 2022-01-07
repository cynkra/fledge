# tag_version() works

    Code
      tag_version()
    Message <cliMessage>
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9000 with tag message derived from 'NEWS.md'.

---

    Code
      get_last_tag()[, c("name", "ref")]
    Output
      # A tibble: 1 x 2
        name        ref                  
        <chr>       <chr>                
      1 v0.0.0.9000 refs/tags/v0.0.0.9000

---

    Tag v0.0.0.9000 exists, use `force = TRUE` to overwrite.

---

    Code
      tag_version(force = TRUE)
    Message <cliMessage>
      
      -- Tagging Version --
      
      > Deleting existing tag v0.0.0.9000.
      > Creating tag v0.0.0.9000 with tag message derived from 'NEWS.md'.

---

    Code
      get_last_tag()[, c("name", "ref")]
    Output
      # A tibble: 1 x 2
        name        ref                  
        <chr>       <chr>                
      1 v0.0.0.9000 refs/tags/v0.0.0.9000

