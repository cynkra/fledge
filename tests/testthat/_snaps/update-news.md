# update_news() works when news file still empty

    Code
      read_fledgling()
    Output
      $name
      [1] "tea"
      
      $version
      [1] '0.0.0.9000'
      
      $date
      [1] "2021-09-27"
      
      $preamble
      [1] "<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->"
      
      $news
      NULL
      
      $preamble_in_file
      [1] FALSE
      
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

