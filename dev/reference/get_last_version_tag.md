# The most recent versioned tag

Returns the Git tag of the form vx.y, vx.y.z or vx.y.z.w with the latest
version. An older version of this logic is used in
[`get_last_tag()`](https://fledge.cynkra.com/dev/reference/get_last_tag.md),
which traverses the Git history but does not work with squash-merging of
version bumps.

## Usage

``` r
get_last_version_tag()
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
  # Switch to branch for bumping version.
  gert::git_branch_create("fledge")
  # Bump version with fledge.
  fledge::bump_version(check_default_branch = FALSE)
  fledge::finalize_version()

  # Merge the version bump branch into main.
  gert::git_branch_checkout("main")
  gert::git_merge("fledge", squash = TRUE)

  print(get_top_level_commits(since = NULL))

  # get_last_tag() doesn't work in this scenario
  print(fledge::get_last_tag())

  # get_last_version_tag() is better
  print(fledge::get_last_version_tag())
})
#> ✔ Setting active project to "/tmp/RtmpdH7w3F/fledge413b108632a4/tea".
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
#> Performing fast-forward merge, no commit needed
#> # A tibble: 4 × 3
#>   commit                                   message                         merge
#>   <chr>                                    <chr>                           <lgl>
#> 1 b97156181584927f3c31e377481c7bab8d2d1478 "fledge: Bump version to 0.0.0… FALSE
#> 2 621eedd774c04d1cb2d9d93c7716107842cf9f5d "- Add cool function.\n"        FALSE
#> 3 b473d8ea7fe4af7189a3f673e6a9efe36cee5395 "Add NEWS.md to track changes.… FALSE
#> 4 70e0d17ddfcfe6434e67c983b2c12586816baddc "First commit\n"                FALSE
#> # A tibble: 1 × 3
#>   name        ref                   commit                                  
#> * <chr>       <chr>                 <chr>                                   
#> 1 v0.0.0.9001 refs/tags/v0.0.0.9001 a37c515d45c8026006d0879840e58204369de7de
#> # A tibble: 1 × 3
#>   name        ref                   commit                                  
#>   <chr>       <chr>                 <chr>                                   
#> 1 v0.0.0.9001 refs/tags/v0.0.0.9001 a37c515d45c8026006d0879840e58204369de7de
#> ✔ Setting active project to "<no active project>".
```
