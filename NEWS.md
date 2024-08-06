<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# fledge 0.1.99.9025 (2024-08-06)

## Continuous integration

- Inline action.


# fledge 0.1.99.9024 (2024-08-03)

## Testing

- Snapshot updates for R-CMD-check-base (null) (#783).


# fledge 0.1.99.9023 (2024-08-02)

## Continuous integration

- Use dev roxygen2 and decor.

## Testing

- Accept snapshots after knitr update.


# fledge 0.1.99.9022 (2024-07-02)

## Continuous integration

- Fix on Windows, tweak lock workflow.


# fledge 0.1.99.9021 (2024-06-30)

## Chore

- Auto-update from GitHub Actions.

  Run: https://github.com/cynkra/fledge/actions/runs/9727971994


# fledge 0.1.99.9020 (2024-06-28)

## Chore

- Auto-update from GitHub Actions.

  Run: https://github.com/cynkra/fledge/actions/runs/9691617690

## Continuous integration

- Avoid checking bashisms on Windows.

- Remove netlify workflow.

- Remove special branch.

- Bump versions, better default, consume custom matrix.

- Recent updates.


# fledge 0.1.99.9019 (2024-06-26)

## Bug fixes

- Update bump-version.R - replace length test in get_main_branch_config() (#775).


# fledge 0.1.99.9018 (2024-04-16)

## Documentation

- Set BS version explicitly for now.

  https://github.com/cynkra/cynkratemplate/issues/53


# fledge 0.1.99.9017 (2024-02-19)

## Chore

- Move responsibility for writing fledgeling, memoise, add `repo` argument (#761).


# fledge 0.1.99.9016 (2024-01-24)

- Internal changes only.


# fledge 0.1.99.9015 (2024-01-15)

## Chore

- Work around r-lib/roxygen2#1570.


# fledge 0.1.99.9014 (2023-12-22)

## Bug fixes

- Create releases with correct body (#756).

## Chore

- Add Aviator configuration.


# fledge 0.1.99.9013 (2023-11-09)

## Bug fixes

- `create_github_release()` removes the header from the NEWS entry.


# fledge 0.1.99.9012 (2023-11-07)

## Features

- Do not report installation size problems (#755).


# fledge 0.1.99.9011 (2023-11-05)

## Features

- `post_release()` no longer checks if on release branch (#750).

## Chore

- Use `news_path()` (#751).


# fledge 0.1.99.9010 (2023-11-03)

## Features

- Allow bumping straight from released version (#747).

- `post_release()` is independent from release branch (#748).

## Chore

- Add aviator configuration.


# fledge 0.1.99.9009 (2023-10-28)

## Features

- Release package as soon as it's available on PPM.


# fledge 0.1.99.9008 (2023-10-23)

## Features

- New `init_release()`, to be called before `pre_release()` (#686).


# fledge 0.1.99.9007 (2023-10-21)

## Features

- Automatically merge news from dev versions before release (#744).

- More extensive preflight checks in `post_release()`, reduce output in quiet mode (#740).

## Testing

- Basic testing scripts (#742).


# fledge 0.1.99.9006 (2023-10-19)

## Bug fixes

- Extract error from first submission step, fix CRAN submission (#738).

- Check if release exists before creating (#731).

## Chore

- Add `version` and `ref` arguments to `create_release_branch()`, fix `create_release_branch(force = TRUE)` (#734).

- `no_change()` and other functions gain ref argument (#733).

- Pretty `check_only_modified()` (#705).

- Refactorings for #686 (#729).

## Testing

- Is this how we handle NoSuggests checks 😅 (#732).


# fledge 0.1.99.9005 (2023-10-09)

- Internal changes only.


# fledge 0.1.99.9004 (2023-10-03)

## Chore

- More efficient data frame access (#706).

## Refactoring

- Replace httr with httr2 (#712).

## tests

- Clean up, simplify tests (#716).

- Add a function to help run the tests without losing one's current dir (#715).


# fledge 0.1.99.9003 (2023-09-26)

## Testing

- Add a test for upper case conventional commit type (#711).


# fledge 0.1.99.9002 (2023-07-11)

- Internal changes only.


# fledge 0.1.99.9001 (2023-06-22)

## Bug fixes

- Ask fledgeling for version.

- Bad merge conflict resolution from v0.1.1.

## Features

- Indent multiline NEWS items.

- More skip_if_offline() calls.

- Type stability of fledgeling object.

## Chore

- Avoid useless computation.

## Testing

- Prefer `local_options(repos = NULL)` over `skip_if_offline()`.

- Test order.

## Uncategorized

- Merge branch 'cran-0.1.1'.


# fledge 0.1.99.9000 (2023-06-21)

- Merge branch 'cran-0.1.1'.


# fledge 0.1.0.9047 (2023-06-16)

## Bug fixes

- Guess_next() works as expected for *.99.* versions.


# fledge 0.1.0.9046 (2023-06-13)

## Bug fixes

- Suppress clipr warnings.

## Features

- More flexible version extraction from release PR title (#678).


# fledge 0.1.0.9045 (2023-06-09)

## Bug fixes

- Adapt to new behavior of usethis::use_news_md() (#680).

## Chore

- Clean version header parsing (#610).


# fledge 0.1.0.9044 (2023-06-06)

## Chore

- Tell it what to merge.


# fledge 0.1.0.9043 (2023-06-01)

## Bug fixes

- `post_release()` works if the release branch doesn't change files in the main branch.


# fledge 0.1.0.9042 (2023-05-28)

## Bug fixes

- Better error message when duplicate version name (#673).

## Testing

- Snapshot updates for rcc-smoke (null) (#677).


# fledge 0.1.0.9041 (2023-04-18)

## Refactoring

- Slightly simplify pre_release() (#669).


# fledge 0.1.0.9040 (2023-04-13)

## Features

- `bump_version()` only works in interactive sessions or if `NEWS.md` has a preamble (or both) (#638).


# fledge 0.1.0.9039 (2023-04-04)

## Bug fixes

- Use pkg version from open PR, not from CRAN page (#662).

## Testing

- Snapshot updates for rcc-smoke (null) (#660).

- Snapshot updates for rcc-smoke (null) (#647).

- Fix snapshots after updates of upstream dependencies (#657).


# fledge 0.1.0.9038 (2023-03-28)

- Internal changes only.


# fledge 0.1.0.9037 (2023-03-24)

## Features

- Do not write "Same as previous version" as first thing in a brand-new changelog (#655).

- New internal `release_after_cran_built_binaries()` to support automated CRAN release from GHA (#651).

## Documentation

- Update pitch (#656).


# fledge 0.1.0.9036 (2023-03-21)

## Features

- Add ability to parse two-line headers (#654).

## Refactoring

- Use the full power of {cli} (#640).


# fledge 0.1.0.9035 (2023-03-15)

## Features

- Add special CRAN release label to release PRs (#649).


# fledge 0.1.0.9034 (2023-03-08)

## tests

- Replace httptest with httptest2 as gh now uses httr2 instead of httr (#646).


# fledge 0.1.0.9033 (2023-02-17)

- Internal changes only.


# fledge 0.1.0.9032 (2023-02-12)

## Bug fixes

- Bump to dev version in `pre_release()`.


# fledge 0.1.0.9031 (2023-02-09)

## Refactoring

- Update fledge URL in NEWS preamble (#622).


# fledge 0.1.0.9030 (2023-02-05)

## Bug fixes

- Work around unexplicable behavior in demo tests.

- Remove push trigger in `fledge.yaml`, seems broken.

- `bump_version()` keeps updating `Date` field if it exists in `DESCRIPTION`.

## Features

- `post_release()` pulls the main branch before merging (#525).

Closes #525.

- New mode of operation `"samedev"`, for #147.

- `update_news()` gains which argument, deprecate `update_version()` (#607).

## Chore

- Move packages from Imports to Suggests.

- Add extra snapshot.

- Clean up snapshots.

- `usethis::use_lifecycle()`.

- Prepare roundtrip via fledgeling (#606).

- Move foghorn and rversions to Suggests (#605).

- Run fledge workflow only on main branch (#597).

## Continuous integration

- Add test prefix to snapshot updates PR template (#582).

## Refactoring

- Use `write_fledgling()` to write `NEWS.md` (#588).

## Uncategorized

- Remove false Markdown link? (#592).


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


# fledge 0.1.1 (2023-06-16)

- Compatibility release for usethis 2.2.0.

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
