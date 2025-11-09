# The most recent tag

Returns the most recent Git tag that is reachable from the current
branch. This will not be accurate if the version bump and tag has
occurred on a branch which has been squashed into the main branch. See
[`get_last_version_tag()`](https://fledge.cynkra.com/dev/reference/get_last_version_tag.md)
for a version that works in this scenario.

## Usage

``` r
get_last_tag()
```

## Value

A one-row tibble with columns `name`, `ref` and `commit`. For annotated
tags (as created by fledge), `commit` may be different from the SHA of
the commit that this tag points to. Use
[`gert::git_log()`](https://docs.ropensci.org/gert/reference/git_commit.html)
to find the actual commit.

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
#> ✔ Setting active project to "/tmp/RtmpwaWKo7/fledge48e0bf8e52/tea".
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
#> 1 29209fbdeab475dc3d7da6f17eb45a92e3774e98 "fledge: Bump version to 0.0.0… FALSE
#> 2 7b5c6661df04ca2cfea743303b53e7c199bab600 "- Add cool function.\n"        FALSE
#> 3 b473d8ea7fe4af7189a3f673e6a9efe36cee5395 "Add NEWS.md to track changes.… FALSE
#> 4 70e0d17ddfcfe6434e67c983b2c12586816baddc "First commit\n"                FALSE
#> # A tibble: 1 × 3
#>   name        ref                   commit                                  
#> * <chr>       <chr>                 <chr>                                   
#> 1 v0.0.0.9001 refs/tags/v0.0.0.9001 1a5b6d0c9cf058deda2c625ab77c85d1d2d08f74
#> ✔ Setting active project to "<no active project>".
```
