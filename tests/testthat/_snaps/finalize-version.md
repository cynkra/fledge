# finalize_version(push = TRUE)

    Code
      gert::libgit2_config()
    Output
      $version
      [1] '1.1.0'
      
      $ssh
      [1] TRUE
      
      $https
      [1] TRUE
      
      $threads
      [1] TRUE
      
      $config.global
      [1] "/home/maelle/.gitconfig"
      
      $config.system
      [1] ""
      
      $config.home
      [1] "/home/maelle"
      

---

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
      [1] "/tmp/RtmpeSN0Tg/remote508a5b6fd6cc/remote/"
      
      $bare
      [1] FALSE
      
      $head
      [1] "refs/heads/main"
      
      $shorthand
      [1] "main"
      
      $commit
      [1] "f2f8d990ec101b3e4e892c6f5de5c06396a67a2e"
      
      $remote
      [1] "origin"
      
      $upstream
      [1] "origin/main"
      
      $reflist
      [1] "refs/heads/main"          "refs/remotes/origin/HEAD"
      [3] "refs/remotes/origin/main" "refs/tags/v0.0.0.9001"   
      
      remote/DESCRIPTION remote/NAMESPACE   remote/NEWS.md     remote/R           
      remote/R/bla.R     remote/tea.Rproj   

