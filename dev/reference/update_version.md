# Update NEWS.md and DESCRIPTION with a new version

**\[deprecated\]**

Deprecated, use
[`update_news()`](https://fledge.cynkra.com/dev/reference/update_news.md).

## Usage

``` r
update_version(
  which = c("auto", "samedev", "dev", "patch", "pre-minor", "minor", "pre-major",
    "major")
)
```

## Arguments

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
#> ✔ Setting active project to "/tmp/RtmpwaWKo7/fledge48e03ce55c74/tea".
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
#> 1 v0.0.1 refs/tags/v0.0.1 c829a90c6df858fd2ad1dc9d26ac11c7085e729d
#> ✔ Setting active project to "<no active project>".
```
