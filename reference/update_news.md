# Update NEWS.md with messages from top-level commits

Lists all commits from a range (default: top-level commits since the
most recent tag) and adds bullets from their body to `NEWS.md`. Creates
`NEWS.md` if necessary.

## Usage

``` r
update_news(messages = NULL)
```

## Arguments

- messages:

  A character vector of commit messages, e.g. as in the `message` column
  in the return value of
  [`get_top_level_commits()`](https://fledge.cynkra.com/reference/get_top_level_commits.md).
  The default uses the top level commits since the last tag as retrieved
  by
  [`get_last_tag()`](https://fledge.cynkra.com/reference/get_last_tag.md).

## Value

None

## Examples

``` r
# Create mock package in a temporary directory.
# Set open to TRUE if you want to play in the mock package.
with_demo_project({
  # Use functions as if inside the newly created package project.
  # (Or go and actually run code inside the newly created package project!)
  # Add a new R file.
  usethis::use_r("cool-function", open = FALSE)
  # Pretend we added useful code inside it.
  # Track the new R file with Git.
  gert::git_add("R/cool-function.R")
  gert::git_commit("- Add cool function.")
  # Bump version with fledge.
  fledge::bump_version()
  fledge::update_news(c("- something I forgot", "- blabla"))
  fledge::update_version()
  gert::git_add("NEWS.md")
  gert::git_commit(message = "release notes tweaking")
  fledge::tag_version()
  print(fledge::get_last_tag())
})
#> ✔ Setting active project to "/tmp/Rtmpqw2oTM/fledge21a25e96ee38/tea".
#> ☐ Edit R/cool-function.R.
#> → Scraping 3 commit messages.
#> ✔ Found 1 NEWS-worthy entries.
#> 
#> ── Updating NEWS ──
#> 
#> → Adding new entries to NEWS.md.
#> Warning: 'Date' must be an ISO date: yyyy-mm-dd, but it is actually better to leave       this field out completely. It is not required.
#> 
#> ── Update Version ──
#> 
#> ✔ Package version bumped to 0.0.0.9001.
#> → Adding header to NEWS.md.
#> → Committing changes.
#> 
#> ── Tagging Version ──
#> 
#> → Creating tag v0.0.0.9001 with tag message derived from NEWS.md.
#> ☐ Edit NEWS.md.
#> ! Call `fledge::finalize_version()`.
#> → Scraping 2 commit messages.
#> ✔ Found 2 NEWS-worthy entries.
#> 
#> ── Updating NEWS ──
#> 
#> → Adding new entries to NEWS.md.
#> 
#> ── Update Version ──
#> 
#> ✔ Package version bumped to 0.0.0.9002.
#> → Adding header to NEWS.md.
#> 
#> ── Tagging Version ──
#> 
#> → Creating tag v0.0.0.9002 with tag message derived from NEWS.md.
#> # A tibble: 1 × 3
#>   name        ref                   commit                                  
#> * <chr>       <chr>                 <chr>                                   
#> 1 v0.0.0.9002 refs/tags/v0.0.0.9002 e7d03184c5af1498153f17ed1d6e768664c5f34f
#> ✔ Setting active project to "<no active project>".
```
