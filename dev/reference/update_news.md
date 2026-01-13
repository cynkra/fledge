# Update NEWS.md with messages from top-level commits

Lists all commits from a range (default: top-level commits since the
most recent tag as determined by
[`get_last_version_tag()`](https://fledge.cynkra.com/dev/reference/get_last_version_tag.md))
and adds bullets from their body to `NEWS.md`. Creates `NEWS.md` if
necessary.

## Usage

``` r
update_news(
  messages = NULL,
  which = c("auto", "samedev", "dev", "pre-patch", "patch", "pre-minor", "minor",
    "pre-major", "major")
)
```

## Arguments

- messages:

  A character vector of commit messages, e.g. as in the `message` column
  in the return value of
  [`get_top_level_commits()`](https://fledge.cynkra.com/dev/reference/get_top_level_commits.md).
  The default uses the top level commits since the last tag as retrieved
  by
  [`get_last_version_tag()`](https://fledge.cynkra.com/dev/reference/get_last_version_tag.md).

- which:

  Component of the version number to update. Supported values are

  - `"auto"` (default: `"samedev"` or `"dev"`, depending on contents of
    `NEWS.md`),

  - `"samedev"` (a.b.c.900x with stable version),

  - `"dev"` (a.b.c.9xxx),

  - `"patch"` (a.b.x),

  - `"pre-minor"` (a.b.99.9000),

  - `"minor"` (a.x.0),

  - `"pre-major"` (a.99.99.9000),

  - `"major"` (x.0.0).

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
  fledge::update_news(c("- something I forgot", "- blabla"), which = "patch")
  gert::git_add("NEWS.md")
  gert::git_commit(message = "release notes tweaking")
  fledge::tag_version()
  print(fledge::get_last_version_tag())
})
#> ✔ Setting active project to "/tmp/Rtmp3sOkBQ/fledge42db1d2df1d5/tea".
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
#> → Digesting messages from 2 commits.
#> ✔ Found 2 NEWS-worthy entries.
#> 
#> ── Updating NEWS ──
#> 
#> → Adding new entries to NEWS.md.
#> 
#> ── Updating Version ──
#> 
#> ✔ Package version bumped to 0.0.1.
#> → Added header to NEWS.md.
#> 
#> ── Tagging Version ──
#> 
#> → Creating tag v0.0.1 with tag message derived from NEWS.md.
#> # A tibble: 1 × 3
#>   name   ref              commit                                  
#>   <chr>  <chr>            <chr>                                   
#> 1 v0.0.1 refs/tags/v0.0.1 27b0f37a288fcfaa7104fc35c69d105cf38fd66a
#> ✔ Setting active project to "<no active project>".
```
