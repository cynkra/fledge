# fledge 0.0.2.9000

- Convert `"\r\n"` to `"\n"` in Git messages, these can occur when merging a PR on GitHub.


# fledge 0.0.2

- New "Get started" article (#15).


# fledge 0.0.1.9001

- Test for manual tagging (#6).


# fledge 0.0.1.9000

- Use {enc} for safe writing of files, preserving line endings (#14).


# fledge 0.0.1

Change log management utility, initial release.

The main entry point is `bump_version()`, which does the following:

1.  `update_news()`: collects `NEWS` entries from top-level commits
2.  `update_version()`: bump version in `DESCRIPTION`, add header to `NEWS.md`
3.  Depending on the kind of update:
    - If "dev", `finalize_version()`: commit `DESCRIPTION` and `NEWS.md`, create tag with message
    - Otherwise, `commit_version()`; the user needs to call `tag_version()` manually

If you haven't committed since updating `NEWS.md` and `DESCRIPTION`, you can also edit `NEWS.md` and call `tag_version()` again.
Both the commit and the tag will be updated.

Bumping can be undone with `unbump_version()`.

If the `DESCRIPTION` has a `"Date"` field, it is populated with the current date in `update_version()`.

An empty list of changes adds a "Same as previous version" bullet.
This allows bumping to a dev version immediately after CRAN release.

Also includes helper functions `get_last_tag()` and `get_top_level_commits()`.
