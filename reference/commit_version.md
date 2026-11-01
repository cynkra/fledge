# Commits NEWS.md and DESCRIPTION to Git

Commits changes to `NEWS.md` and `DESCRIPTION`, amending a previous
commit created by fledge if necessary.

## Usage

``` r
commit_version()
```

## Value

Invisibly: `TRUE` if a previous commit for that version has been
amended, `FALSE` if not.

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
  desc::desc_add_author(given = "Jane", family = "Doe", role = "ctb")
  fledge::commit_version()
})
#> ✔ Setting active project to "/tmp/Rtmpqw2oTM/fledge21a27ffb8abf/tea".
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
#> ✔ Setting active project to "<no active project>".
```
