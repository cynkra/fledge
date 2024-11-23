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
        "- blop\n\nCo-authored-by: Person (<person@users.noreply.github.com>)\nCo-authored-by: Someone Else (<else@users.noreply.github.com>)")
    Output
      # A tibble: 1 x 4
        description            type          breaking scope
        <chr>                  <chr>         <lgl>    <lgl>
      1 blop (@person, @else). Uncategorized FALSE    NA   

---

    Code
      extract_newsworthy_items(
        "feat: blop\n\nCo-authored-by: Person (<person@users.noreply.github.com>)")
    Output
      # A tibble: 1 x 4
        description    type     breaking scope
        <chr>          <chr>    <lgl>    <lgl>
      1 blop (@person) Features FALSE    NA   

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

    Code
      suppressMessages(extract_newsworthy_items(
        "Merge pull request #18 from someone/conventional-parsing"))
    Output
      # A tibble: 1 x 4
        description                                               type  breaking scope
        <chr>                                                     <chr> <lgl>    <lgl>
      1 Improve parsing of conventional commit messages (@someon~ Feat~ FALSE    NA   

# Can parse PR merge commits - linked issues

    [
      {
        "description": "improve bump_version() (error) messages  (#153, cynkra/dm#325, #328).",
        "type": "Features",
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
        description                                               type  breaking scope
        <chr>                                                     <chr> <lgl>    <lgl>
      1 PLACEHOLDER https://github.com/cynkra/fledge/pull/332 (#~ Unca~ FALSE    NA   

# Can parse PR merge commits - PAT absence

    Code
      extract_newsworthy_items(
        "Merge pull request #332 from cynkra/conventional-parsing")
    Condition
      Error in `check_gh_pat()`:
      x Can't find a GitHub Personal Access Token (PAT).
      i See for instance `?gh::gh_token` or <https://usethis.r-lib.org/reference/github-token.html>

# Can parse PR merge commits - other error

    [
      {
        "title": "NA",
        "pr_number": "332",
        "issue_numbers": "",
        "external_ctb": "NA"
      }
    ] 

# Can parse PR squash commits - linked issues

    [
      {
        "description": "improve bump_version() (error) messages  (#153, cynkra/dm#325, #328).",
        "type": "Features",
        "breaking": false,
        "scope": "NA"
      }
    ] 

