<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# fledge 0.1.3 (2025-11-30)

Maintenance release.


# fledge 0.1.3 (2025-10-16)

Maintenance release.


# fledge 0.1.2 (2024-02-18)

## Features

- Remove enc dependency.


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
