# Bump package version

Calls the following functions:

1.  Verify that the current branch is the main branch if
    `check_default_branch = TRUE` (the default).

2.  [`update_news()`](https://fledge.cynkra.com/dev/reference/update_news.md),
    using the `which` argument, applying logic to determine if
    meaningful changes have been made since the last version.

3.  From the result, check if there were meaningful changes since the
    last version.

4.  Depending on the `which` argument:

    - If `"dev"`,
      [`finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md)
      with `push = FALSE`

    - Otherwise,
      [`commit_version()`](https://fledge.cynkra.com/dev/reference/commit_version.md).

## Usage

``` r
bump_version(
  which = c("dev", "pre-patch", "patch", "pre-minor", "minor", "pre-major", "major"),
  ...,
  no_change_behavior = c("bump", "noop", "fail"),
  check_default_branch = TRUE
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

- ...:

  These dots are for future extensions and must be empty.

- no_change_behavior:

  What to do if there was no change since the last version: `"bump"` for
  bump the version; `"noop"` for do nothing; `"fail"` for erroring.

- check_default_branch:

  Whether to check that the current branch is the default branch.

## Value

`TRUE` if `NEWS.md` and `DESCRIPTION` have been updated, `FALSE`
otherwise. Do not rely on this behavior.

## Bumped too soon?

Have you just run `bump_version()`, then realized "oh shoot, I forgot to
merge that PR"? Fear not, run
[`unbump_version()`](https://fledge.cynkra.com/dev/reference/unbump_version.md),
merge that PR, run `bump_version()`.

## See also

[`unbump_version()`](https://fledge.cynkra.com/dev/reference/unbump_version.md)

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
#> ✔ Setting active project to "/tmp/RtmpdH7w3F/fledge413b31caf40c/tea".
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
#> ✔ Setting active project to "<no active project>".
```
