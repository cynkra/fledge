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
        "description": "Merge pull request #332 from cynkra/conventional-parsing (#332).",
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
      <error/httptest2_request>
      Error in `stop_request()`:
      ! An unexpected request was made:
      GET https://api.github.com/repos/cynkra/fledge/pulls/18
      Expected mock file: api.github.com/repos/cynkra/fledge/pulls/18.*
      ---
      Backtrace:
           x
        1. +-base::suppressMessages(extract_newsworthy_items("Merge pull request #18 from someone/conventional-parsing"))
        2. | \-base::withCallingHandlers(...)
        3. \-fledge:::extract_newsworthy_items("Merge pull request #18 from someone/conventional-parsing")
        4.   \-fledge:::parse_merge_commit(message) at fledge/R/parse-news-items.R:85:3
        5.     \-fledge:::harvest_pr_data(message) at fledge/R/parse-news-items.R:245:3
        6.       +-base::tryCatch(...) at fledge/R/parse-news-items.R:305:5
        7.       | \-base (local) tryCatchList(expr, classes, parentenv, handlers)
        8.       |   \-base (local) tryCatchOne(expr, names, parentenv, handlers[[1L]])
        9.       |     \-base (local) doTryCatch(return(expr), name, parentenv, handler)
       10.       +-base::suppressMessages(gh(glue("GET /repos/{slug}/pulls/{pr_number}"))) at fledge/R/parse-news-items.R:308:9
       11.       | \-base::withCallingHandlers(...)
       12.       \-fledge:::gh(glue("GET /repos/{slug}/pulls/{pr_number}")) at fledge/R/parse-news-items.R:308:9
       13.         \-gh::gh(...) at fledge/R/utils-gh.R:2:3
       14.           \-gh:::gh_make_request(req) at gh/R/gh.R:204:3
       15.             \-httr2::req_perform(req, path = x$desttmp) at gh/R/gh.R:331:3
       16.               \-httptest2 (local) mock(req) at httr2/R/req-perform.R:82:5
       17.                 \-httptest2:::stop_request(req) at httptest2/R/mock-api.R:73:3
      # A tibble: 1 x 4
        description                                               type  breaking scope
        <chr>                                                     <chr> <lgl>    <lgl>
      1 Merge pull request #18 from someone/conventional-parsing~ Unca~ FALSE    NA   

# Can parse PR merge commits - linked issues

    [
      {
        "description": "Merge pull request #328 from cynkra/blop (#153, cynkra/dm#325, #328).",
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
        description                                               type  breaking scope
        <chr>                                                     <chr> <lgl>    <lgl>
      1 Merge pull request #332 from cynkra/conventional-parsing~ Unca~ FALSE    NA   

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
        "title": "- Merge pull request #332 from cynkra/conventional-parsing",
        "pr_number": "332",
        "issue_numbers": "",
        "external_ctb": "NA"
      }
    ] 

# Can parse PR squash commits - linked issues

    [
      {
        "description": "feat: blop (#328)",
        "type": "Uncategorized",
        "breaking": false,
        "scope": "NA"
      }
    ] 

