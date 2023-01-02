# update_news() works when news file still empty

    Code
      read_fledgling()
    Output
      $name
      [1] "tea"
      
      $version
      [1] '0.0.1'
      
      $preamble
      [1] "<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->"
      
      $news
      # A tibble: 1 x 8
         line h2    version date  nickname original    news             raw           
        <int> <lgl> <chr>   <chr> <chr>    <chr>       <list>           <chr>         
      1     3 FALSE 0.0.1   ""    ""       # tea 0.0.1 <named list [1]> "# tea 0.0.1\~
      
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

