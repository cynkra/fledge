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
      [1] "/tmp/RtmpQnqCE5/remote6ad3702d2e6e/remote/"
      
      $bare
      [1] FALSE
      
      $head
      [1] "refs/heads/main"
      
      $shorthand
      [1] "main"
      
      $commit
      [1] "71b3849612930c58c33c91f5dc79dcf4753bbe71"
      
      $remote
      [1] "origin"
      
      $upstream
      [1] "origin/main"
      
      $reflist
      [1] "refs/heads/main"          "refs/remotes/origin/HEAD"
      [3] "refs/remotes/origin/main" "refs/tags/v0.0.0.9001"   
      
      remote/DESCRIPTION remote/NAMESPACE   remote/NEWS.md     remote/R           
      remote/R/bla.R     remote/tea.Rproj   

