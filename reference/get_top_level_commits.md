# All top-level commits

Return all top-level commits since a particular version as commit
objects.

## Usage

``` r
get_top_level_commits(since = NULL)
```

## Arguments

- since:

  A commit SHA, e.g. as returned from
  [`get_last_tag()`](https://fledge.cynkra.com/reference/get_last_tag.md).
  If `NULL`, the entire log is retrieved.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with at least two columns:

- `commit`: the commit SHA

- `message`: the commit message

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
  fledge::finalize_version()
  print(get_top_level_commits(since = NULL))
  print(fledge::get_last_tag())
})
#> ✔ Setting active project to "/tmp/Rtmpqw2oTM/fledge21a2340707d2/tea".
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
#> → Resetting to previous commit.
#> → Committing changes.
#> 
#> ── Tagging Version ──
#> 
#> ℹ Tag v0.0.0.9001 exists and points to the current commit.
#> # A tibble: 4 × 2
#>   commit                                   message                          
#>   <chr>                                    <chr>                            
#> 1 df0d8567b8ed56b13aa3dc1ee901c99902e4151d "Bump version to 0.0.0.9001\n"   
#> 2 866408c6da30912ee7663cf2b2c5d9a29ff96540 "- Add cool function.\n"         
#> 3 d77361a68135a8eec1c6f612b2b6e2564f09c2ca "Add NEWS.md to track changes.\n"
#> 4 70e0d17ddfcfe6434e67c983b2c12586816baddc "First commit\n"                 
#> # A tibble: 1 × 3
#>   name        ref                   commit                                  
#> * <chr>       <chr>                 <chr>                                   
#> 1 v0.0.0.9001 refs/tags/v0.0.0.9001 8bd1a0f67087022fed9782cb7dc234e532e1d3de
#> ✔ Setting active project to "<no active project>".
```
