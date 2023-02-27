# update_news() works when news file still empty

    Code
      read_fledgling()
    Output
      $name
      [1] "tea"
      
      $version
      [1] '0.0.1'
      
      $date
      [1] "2023-01-23"
      
      $preamble
      [1] "<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->"
      
      $news
      # A tibble: 1 x 10
        start   end h2    raw                                                     
        <int> <int> <lgl> <chr>                                                   
      1     3     6 FALSE "# tea 0.0.1 (2023-01-23)\n\n- Internal changes only.\n"
        news             section_state title                  version date        
        <named list>     <chr>         <chr>                  <chr>   <chr>       
      1 <named list [1]> keep          tea 0.0.1 (2023-01-23) 0.0.1   (2023-01-23)
        nickname
        <chr>   
      1 <NA>    
      
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

