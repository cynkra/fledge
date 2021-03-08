<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# fledge 0.0.3.9007

- Add Patrick Schratz (@pat-s) a contributor (#50).
- Use GitHub Actions (#49).
- Dates are added to NEWS headers if existing headers have them, or for a new NEWS file (#29).
- Move from `ui_*` to {cli} (#54)


# fledge 0.0.3.9006

- `bump_version()` and `get_top_level_commits()` are more robust at enumerating the commits: traversing the first parent from which `since` can be reached, instead of the first parent. This ensures that NEWS are more meaningful and avoids the occasional enumeration of all NEWS items since the beginning.


# fledge 0.0.3.9005

- Same as previous version.


# fledge 0.0.3.9004

- Same as previous version.


# fledge 0.0.3.9003

- Same as previous version.


# fledge 0.0.3.9002

- `finalize_version(push = TRUE)` also pushes to master.
- `finalize_version()` calls `edit_news()`.
- Tweak demo.
- `finalize_version()` sends `finalize_version(push = TRUE)` to the RStudio console.


# fledge 0.0.3.9001

- `finalize_version()` gains `push` argument, this considerably simplifies the workflow.
- Prefer `ui_done()` over `ui_info()` to report on action taken.
- `tag_version()` returns name of created tag, invisibly.
- `tag_version(force = FALSE)` re-tags an existing tag if it points to the same commit.
- Import rlang.


# fledge 0.0.3.9000

- Same as previous version.


# fledge 0.0.3

- Check that `DESCRIPTION` and `NEWS.md` are clean before bumping (#10).
- Add demo vignette (#19, @kaslee).
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
