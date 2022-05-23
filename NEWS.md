<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

## Bug fixes 

- Fix conventional commit regex (#329)



## Features 

- Improve parsing of conventional commit messages

- improve bump_version() (error) messages (#328)

Co-authored-by: maelle <maelle@users.noreply.github.com>

- Improve bump_version() behavior in the absence of changes (#323)

Co-authored-by: Kirill Müller <krlmlr@users.noreply.github.com>
Co-authored-by: maelle <maelle@users.noreply.github.com>

- New `local_test_project()` (#318)

- Extract conventional commit messages for the changelog



## Chore 

- Turn Netlify builds off for now

- Enable auto-style on GitHub Actions

- Remove testthat specialization for snapshots



## Uncategorized 

- Simplify test (#310)

- Parallel tests (#312)

- Snapshot updates for R-CMD-check-dev ({"package":"testthat"}) (#271)

- typo fix (#306)

- Snapshot updates for rcc-smoke (null) (#272)

- Snapshot updates for R-CMD-check-dev ({"package":"testthat"}) (#256)

- Create and open draft release directly, without using `usethis::use_github_release()`.

- Extract functions (#257)

- Create tag as part of `release()`.

- Fix `post_release()`, still need to tag released version.


# fledge 0.1.0.9002 (2022-04-02)

- `release()` no longer asks for confirmation.
- Inline `devtools::submit_cran()` minus the confirmation messages.


# fledge 0.1.0.9001 (2022-02-22)

- New `pre_release()`, `release()` and `post_release()` for semi-automatic CRAN releases (#27, #28).
- Separate snapshot tests for dev version of testthat.


# fledge 0.1.0.9000 (2021-12-07)

- Same as previous version.


# fledge 0.1.0 (2021-12-07)

Change log management utility, initial release.

The main entry point is `bump_version()`, which does the following:

1.  Checks that `DESCRIPTION` and `NEWS.md` are clean before bumping, and that the current branch is the main branch.
2.  `update_news()`: collects `NEWS` entries from top-level commits
3.  `update_version()`: bump version in `DESCRIPTION`, add header to `NEWS.md`
4.  Depending on the kind of update:
    - If "dev", `finalize_version()`: commit `DESCRIPTION` and `NEWS.md`, create tag with message
    - Otherwise, `commit_version()`; the user needs to call `tag_version()` manually
5.  Suggests to push the changes if an upstream repository is configured.

If you haven't committed since updating `NEWS.md` and `DESCRIPTION`, you can also edit `NEWS.md` and call `tag_version()` again.
Both the commit and the tag will be updated.

Bumping can be undone with `unbump_version()`.

If the `DESCRIPTION` has a `"Date"` field, it is populated with the current date in `update_version()`.
Likewise, if `NEWS.md` contains dates in the headers, new versions also get a date.

An empty list of changes adds a "Same as previous version" bullet.
This allows bumping to a dev version immediately after CRAN release.

Also includes helper functions `get_last_tag()` and `get_top_level_commits()`.

Includes vignettes: "Get started", "Using fledge", and "Fledge internals".
Examples and tests are supported with a demo project, created via `with_demo_project()`.

Thanks Patrick Schratz and Maëlle Salmon for your contributions!
