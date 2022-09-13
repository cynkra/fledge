<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# fledge 0.1.0.9005 (2022-09-13)

- Internal changes only.


# fledge 0.1.0.9004 (2022-09-12)

- Internal changes only.


# fledge 0.1.0.9003 (2022-09-12)

## Bug fixes

- Adjust empty lines and space in update_news() (#357)

- Add PR number to CC messages (#353).

- Fix conventional commit regex (#329)

## Features

- New default `pre_release(which = "next")` (#521, #524).

- Add which "pre-minor" and "pre-major" to update_version() (#413, #412).

- Include reference to issue closed with a PR (#361, #411).

- Capitalize first letter of each bullet (#360, #409).

- Extract contributor name from PR merge message (@krlmlr, #358)

- Harvest PR attribution from squash commits (@maelle, #349)

- Harvest PR title from merge commit messages (@krlmlr, @maelle, #343)

- Improve parsing of conventional commit messages (#332).

- Improve bump_version() (error) messages (@maelle, #328)

- Improve bump_version() behavior in the absence of changes (@krlmlr, @maelle, #323)

- New `local_test_project()` (#318)

- Extract conventional commit messages for the changelog (#314).

## Chore

- Turn Netlify builds off for now (#326).

- Enable auto-style on GitHub Actions (#317).

- Remove testthat specialization for snapshots (#309).

## Continuous integration

- Create fledge.yaml (#520).

## Documentation

- Add README section on related tools (#527).

- Update summary of how fledge uses commit messages (#499, #511).

- Fix typo in README (#501)

## Uncategorized

- Create and open draft release directly, without using `usethis::use_github_release()`.

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
