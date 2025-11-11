# Finalize package version

Calls the following functions:

1.  [`commit_version()`](https://fledge.cynkra.com/dev/reference/commit_version.md)

2.  [`tag_version()`](https://fledge.cynkra.com/dev/reference/tag_version.md)
    with `force = TRUE`

3.  Force-pushes the created tag to the `"origin"` remote, if
    `push = TRUE`.

## Usage

``` r
finalize_version(push = FALSE)
```

## Arguments

- push:

  If `TRUE`, push the created tag.

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
  # Edit news by hand
  # ...
  # Once done
  fledge::finalize_version()
})
#> ✔ Setting active project to "/tmp/Rtmp9N1pvK/fledge4978475b805d/tea".
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
#> ✔ Setting active project to "<no active project>".
```
