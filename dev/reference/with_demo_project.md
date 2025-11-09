# Run code in temporary project

Run code in temporary project

## Usage

``` r
with_demo_project(code, dir = NULL, news = TRUE, quiet = FALSE)

local_demo_project(
  dir = NULL,
  news = TRUE,
  quiet = FALSE,
  .local_envir = parent.frame()
)
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

- .local_envir:

  The environment to use for scoping. Defaults to current execution
  environment.

## Value

`with_demo_project()` returns the result of evaluating `code`.

`local_demo_project()` is called for its side effect and returns `NULL`,
invisibly.

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
#> ✔ Setting active project to "/tmp/RtmpS2ivCk/fledge49632072139f/tea".
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
