<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# fledge 0.0.5.9005

- `finalize_version()` force-pushes the tag if `push = TRUE` (#181).
- More tests (#168, #5).
- `tag_version(force = FALSE)` succeeds if tag points to latest commit (#167).
- New `fledge.quiet` option (#117).
- Document working with a remote in demo vignette (#164, @maelle).
- New `with_demo_project()` to support examples for all functions (#162, @maelle).
- Fix corner case with empty `NEWS.md` (#150, @maelle).


# fledge 0.0.5.9004

- Better error messages (#111, @maelle).
- Update README (#139, @maelle).
- Add pitch (#128, @maelle).
- `unbump_version()` gains documentation, examples, and tests (#12, @maelle).
- New `create_demo_project()` (#102, @maelle).
- Reorganized `vignette("demo")`, added examples (#113, @maelle).


# fledge 0.0.5.9003

- `get_last_tag()` returns a tibble.


# fledge 0.0.5.9002

- Fix `unbump_version()`.
- `update_news()` uses a `NULL` default instead of a complex expression. The `range` argument is removed.
- `get_last_tag()` gains an explanation regarding annotated tags.


# fledge 0.0.5.9001

- `bump_version()` fails if the current branch is not the main branch (#78).
- Ignore empty commit messages.


# fledge 0.0.5.9000

- Same as previous version.


# fledge 0.0.5

- Use {gert} instead of {git2r} for interacting with Git (#57).
- The API no longer accepts or returns git2r objects (#77).
- `vignette("demo")` now shows the same results with each run (#70).


# fledge 0.0.4

## Features

- Prepend NEWS comment to discourage edits.
- Dates are added to NEWS headers if existing headers have them, or for a new NEWS file (#29).
- `finalize_version()` gains `push` argument which pushes the tag and the main branch, this considerably simplifies the workflow. It calls `edit_news()` and sends `finalize_version(push = TRUE)` to the RStudio or VS Code console.
- `tag_version()` returns name of created tag, invisibly.
- `tag_version(force = FALSE)` re-tags an existing tag if it points to the same commit.

## Bug fixes

- `bump_version()` gives correct advice if no remote branch exists.
- `bump_version()` and `get_top_level_commits()` are more robust at enumerating the commits: traversing the first parent from which `since` can be reached, instead of the first parent. This ensures that NEWS are more meaningful and avoids the occasional enumeration of all NEWS items since the beginning.

## Internal

- Add Patrick Schratz (@pat-s) a contributor (#50).
- Use GitHub Actions (#49).
- Move from `ui_*` to {cli} (#54)
- Import rlang.


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
