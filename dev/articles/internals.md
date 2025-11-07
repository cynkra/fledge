# Fledge internals

``` r
library(fledge)
```

## Implementation

The following sections explain how things actually work inside fledge.

### Updating `NEWS.md`

New entries are added to `NEWS.md` from commit messages to commits in
`master`.

- Only top-level commits are considered (roughly equivalent to
  `git log --first-parent`.) The messages from these commits are parsed.
  Only lines that start with a star `*` or a dash `-` are included.

- If a line starts with three dashes, then everything past that line is
  excluded. Example: the following commit message

      Merge f-fancy-feature to master, closes #5678

      - Added fancy feature (#5678).

      - Fixed bug as a side effect (#9012).

      ---

      The fancy feature consists of the components:

      - foo
      - bar
      - baz

  will be added as below to `NEWS.md`:

      - Added fancy feature (#5678).
      - Fixed bug as a side effect (#9012).

When retrieving the current NEWS for defining the tag message, the
entries between the first two first-level headers (starting with `#`)
are returned. You can use second and third level headers and add as many
empty lines as you want.

### Collecting NEWS

The first function to call at any stage is always
[`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md).
This does the following

1.  Calls
    [`update_news()`](https://fledge.cynkra.com/dev/reference/update_news.md)
    to collect NEWS entries from top-level commits and to increment the
    version in `DESCRIPTION` and add a header to `NEWS.md`.

### Tagging for “dev” vs. other releases

[`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
continues depending on the release type:

- `"dev"` releases: Calls
  [`finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md)
  to commit `DESCRIPTION` and `NEWS.md`. Also creates a tag with a
  message. You can always edit `NEWS.md` and call
  [`finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md)
  again. Both the commit and the tag will be updated.
- Other releases: Calls
  [`commit_version()`](https://fledge.cynkra.com/dev/reference/commit_version.md)
  to commit `DESCRIPTION` and `NEWS.md` without tagging. In this stage,
  you can edit `NEWS.md` and commit as much as you like. The tag is
  created only after you use
  [`tag_version()`](https://fledge.cynkra.com/dev/reference/tag_version.md)
  manually.
