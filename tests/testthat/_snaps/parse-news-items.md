# Can parse Co-authored-by

    Code
      extract_newsworthy_items(
        "- blop\n-blip\n\nCo-authored-by: Person (<person@users.noreply.github.com>)")
    Output
      # A tibble: 2 x 4
        description     type          breaking scope
        <chr>           <chr>         <lgl>    <lgl>
      1 blop (@person). Uncategorized FALSE    NA   
      2 blip (@person). Uncategorized FALSE    NA   

---

    Code
      extract_newsworthy_items(
        "- blop (#42)\n\nCo-authored-by: Person (<person@users.noreply.github.com>)\nCo-authored-by: Someone Else (<else@users.noreply.github.com>)")
    Output
      # A tibble: 1 x 4
        description                 type          breaking scope
        <chr>                       <chr>         <lgl>    <lgl>
      1 blop (@person, @else, #42). Uncategorized FALSE    NA   

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
        "description": "PLACEHOLDER https://github.com/cynkra/fledge/pull/332 (#332).",
        "type": "Uncategorized",
        "breaking": false,
        "scope": "NA"
      }
    ] 

# Can parse PR merge commits - external contributor

    Code
      suppressMessages(extract_newsworthy_items(
        "Merge pull request #18 from someone/conventional-parsing"))
    Output
      <error/github_error>
      Error in `gh::gh()`:
      ! GitHub API error (401): Bad credentials
      i Read more at <https://docs.github.com/rest>
      ---
      Backtrace:
        1. base::suppressMessages(extract_newsworthy_items("Merge pull request #18 from someone/conventional-parsing"))
        3. fledge:::extract_newsworthy_items("Merge pull request #18 from someone/conventional-parsing")
        4. fledge:::parse_merge_commit(message)
             at fledge/R/parse-news-items.R:62:4
        5. fledge:::harvest_pr_data(message)
             at fledge/R/parse-news-items.R:232:2
       12. gh::gh(glue("GET /repos/{slug}/pulls/{pr_number}"))
             at fledge/R/parse-news-items.R:281:8
      <error/github_error>
      Error in `gh()`:
      ! GitHub API error (401): Bad credentials
      i Read more at <https://docs.github.com/graphql>
      ---
      Backtrace:
        1. base::suppressMessages(extract_newsworthy_items("Merge pull request #18 from someone/conventional-parsing"))
        3. fledge:::extract_newsworthy_items("Merge pull request #18 from someone/conventional-parsing")
        4. fledge:::parse_merge_commit(message)
             at fledge/R/parse-news-items.R:62:4
        5. fledge:::harvest_pr_data(message)
             at fledge/R/parse-news-items.R:232:2
       12. gh::gh_gql(...)
             at fledge/R/parse-news-items.R:294:8
       13. gh::gh(endpoint = "POST /graphql", query = query, ...)
      # A tibble: 1 x 4
        description                                                type  break~1 scope
        <chr>                                                      <chr> <lgl>   <lgl>
      1 PLACEHOLDER https://github.com/cynkra/fledge/pull/18 (#18~ Unca~ FALSE   NA   
      # ... with abbreviated variable name 1: breaking

# Can parse PR merge commits - linked issues

    [
      {
        "description": "PLACEHOLDER https://github.com/cynkra/fledge/pull/328 (#328).",
        "type": "Uncategorized",
        "breaking": false,
        "scope": "NA"
      }
    ] 

# Can parse PR merge commits - internet error

    Code
      extract_newsworthy_items(
        "Merge pull request #332 from cynkra/conventional-parsing")
    Message
      ! Could not get title for PR #332 (no internet connection)
    Output
      # A tibble: 1 x 4
        description                                                type  break~1 scope
        <chr>                                                      <chr> <lgl>   <lgl>
      1 PLACEHOLDER https://github.com/cynkra/fledge/pull/332 (#3~ Unca~ FALSE   NA   
      # ... with abbreviated variable name 1: breaking

# Can parse PR merge commits - PAT absence

    x Can't find a GitHub Personal Access Token (PAT).
    i See for instance `?gh::gh_token` or https://usethis.r-lib.org/reference/github-token.html

# Can parse PR merge commits - other error

    [
      {
        "title": "NA",
        "pr_number": "332",
        "issue_numbers": [],
        "external_ctb": "NA"
      }
    ] 

