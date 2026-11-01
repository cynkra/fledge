# Changelog

## fledge 0.1.3 (2025-11-30)

CRAN release: 2025-10-16

Maintenance release.

## fledge 0.1.3 (2025-10-16)

CRAN release: 2025-10-16

Maintenance release.

## fledge 0.1.2 (2024-02-18)

CRAN release: 2024-02-18

### Features

- Remove enc dependency.

## fledge 0.1.1 (2023-06-16)

CRAN release: 2023-06-17

- Compatibility release for usethis 2.2.0.

## fledge 0.1.0 (2021-12-07)

CRAN release: 2021-12-07

Change log management utility, initial release.

The main entry point is
[`bump_version()`](https://fledge.cynkra.com/reference/bump_version.md),
which does the following:

1.  Checks that `DESCRIPTION` and `NEWS.md` are clean before bumping,
    and that the current branch is the main branch.
2.  [`update_news()`](https://fledge.cynkra.com/reference/update_news.md):
    collects `NEWS` entries from top-level commits
3.  [`update_version()`](https://fledge.cynkra.com/reference/update_version.md):
    bump version in `DESCRIPTION`, add header to `NEWS.md`
4.  Depending on the kind of update:
    - If “dev”,
      [`finalize_version()`](https://fledge.cynkra.com/reference/finalize_version.md):
      commit `DESCRIPTION` and `NEWS.md`, create tag with message
    - Otherwise,
      [`commit_version()`](https://fledge.cynkra.com/reference/commit_version.md);
      the user needs to call
      [`tag_version()`](https://fledge.cynkra.com/reference/tag_version.md)
      manually
5.  Suggests to push the changes if an upstream repository is
    configured.

If you haven’t committed since updating `NEWS.md` and `DESCRIPTION`, you
can also edit `NEWS.md` and call
[`tag_version()`](https://fledge.cynkra.com/reference/tag_version.md)
again. Both the commit and the tag will be updated.

Bumping can be undone with
[`unbump_version()`](https://fledge.cynkra.com/reference/unbump_version.md).

If the `DESCRIPTION` has a `"Date"` field, it is populated with the
current date in
[`update_version()`](https://fledge.cynkra.com/reference/update_version.md).
Likewise, if `NEWS.md` contains dates in the headers, new versions also
get a date.

An empty list of changes adds a “Same as previous version” bullet. This
allows bumping to a dev version immediately after CRAN release.

Also includes helper functions
[`get_last_tag()`](https://fledge.cynkra.com/reference/get_last_tag.md)
and
[`get_top_level_commits()`](https://fledge.cynkra.com/reference/get_top_level_commits.md).

Includes vignettes: “Get started”, “Using fledge”, and “Fledge
internals”. Examples and tests are supported with a demo project,
created via
[`with_demo_project()`](https://fledge.cynkra.com/reference/with_demo_project.md).

Thanks Patrick Schratz and Maëlle Salmon for your contributions!
