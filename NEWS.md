# fledge 0.0.0.9001 (2018-03-29)

- If the `DESCRIPTION` has a `"Date"` field, it is populated with the current date in `update_version()`.
- An empty list of changes doesn't raise an error anymore. This will allow bumping to a dev version immediately after CRAN release.


# fledge 0.0.0.9000 (2018-03-29)

Initial release.

The main entry point is `bump_version()`, which does the following:

1.  `update_news()`: collects `NEWS` entries from top-level commits
2.  `update_version()`: bump version in `DESCRIPTION`, add header to `NEWS.md`
3.  `tag_version()`: commit `DESCRIPTION` and `NEWS.md`, create tag with message

If you haven't committed since updating `NEWS.md` and `DESCRIPTION`, you can also edit `NEWS.md` and call `tag_version()` again. Both the commit and the tag will be updated.

Also includes helper functions `get_last_tag` and `get_top_level_commits`.
