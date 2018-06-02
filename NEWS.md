# fledge 0.0.0.9006

- Fix compatibility with dev version of _git2r_.


# fledge 0.0.0.9005

- Don't write date in NEWS header: It can be found out with "blame" and conflicts with the rendering in pkgdown.


# fledge 0.0.0.9004

- Only `"dev"` releases are tagged automatically. For other releases (which usually go to CRAN), it is recommended to postpone tagging until the version is accepted on CRAN (#4).
- Add documentation for `which` argument.


# fledge 0.0.0.9003

- When writing the tag, print most recent NEWS.
- Commits from bumping to an earlier version are no longer overwritten.


# fledge 0.0.0.9002

- Bumping the version without changing the code results a the `NEWS.md` entry that reads "Same as previous version".
- Renamed `tag_version()` to `finalize_version()`, which calls the new `commit_version()` and `tag_version(force)` functions.
- New `commit_version()` that only creates a commit, amending as necessary.
- New `tag_version()` only creates a tag, overwrites an existing tag only with `force = TRUE`.
- When enumerating tags, all tags without message are ignored.


# fledge 0.0.0.9001

- If the `DESCRIPTION` has a `"Date"` field, it is populated with the current date in `update_version()`.
- An empty list of changes doesn't raise an error anymore. This will allow bumping to a dev version immediately after CRAN release.


# fledge 0.0.0.9000

Initial release.

The main entry point is `bump_version()`, which does the following:

1.  `update_news()`: collects `NEWS` entries from top-level commits
2.  `update_version()`: bump version in `DESCRIPTION`, add header to `NEWS.md`
3.  `tag_version()`: commit `DESCRIPTION` and `NEWS.md`, create tag with message

If you haven't committed since updating `NEWS.md` and `DESCRIPTION`, you can also edit `NEWS.md` and call `tag_version()` again. Both the commit and the tag will be updated.

Also includes helper functions `get_last_tag` and `get_top_level_commits`.
