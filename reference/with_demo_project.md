# Run code in temporary project

Run code in temporary project

## Usage

``` r
with_demo_project(code, dir = NULL, news = TRUE, quiet = FALSE)
```

## Arguments

- code:

  Code to run with temporary active project

- dir:

  Directory within which to create the mock package folder.

- news:

  If TRUE, create a NEWS.md file.

- quiet:

  Whether to show messages from usethis

## Value

None

## Examples

``` r
with_demo_project({
  # Add a new R file.
  usethis::use_r("cool-function", open = FALSE)
  # Pretend we added useful code inside it.
  # Track the new R file with Git.
  gert::git_add("R/cool-function.R")
  gert::git_commit("- Add cool function.")
  # Bump version with fledge.
  fledge::bump_version()
})
#> ✔ Setting active project to "/tmp/Rtmpqw2oTM/fledge21a21b2c42cc/tea".
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
