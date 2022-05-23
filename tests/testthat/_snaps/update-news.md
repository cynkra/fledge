# Can parse PR merge commits

    Code
      extract_newsworthy_items(
        "Merge pull request #332 from cynkra/conventional-parsing")
    Message
      No encoding supplied: defaulting to UTF-8.
    Output
      # A tibble: 1 x 4
        description                                     type     breaking scope
        <chr>                                           <chr>    <lgl>    <lgl>
      1 Improve parsing of conventional commit messages Features FALSE    NA   

# Can parse PR merge commits - internet error

    Code
      extract_newsworthy_items(
        "Merge pull request #332 from cynkra/conventional-parsing")
    Message
      ! Could not get title for PR #332 (no internet connection)
    Output
      # A tibble: 1 x 4
        description                                               type  breaking scope
        <chr>                                                     <chr> <lgl>    <lgl>
      1 PLACEHOLDER https://github.com/cynkra/fledge/pull/332 (#~ Unca~ FALSE    NA   

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
      # A tibble: 1 x 2
        title pr_number
        <lgl> <chr>    
      1 NA    332      

