<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# fledge 0.1.0.9029 (2022-12-30)

- Internal changes only.


# fledge 0.1.0.9028 (2022-12-22)

- Internal changes only.


# fledge 0.1.0.9027 (2022-12-09)

- Internal changes only.


# fledge 0.1.0.9026 (2022-12-06)

## Features

- Support for linked issues from other repositories (#595).


# fledge 0.1.0.9025 (2022-11-19)

## Documentation

- Typo.


# fledge 0.1.0.9024 (2022-11-12)

- Internal changes only.


# fledge 0.1.0.9023 (2022-11-11)

## Bug fixes

- Remove partial matching warning (#579).

## Features

- Draft fledgeling object, ready for internal use (#581).

- Add full stop to messages (#578).

## Chore

- Store downlit info (#580).

## Documentation

- Cynkratemplate::use_cynkra_pkgdown() + re-add comment (@krlmlr, @41898282+github-actions-bot, @maelle, #568).

## Uncategorized

- Split news (#584).


# fledge 0.1.0.9022 (2022-11-10)

## Bug fixes

- Add full stop for entries


# fledge 0.1.0.9021 (2022-11-09)

- Internal changes only.


# fledge 0.1.0.9020 (2022-11-03)

- Snapshot updates for R-CMD-check-base (null) (#570)


# fledge 0.1.0.9019 (2022-10-28)

- Internal changes only.


# fledge 0.1.0.9018 (2022-10-26)

## Documentation

- Fix URL (#573)


# fledge 0.1.0.9017 (2022-10-24)

## Bug fixes

- Relax requirement for GitHub PAT scope (#572)


# fledge 0.1.0.9016 (2022-10-20)

- Internal changes only.


# fledge 0.1.0.9015 (2022-10-19)

- Internal changes only.


# fledge 0.1.0.9014 (2022-10-18)

- Harmonize yaml formatting

- Revert changes to matrix section


# fledge 0.1.0.9013 (2022-10-16)

- Internal changes only.


# fledge 0.1.0.9012 (2022-10-14)

- Internal changes only.


# fledge 0.1.0.9011 (2022-10-11)

- Internal changes only.


# fledge 0.1.0.9010 (2022-09-20)

## Features

- `bump_version()` returns `TRUE` if a new version has been created


# fledge 0.1.0.9009 (2022-09-20)

## Features

- Better support for merge commits of all kinds (@maelle, #512)

## Uncategorized

- Internal changes only.


# fledge 0.1.0.9008 (2022-09-18)

## Features

- Better support for merge commits of all kinds (@maelle, #512)

## Uncategorized

- Internal changes only.


# fledge 0.1.0.9007 (2022-09-16)

## Features

- Better support for merge commits of all kinds (@maelle, #512)

## Uncategorized

- Internal changes only.


# fledge 0.1.0.9006 (2022-09-14)

## Features

- Better support for merge commits of all kinds (@maelle, #512)

## Uncategorized

- Internal changes only.


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

