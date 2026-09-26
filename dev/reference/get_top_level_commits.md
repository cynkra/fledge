# All top-level commits

Return all top-level commits since a particular version as commit
objects.

## Usage

``` r
get_top_level_commits(since = NULL)
```

## Arguments

- since:

  A commit SHA, e.g. as returned in the `commit` component of
  [`get_last_version_tag()`](https://fledge.cynkra.com/dev/reference/get_last_version_tag.md).
  If `NULL`, the entire log is retrieved.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with at
least two columns:

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
#> ✔ Setting active project to "/tmp/RtmpsCl8tI/fledge3f29435c1220/tea".
#> ☐ Edit R/cool-function.R.
#> → Digesting messages from 3 commits.
#> ✔ Found 1 NEWS-worthy entry.
#> 
#> ── Updating NEWS ──
#> 
#> → Adding new entries to NEWS.md.
#> 
#> ── Updating Version ──
#> 
#> ✔ Package version bumped to 0.0.0.9001.
#> → Added header to NEWS.md.
#> → Committing changes.
#> 
#> ── Tagging Version ──
#> 
#> → Creating tag v0.0.0.9001 with tag message derived from NEWS.md.
#> ! Run `fledge::finalize_version()`.
#> → Resetting to previous commit.
#> → Committing changes.
#> 
#> ── Tagging Version ──
#> 
#> ℹ Tag v0.0.0.9001 exists and points to the current commit.
#> # A tibble: 4 × 3
#>   commit                                   message                         merge
#>   <chr>                                    <chr>                           <lgl>
#> 1 81472ca2fc2e2eadad559b173bd3bcd2337ee556 "fledge: Bump version to 0.0.0… FALSE
#> 2 725125194ec2e9e1ec104fb47726d9c9b416df7a "- Add cool function.\n"        FALSE
#> 3 307ee70a719493cf3247f0bab0803557b7a6a40f "Add NEWS.md to track changes.… FALSE
#> 4 2aa530b70b8a60b081987a784a3c7c911a82211f "First commit\n"                FALSE
#> # A tibble: 1 × 3
#>   name        ref                   commit                                  
#> * <chr>       <chr>                 <chr>                                   
#> 1 v0.0.0.9001 refs/tags/v0.0.0.9001 55770d584befb47d41bcbf132f657bc4a597c7b1
#> ✔ Setting active project to "<no active project>".
```
