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
#> ✔ Setting active project to "/tmp/RtmpU13yU2/fledge42cf219e12ba/tea".
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
#> 1 db7567fe798dd0edc48c9af90f6aee157f30c919 "fledge: Bump version to 0.0.0… FALSE
#> 2 24a40087a4b485f49c2283181b90b478245ecca0 "- Add cool function.\n"        FALSE
#> 3 b473d8ea7fe4af7189a3f673e6a9efe36cee5395 "Add NEWS.md to track changes.… FALSE
#> 4 70e0d17ddfcfe6434e67c983b2c12586816baddc "First commit\n"                FALSE
#> # A tibble: 1 × 3
#>   name        ref                   commit                                  
#> * <chr>       <chr>                 <chr>                                   
#> 1 v0.0.0.9001 refs/tags/v0.0.0.9001 f6c46c6f0148bab32501b932ebca09b116f673ed
#> ✔ Setting active project to "<no active project>".
```
