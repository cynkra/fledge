# finalize_version(push = TRUE)

    Code
      show_tags(remote_url)
    Output
      # A tibble: 1 x 2
        name        ref                  
        <chr>       <chr>                
      1 v0.0.0.9001 refs/tags/v0.0.0.9001

---

    Code
      show_files(remote_url)
    Output
      # A tibble: 0 x 3
      # ... with 3 variables: file <chr>, status <chr>, staged <lgl>
      $path
      [1] "/tmp/RtmpT9pKif/remote4e2a6bfc8b95/remote/"
      
      $bare
      [1] FALSE
      
      $head
      [1] "refs/heads/main"
      
      $shorthand
      [1] "main"
      
      $commit
      [1] "a4a7072a34d082b5e8fcfca678bb3c8d143b89c0"
      
      $remote
      [1] "origin"
      
      $upstream
      [1] "origin/main"
      
      $reflist
      [1] "refs/heads/main"          "refs/remotes/origin/HEAD"
      [3] "refs/remotes/origin/main" "refs/tags/v0.0.0.9001"   
      
      remote/DESCRIPTION remote/NAMESPACE   remote/NEWS.md     remote/R           
      remote/R/bla.R     remote/tea.Rproj   

