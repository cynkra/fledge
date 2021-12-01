# finalize_version(push = TRUE)

    Code
      gert::git_config()[gert::git_config()$name != "user.signingkey", ]
    Output
      # A tibble: 18 x 3
         name                         value                                    level 
         <chr>                        <chr>                                    <chr> 
       1 user.name                    Maëlle Salmon                            global
       2 user.email                   maelle.salmon@yahoo.se                   global
       3 core.editor                  vim                                      global
       4 gpg.program                  gpg                                      global
       5 commit.gpgsign               true                                     global
       6 credential.helper            cache                                    global
       7 init.defaultbranch           main                                     global
       8 core.bare                    false                                    local 
       9 core.repositoryformatversion 0                                        local 
      10 core.filemode                true                                     local 
      11 core.logallrefupdates        true                                     local 
      12 user.name                    Maëlle Salmon                            local 
      13 user.email                   maelle.salmon@yahoo.se                   local 
      14 init.defaultbranch           main                                     local 
      15 remote.origin.url            /tmp/RtmpucoN4m/fledge6df165ff126/remote local 
      16 remote.origin.fetch          +refs/heads/*:refs/remotes/origin/*      local 
      17 branch.main.remote           origin                                   local 
      18 branch.main.merge            refs/heads/main                          local 

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
      [1] "/tmp/RtmpucoN4m/remote6df12b3c8313/remote/"
      
      $bare
      [1] FALSE
      
      $head
      [1] "refs/heads/main"
      
      $shorthand
      [1] "main"
      
      $commit
      [1] "6c2c1adfc68a4a468a6da46fb7f84ecba82cb11a"
      
      $remote
      [1] "origin"
      
      $upstream
      [1] "origin/main"
      
      $reflist
      [1] "refs/heads/main"          "refs/remotes/origin/HEAD"
      [3] "refs/remotes/origin/main" "refs/tags/v0.0.0.9001"   
      
      remote/DESCRIPTION remote/NAMESPACE   remote/NEWS.md     remote/R           
      remote/R/bla.R     remote/tea.Rproj   

