# Can parse Co-authored-by

    Code
      extract_newsworthy_items(
        "- blop\n-blip\n\nCo-authored-by: Person (<person@users.noreply.github.com>)")
    Output
      # A tibble: 2 x 4
        description    type          breaking scope
        <chr>          <chr>         <lgl>    <lgl>
      1 blop (@person) Uncategorized FALSE    NA   
      2 blip (@person) Uncategorized FALSE    NA   

---

    Code
      extract_newsworthy_items(
        "- blop (#42)\n\nCo-authored-by: Person (<person@users.noreply.github.com>)\nCo-authored-by: Someone Else (<else@users.noreply.github.com>)")
    Output
      # A tibble: 1 x 4
        description                type          breaking scope
        <chr>                      <chr>         <lgl>    <lgl>
      1 blop (@person, @else, #42) Uncategorized FALSE    NA   

---

    Code
      extract_newsworthy_items(
        "feat: blop (#42)\n\nCo-authored-by: Person (<person@users.noreply.github.com>)")
    Output
      # A tibble: 1 x 4
        description         type     breaking scope
        <chr>               <chr>    <lgl>    <lgl>
      1 blop (@person, #42) Features FALSE    NA   

# Can parse PR merge commits

    [
      {
        "description": "Improve parsing of conventional commit messages (#332).",
        "type": "Features",
        "breaking": false,
        "scope": "NA"
      }
    ] 

# Can parse PR merge commits - external contributor

    [
      {
        "description": "Improve parsing of conventional commit messages (@someone, #18).",
        "type": "Features",
        "breaking": false,
        "scope": "NA"
      }
    ] 

# Can parse PR merge commits - internet error

    [
      {
        "description": "PLACEHOLDER https://github.com/cynkra/fledge/pull/332 (#332).",
        "type": "Uncategorized",
        "breaking": false,
        "scope": "NA"
      }
    ] 

# Can parse PR merge commits - PAT error

    x Can't find a GitHub Personal Access Token (PAT).
    i See for instance `?gh::gh_token` or https://usethis.r-lib.org/reference/github-token.html

# Can parse PR merge commits - other error

    Code
      harvest_pr_data("Merge pull request #332 from cynkra/conventional-parsing")
    Output
      <simpleError in gh::gh(glue("GET /repos/{slug}/pulls/{pr_number}")): bla>
    Message
      ! Could not get title for PR #332
    Output
      # A tibble: 1 x 3
        title pr_number external_ctb
        <chr> <chr>     <chr>       
      1 <NA>  332       <NA>        

# capitalize_news() works

    Code
      capitalize_news(df)
    Output
      # A tibble: 6 x 1
        description                     
      * <chr>                           
      1 fledge has better support       
      2 fledge's interface was improved 
      3 Fledged bird                    
      4 `update_news()` capitalize items
      5 2 new functions for bla         
      6 Harvest PR title                

