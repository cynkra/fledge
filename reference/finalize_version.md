# Finalize package version

Calls the following functions:

1.  [`commit_version()`](https://fledge.cynkra.com/reference/commit_version.md)

2.  [`tag_version()`](https://fledge.cynkra.com/reference/tag_version.md),
    setting `force = TRUE` if and only if
    [`commit_version()`](https://fledge.cynkra.com/reference/commit_version.md)
    amended a commit.

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
#> ✔ Setting active project to "/tmp/Rtmpqw2oTM/fledge21a26b94cec1/tea".
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
#> ✔ Setting active project to "<no active project>".
```
