# Get started with fledge

``` r
library(fledge)
```

Do you want to provide a changelog
([NEWS.md](https://blog.r-hub.io/2020/05/08/pkg-news/#why-write-the-changelog-as-newsmd))
more informative than “bug fixes and performance improvements”
(`https://twitter.com/EmilyKager/status/1413628436984188933`) to the
users of your package?

Ways to achieve that are:

- Update NEWS.md right before release by reading through commit
  messages. Not necessarily fun!

- Update the changelog in every commit e.g. in every PR. Now, if there
  are several feature PRs around that update the changelog, you’ll have
  a few clicks to make to tackle conflicts. Easy enough, but potentially
  annoying.

- Use fledge to

  - fill the `NEWS.md` for you based on informative commit messages,
  - (optionally) increase the version number in `DESCRIPTION`
    (e.g. useful in bug reports with session information!),
  - (optionally) create git tags (more coarse-grained history compared
    to top-level merges see [fledge tag list on
    GitHub](https://github.com/cynkra/fledge/tags)).

Using fledge is a discipline, a few habits, that are worth learning!

What you need to do in practice is, **no matter your fledge commitment
level**:

- For important commit messages you want recorded in the changelog, you
  can

  - Use the [conventional
    commits](https://www.conventionalcommits.org/en/v1.0.0/) syntax. For
    instance `feat: Enhanced support for time series`. Only using
    conventional commits syntax will provide automatic *grouping* of
    changelog items into groups (Documentation, Bug Fixes, etc.).

  - Add a hyphen `-` or `*` at the beginning of the commit message.
    Exclude housekeeping parts of the message by typing them after a
    line `---`.

  ``` text
  - Add support for bla databases.
  ```

  or

  ``` text
  - Add support for bla databases.

  ---

  Also tweak the CI workflow accordingly. :sweat_smile:
  ```

  - Use informative merge commit messages as those will also be included
    by default in the changelog. On GitHub you can [control the default
    commit message when merging a pull
    request](https://github.blog/changelog/2022-08-23-new-options-for-controlling-the-default-commit-message-when-merging-a-pull-request/).

  - (GitHub repositories only) For merge commits with the default not
    self-contained message (“Merge pull request…”), rely on fledge’s
    querying GitHub API to get the PR title and include it in the
    changelog.

For informative commit messages refer to the [Tidyverse style
guide](https://style.tidyverse.org/news.html).

Then, for **full fledge use = fledge-assisted management of NEWS.md,
DESCRIPTION version numbers, and git tags**:

- Run
  [`fledge::bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
  regularly e.g. before every coffee break or at the end of the day or
  of the week. If you forgot to merge one PR run
  [`fledge::unbump_version()`](https://fledge.cynkra.com/dev/reference/unbump_version.md),
  merge the PR with an informative squash commit message, then run
  [`fledge::bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
  and go drink that coffee!

- Run
  [`fledge::finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md)
  if you need to edit `NEWS.md` manually e.g. if you made a typo or are
  not happy with a phrasing in retrospect. Even if you edit a lot,
  what’s been written in by fledge is still a good place-holder.

- Follow the recommended steps at release (see
  [`vignette("fledge")`](https://fledge.cynkra.com/dev/articles/fledge.md)
  usage section).

OR, for **light fledge use = filling of NEWS.md between releases**:

- Have a development version header as produced by
  `usethis::use_development_version()`.

``` md
# mypackage (development version)
```

- Regularly run
  [`fledge::update_news()`](https://fledge.cynkra.com/dev/reference/update_news.md),
  preferentially on the main branch to avoid merge conflicts.

These habits are worth learning!

## Installation & setup

### Once per machine

Install from CRAN using:

``` r
install.packages("fledge")
```

Install from cynkra’s R-universe (development version) using:

``` r
install.packages("fledge", repos = c("https://cynkra.r-universe.dev", "https://cloud.r-project.org"))
```

Or install from GitHub (development version as well) using:

``` r
remotes::install_github("cynkra/fledge")
```

If you are used to making workflow packages
(e.g. [devtools](https://usethis.r-lib.org/articles/articles/usethis-setup.html#use-usethis-or-devtools-in-interactive-work))
available for all your interactive work, you might enjoy loading fledge
in your [.Rprofile](https://rstats.wtf/r-startup.html#rprofile).

### Once per package

- Your package needs to have a remote that indicates the default branch
  (e.g. GitHub remote) *or* to be using the same default branch name as
  your global/project `init.defaultbranch`.

- Add a mention of fledge usage in your contributing guide, as
  contributors might not know about it. A comment is added to the top of
  `NEWS.md`, but it tends to be ignored occasionally.

##### For full use

- If your package…

  - is brand-new, remember to run
    [`fledge::bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
    regularly.
  - has already undergone some development, it is not too late to jump
    on the train! Run
    [`fledge::bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
    and then
    [`fledge::finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md).

##### For light use

- Your package needs a development version header as produced by
  `usethis::use_development_version()`.

``` md
# mypackage (development version)
```

## Functions

{fledge} consists of the following functions that enable versioning at
different stages through the package development lifecycle.

| Function Name                                                                       | Description                                                                                                  | Stage Applicable                                                                    |
|-------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
| `bump_version(which)`                                                               | Increments the package version based on argument. (Version format supported *major.minor.dev.patch*)         | Configuration, Development, Release                                                 |
| [`finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md) | Finalize the package version                                                                                 | Configuration, Development                                                          |
| [`commit_version()`](https://fledge.cynkra.com/dev/reference/commit_version.md)     | Commits `NEWS.md` and `DESCRIPTION` to Git.                                                                  | Release                                                                             |
| [`tag_version()`](https://fledge.cynkra.com/dev/reference/tag_version.md)           | Parses `NEWS.md` and creates/updates the tag for the most recent version.                                    | Release                                                                             |
| [`update_news()`](https://fledge.cynkra.com/dev/reference/update_news.md)           | Update `NEWS.md` with messages from top level commits; Update `NEWS.md` and `DESCRIPTION` with a new version | Used by [`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md) |

## Full fledge usage

The following sections show how to combine these functions at different
stages with any R package on GitHub. All {fledge} commands should be
issued from the package directory of the target R package.

### Initial Configuration

{fledge} assumes that the target R package is version-controlled with
Git in a dedicated repository. The following steps are required to set
up {fledge} for first time use, with your package.

1.  Call
    [`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
    as given below to set the package version

        fledge::bump_version()

2.  Edit `NEWS.md` if required (typo fixes, rephrasing, grouping).

3.  Call
    [`finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md)
    as given below to update `NEWS.md`

        fledge::finalize_version()

You are all set to switch to the development stage now. Ensure that you
use bullet points (`*` or `-`) in your commit or merge messages to
indicate the messages that you want to include in `NEWS.md`. Use
`finalize_version(push = TRUE)` to push to the remote repository
(e.g. GitHub) in one swoop.

### Development

{fledge} aims to update `NEWS.md` and `DESCRIPTION` correctly whenever a
new version is assigned. In order to do this, the following steps need
to be included throughout the development workflow.

1.  In commit messages to your main branch (typically `main` or
    `master`), mark everything that should go to `NEWS.md` with a bullet
    point (`-` or `*`). This is applicable to single commits, merge
    commits, or squash commits from pull requests. Do not edit `NEWS.md`
    manually.

2.  When you want to assign a version number to the current state of
    your R package e.g. at the end of the day or before a break, call

    ``` r
    fledge::bump_version()
    ```

    The default argument for bump_version is “dev”. So the dev part of
    the version number will be updated. It is good practice to assign a
    new version number before switching focus to another project.

3.  Edit `NEWS.md` if required (typo fixes, rephrasing, grouping).

4.  Call
    [`finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md):
    [`fledge::finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md).
    This achieves the following:

    - `NEWS.md` is now composed, based on the most recent commit
      messages. To understand how `NEWS.md` is updated by fledge, see
      the section on `NEWS.md` implementation.
    - A new version number is assigned automatically (this is modeled
      after
      [`usethis::use_version()`](https://usethis.r-lib.org/reference/use_version.html)).
    - A tag matching the version number is assigned automatically, with
      the most recent `NEWS.md` messages included in the tag’s message.

### Releasing to CRAN

When you want to release your package to CRAN, follow the steps below:

1.  Call bump_version() with the appropriate argument (`"patch"`,
    `"major"`, `"minor"`). e.g.,

    ``` r
    fledge::bump_version("patch")
    ```

2.  Edit `NEWS.md`, convert the “change log” to “release notes” – a
    higher-level description of features and bug fixes (typo fixes,
    rephrasing, grouping).

3.  Call
    [`commit_version()`](https://fledge.cynkra.com/dev/reference/commit_version.md)
    as below

    ``` r
    fledge::commit_version()
    ```

4.  Make any necessary adjustments before releasing to CRAN depending on
    results of preparatory / incoming checks.

5.  Once the release/changes have been accepted by CRAN, use the
    following calls to tag the released version and to switch to a
    development version immediately.

        fledge::tag_version()
        fledge::bump_version()

6.  Return to development mode!

## FAQ & edge cases

At least we think these questions could be asked. Feel free to also [ask
us questions](https://github.com/cynkra/fledge/discussions)!

### But what if I want to edit NEWS.md manually?

You still can!

- The best moment is between
  [`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
  and `finalize_version(push = TRUE)`.

- You can actually edit at any time, but only between those two calls
  the text in the changelog will be captured in the tag message, which
  is better for the tag history.

### What if a contributor wants to contribute a NEWS item?

If someone opens a PR, with fledge the information about the changes
should be entered in the message for the merge or squash commit. Now you
could still advise contributors to provide a summary of the change as a
comment to the PR.

### Does this mean “Fix \#42” will appear in NEWS.md?

If you want to fix an issue with a commit message you can

- put “Fix \#42” on a separate non-bulleted line or after a line with 3
  hyphens.

&nbsp;

    - Adds support for coolness (#42, @contributor).

    ---

    Fix #42

- In a PR on e.g. GitHub you can link an issue to a PR by starting the
  first comment with “Fix 42” so the issue will be closed. The merge or
  squash commit will be hyperlinked to the PR, but the commit message
  won’t have that phrase. You should still add an acknowledgement in the
  actual commit message e.g. “- Adds support for coolness (#42,
  @contributor)”.

### Edge cases

- If you **rebase after creating a tag**, you need to call
  [`finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md)
  to make sure the tag is moved to the mainline branch.

- If you **pushed** via `finalize_version(push = TRUE)` or `git push`,
  the tag may have been pushed as well. In this case, invoke

``` sh
git push origin :vx.y.z.9www
```

(where `x.y.z.9www` is the new version) to delete the newly created
remote tag. This is the reason why {fledge} only tags `"dev"` releases
automatically. Other releases always must be tagged manually with
[`tag_version()`](https://fledge.cynkra.com/dev/reference/tag_version.md).
