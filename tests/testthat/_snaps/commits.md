# get_top_level_commits_impl() works

    Code
      get_top_level_commits_impl(NULL)["message"]
    Output
      # A tibble: 4 x 1
        message       
        <chr>         
      1 "- merge\n"   
      2 "- b\n"       
      3 "- a\n"       
      4 ".gitignore\n"
    Code
      get_top_level_commits_impl(repo$a)["message"]
    Output
      # A tibble: 3 x 1
        message    
        <chr>      
      1 "- merge\n"
      2 "- b\n"    
      3 "- a\n"    
    Code
      get_top_level_commits_impl(repo$b)["message"]
    Output
      # A tibble: 2 x 1
        message    
        <chr>      
      1 "- merge\n"
      2 "- b\n"    
    Code
      get_top_level_commits_impl(repo$e)["message"]
    Output
      # A tibble: 1 x 1
        message    
        <chr>      
      1 "- merge\n"
    Code
      # # Questioning
      get_top_level_commits_impl(repo$c)["message"]
    Output
      # A tibble: 3 x 1
        message    
        <chr>      
      1 "- merge\n"
      2 "- d\n"    
      3 "- c\n"    
    Code
      get_top_level_commits_impl(repo$d)["message"]
    Output
      # A tibble: 2 x 1
        message    
        <chr>      
      1 "- merge\n"
      2 "- d\n"    

