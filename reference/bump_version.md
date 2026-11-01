# Bump package version

Calls the following functions:

1.  Verify that the current branch is the main branch.

2.  [`update_news()`](https://fledge.cynkra.com/reference/update_news.md)

3.  [`update_version()`](https://fledge.cynkra.com/reference/update_version.md),
    using the `which` argument

4.  Depending on the `which` argument:

    - If `"dev"`,
      [`finalize_version()`](https://fledge.cynkra.com/reference/finalize_version.md)
      with `push = FALSE`

    - Otherwise,
      [`commit_version()`](https://fledge.cynkra.com/reference/commit_version.md).

## Usage

``` r
bump_version(which = "dev")
```

## Arguments

- which:

  Component of the version number to update. Supported values are
  `"dev"` (default), `"patch"`, `"minor"` and `"major"`.

## Value

None

## Bumped too soon?

Have you just run `bump_version()`, then realized "oh shoot, I forgot to
merge that PR"? Fear not, run
[`unbump_version()`](https://fledge.cynkra.com/reference/unbump_version.md),
merge that PR, run `bump_version()`.

## See also

[`unbump_version()`](https://fledge.cynkra.com/reference/unbump_version.md)

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
})
#> ✔ Setting active project to "/tmp/Rtmpqw2oTM/fledge21a279f941f1/tea".
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
#> ✔ Setting active project to "<no active project>".
#> NULL
```
