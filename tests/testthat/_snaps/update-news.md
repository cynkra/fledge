# update_news() works when news file still empty

    Code
      read_fledgling()
    Output
      $name
      [1] "tea"
      
      $version
      [1] "0.0.1"
      
      $date
      [1] "2023-01-23"
      
      $preamble
      [1] "<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->"
      
      $news
      # A tibble: 1 x 9
        start   end h2   
        <int> <int> <lgl>
      1     3     6 FALSE
        raw                                                                           
        <chr>                                                                         
      1 "# tea 0.0.1 (2023-01-23)\n\n- Added a `NEWS.md` file to track changes to the~
        section_state title                  version date         nickname
        <chr>         <chr>                  <chr>   <chr>        <chr>   
      1 keep          tea 0.0.1 (2023-01-23) 0.0.1   (2023-01-23) <NA>    
      
      $preamble_in_file
      [1] TRUE
      
      attr(,"class")
      [1] "fledgling"

# normalize_news() works

    [
      {
        "description": "fledge has better support."
      },
      {
        "description": "fledge's interface was improved!"
      },
      {
        "description": "Fledged bird?"
      },
      {
        "description": "`update_news()` capitalize items."
      },
      {
        "description": "2 new functions for bla."
      },
      {
        "description": "Harvest PR title."
      }
    ] 

# regroup_news() works

    Code
      regroup_news(combined)
    Output
      $`Custom type`
      [1] "cool right"
      
      $Features
      [1] "- feat1" ""        "- feat2"
      
      $Documentation
      [1] "- stuff" ""        "- other" ""        "- again"
      
      $Uncategorized
      [1] "- blop" ""       "- etc"  ""       "- pof"  ""       "- ok"  
      

