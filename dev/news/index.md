# Changelog

## fledge 0.1.99.9042 (2025-11-10)

### Features

- Treat versions with two components as release versions.

### Continuous integration

- Review env vers when installing, more careful foreign runs, format
  with `clang-format`
  ([\#1028](https://github.com/cynkra/fledge/issues/1028)).

## fledge 0.1.99.9041 (2025-11-08)

### Continuous integration

- Format with air, check detritus, better handling of `extra-packages`
  ([\#923](https://github.com/cynkra/fledge/issues/923)).

### documentation

- Update function reference links in README.md
  ([\#880](https://github.com/cynkra/fledge/issues/880)).

## fledge 0.1.99.9040 (2025-05-04)

### Continuous integration

- Enhance permissions for workflow
  ([\#872](https://github.com/cynkra/fledge/issues/872)).

## fledge 0.1.99.9039 (2025-04-30)

### Continuous integration

- Permissions, better tests for missing suggests, lints
  ([\#870](https://github.com/cynkra/fledge/issues/870)).

- Only fail covr builds if token is given
  ([\#867](https://github.com/cynkra/fledge/issues/867)).

- Always use `_R_CHECK_FORCE_SUGGESTS_=false`
  ([\#866](https://github.com/cynkra/fledge/issues/866)).

- Correct installation of xml2
  ([\#863](https://github.com/cynkra/fledge/issues/863)).

- Explain ([\#861](https://github.com/cynkra/fledge/issues/861)).

- Add xml2 for covr, print testthat results
  ([\#860](https://github.com/cynkra/fledge/issues/860)).

- Sync ([\#859](https://github.com/cynkra/fledge/issues/859)).

## fledge 0.1.99.9038 (2025-04-06)

### Chore

- Extract `get_release_branch_from_version()`.

## fledge 0.1.99.9037 (2024-12-26)

### Features

- `bump_version(which = "dev")` always bumps from non-dev.

### Chore

- IDE.

## fledge 0.1.99.9036 (2024-12-12)

### Bug fixes

- Support empty commit messages.

- `is_news_consistent()` detects releases of the kind x.y.z-w.

- Work around bug in [`order()`](https://rdrr.io/r/base/order.html) for
  package versions.

- Use correct version for checking GH release.

- Use correct version for checking GH release.

- `release_after_cran_built_binaries()` works correctly again
  ([\#848](https://github.com/cynkra/fledge/issues/848)).

### Features

- Better entry if PR info could not be extracted.

- Support versions of the form x.y.z-w for tagging.

- Newsworthy commits are searched along the first parents only, picking
  up all relevant commits
  ([\#847](https://github.com/cynkra/fledge/issues/847)).

- Determining the most recent tag now uses the new
  [`get_last_version_tag()`](https://fledge.cynkra.com/dev/reference/get_last_version_tag.md)
  and works when the version tag is on a diverged branch (e.g., after
  squash-merging)
  ([\#844](https://github.com/cynkra/fledge/issues/844)).

- Consistent protection of hash tag
  ([\#836](https://github.com/cynkra/fledge/issues/836)).

- Keep empty lines when merging
  ([\#834](https://github.com/cynkra/fledge/issues/834)).

- [`plan_release()`](https://fledge.cynkra.com/dev/reference/release.md)
  pulls the current branch
  ([\#831](https://github.com/cynkra/fledge/issues/831)).

### Chore

- Get tagging information from fledgling.

- Clear clipboard after successful discovery of CRAN URL.

- Check token early for automation
  ([\#841](https://github.com/cynkra/fledge/issues/841)).

- Refactor ([\#835](https://github.com/cynkra/fledge/issues/835)).

### Continuous integration

- Install R.

- Avoid failure in fledge workflow if no changes
  ([\#851](https://github.com/cynkra/fledge/issues/851)).

- Fetch tags for fledge workflow to avoid unnecessary NEWS entries
  ([\#850](https://github.com/cynkra/fledge/issues/850)).

- Use larger retry count for lock-threads workflow
  ([\#849](https://github.com/cynkra/fledge/issues/849)).

- Ignore errors when removing pkg-config on macOS
  ([\#840](https://github.com/cynkra/fledge/issues/840)).

- Explicit permissions
  ([\#839](https://github.com/cynkra/fledge/issues/839)).

- Use styler from main branch
  ([\#838](https://github.com/cynkra/fledge/issues/838)).

- Need to install R on Ubuntu 24.04
  ([\#837](https://github.com/cynkra/fledge/issues/837)).

- Use Ubuntu 24.04 and styler PR
  ([\#829](https://github.com/cynkra/fledge/issues/829)).

### Testing

- Fix test ([\#846](https://github.com/cynkra/fledge/issues/846)).

### Uncategorized

- Ci: Fix macOS ([\#16](https://github.com/cynkra/fledge/issues/16))
  ([\#830](https://github.com/cynkra/fledge/issues/830)).

## fledge 0.1.99.9035 (2024-11-24)

### Features

- Keep only `raw` NEWS
  ([\#827](https://github.com/cynkra/fledge/issues/827)).

### Chore

- Refactorings and a new test
  ([\#825](https://github.com/cynkra/fledge/issues/825)).

- Better JSON snapshot
  ([\#824](https://github.com/cynkra/fledge/issues/824)).

- Keep `raw` component up to date, use it for assembling the NEWS
  ([\#823](https://github.com/cynkra/fledge/issues/823)).

## fledge 0.1.99.9034 (2024-11-23)

### Chore

- Distinguish `news` component from `news` column in data frame
  ([\#820](https://github.com/cynkra/fledge/issues/820)).

## fledge 0.1.99.9033 (2024-11-22)

### Bug fixes

- CRAN PRs are no longer created as draft
  ([\#810](https://github.com/cynkra/fledge/issues/810)).

- `fledge:::release_after_cran_built_binaries()` no longer throws an
  error if no release exists.

### Features

- [`finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md)
  unconditionally overwrites existing tags
  ([\#819](https://github.com/cynkra/fledge/issues/819)).

- Pre-releases get a different PR title
  ([\#818](https://github.com/cynkra/fledge/issues/818)).

- PR must open from the main window
  ([\#816](https://github.com/cynkra/fledge/issues/816)).

- [`plan_release()`](https://fledge.cynkra.com/dev/reference/release.md)
  calls
  [`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
  ([\#814](https://github.com/cynkra/fledge/issues/814)).

- Detect contributors for squashed commits
  ([\#813](https://github.com/cynkra/fledge/issues/813)).

- Mention `bump_version(check_default_branch = FALSE)` in error message
  ([\#812](https://github.com/cynkra/fledge/issues/812)).

- New
  [`plan_release()`](https://fledge.cynkra.com/dev/reference/release.md),
  replaces `init_release()` and `pre_release()`
  ([\#803](https://github.com/cynkra/fledge/issues/803)).

- Support `which = "pre-patch"` for
  [`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
  and
  [`update_version()`](https://fledge.cynkra.com/dev/reference/update_version.md)
  ([\#802](https://github.com/cynkra/fledge/issues/802)).

- [`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
  does not bump if no newsworthy messages are found
  ([\#801](https://github.com/cynkra/fledge/issues/801)).

- Messages that start with `"fledge: "` are no longer considered
  newsworthy ([\#800](https://github.com/cynkra/fledge/issues/800)).

- Include only relevant info in `cran-comments.md`
  ([\#799](https://github.com/cynkra/fledge/issues/799)).

- Support pre-patch version, new versioning scheme starting at 9900
  ([\#794](https://github.com/cynkra/fledge/issues/794)).

### Chore

- Bump commit messages get a fledge prefix.

- Add fledge prefix to CRAN PR
  ([\#809](https://github.com/cynkra/fledge/issues/809)).

### Continuous integration

- Remove Aviator ([\#815](https://github.com/cynkra/fledge/issues/815)).

- Correctly detect branch protection
  ([\#811](https://github.com/cynkra/fledge/issues/811)).

- Sync fledge workflow.

### Refactoring

- `is_dev_version()` and related
  ([\#805](https://github.com/cynkra/fledge/issues/805)).

### Testing

- Reduce use of `shut_up_fledge()`
  ([\#796](https://github.com/cynkra/fledge/issues/796)).

- Speed up tests by replacing
  [`gert::git_add()`](https://docs.ropensci.org/gert/reference/git_commit.html)
  with a system call
  ([\#793](https://github.com/cynkra/fledge/issues/793)).

- Split slow test.

## fledge 0.1.99.9032 (2024-11-11)

### Continuous integration

- Trigger run ([\#792](https://github.com/cynkra/fledge/issues/792)).

## fledge 0.1.99.9031 (2024-10-28)

### Continuous integration

- Use pkgdown branch
  ([\#791](https://github.com/cynkra/fledge/issues/791)).

## fledge 0.1.99.9030 (2024-09-15)

### Continuous integration

- Install via R CMD INSTALL ., not pak
  ([\#789](https://github.com/cynkra/fledge/issues/789)).

## fledge 0.1.99.9029 (2024-08-31)

### Chore

- Add Aviator configuration.

### Continuous integration

- Install local package for pkgdown builds.

- Improve support for protected branches, without fledge.

### Testing

- Snapshot updates for rcc-smoke (null)
  ([\#786](https://github.com/cynkra/fledge/issues/786)).

## fledge 0.1.99.9028 (2024-08-19)

### Bug fixes

- Try pushing head first.

- Try pushing head first, fail with branch protection.

### Features

- `bump_version(check_default_branch = TRUE)`.

## fledge 0.1.99.9027 (2024-08-17)

### Chore

- Auto-update from GitHub Actions.

  Run: <https://github.com/cynkra/fledge/actions/runs/10425483871>

### Continuous integration

- Sync with latest developments.

## fledge 0.1.99.9026 (2024-08-10)

### Continuous integration

- Use v2 instead of master.

## fledge 0.1.99.9025 (2024-08-06)

### Continuous integration

- Inline action.

## fledge 0.1.99.9024 (2024-08-03)

### Testing

- Snapshot updates for R-CMD-check-base (null)
  ([\#783](https://github.com/cynkra/fledge/issues/783)).

## fledge 0.1.99.9023 (2024-08-02)

### Continuous integration

- Use dev roxygen2 and decor.

### Testing

- Accept snapshots after knitr update.

## fledge 0.1.99.9022 (2024-07-02)

### Continuous integration

- Fix on Windows, tweak lock workflow.

## fledge 0.1.99.9021 (2024-06-30)

### Chore

- Auto-update from GitHub Actions.

  Run: <https://github.com/cynkra/fledge/actions/runs/9727971994>

## fledge 0.1.99.9020 (2024-06-28)

### Chore

- Auto-update from GitHub Actions.

  Run: <https://github.com/cynkra/fledge/actions/runs/9691617690>

### Continuous integration

- Avoid checking bashisms on Windows.

- Remove netlify workflow.

- Remove special branch.

- Bump versions, better default, consume custom matrix.

- Recent updates.

## fledge 0.1.99.9019 (2024-06-26)

### Bug fixes

- Update bump-version.R - replace length test in
  get_main_branch_config()
  ([\#775](https://github.com/cynkra/fledge/issues/775)).

## fledge 0.1.99.9018 (2024-04-16)

### Documentation

- Set BS version explicitly for now.

  <https://github.com/cynkra/cynkratemplate/issues/53>

## fledge 0.1.99.9017 (2024-02-19)

### Chore

- Move responsibility for writing fledgeling, memoise, add `repo`
  argument ([\#761](https://github.com/cynkra/fledge/issues/761)).

## fledge 0.1.99.9016 (2024-01-24)

- Internal changes only.

## fledge 0.1.99.9015 (2024-01-15)

### Chore

- Work around r-lib/roxygen2#1570.

## fledge 0.1.99.9014 (2023-12-22)

### Bug fixes

- Create releases with correct body
  ([\#756](https://github.com/cynkra/fledge/issues/756)).

### Chore

- Add Aviator configuration.

## fledge 0.1.99.9013 (2023-11-09)

### Bug fixes

- `create_github_release()` removes the header from the NEWS entry.

## fledge 0.1.99.9012 (2023-11-07)

### Features

- Do not report installation size problems
  ([\#755](https://github.com/cynkra/fledge/issues/755)).

## fledge 0.1.99.9011 (2023-11-05)

### Features

- [`post_release()`](https://fledge.cynkra.com/dev/reference/release.md)
  no longer checks if on release branch
  ([\#750](https://github.com/cynkra/fledge/issues/750)).

### Chore

- Use `news_path()`
  ([\#751](https://github.com/cynkra/fledge/issues/751)).

## fledge 0.1.99.9010 (2023-11-03)

### Features

- Allow bumping straight from released version
  ([\#747](https://github.com/cynkra/fledge/issues/747)).

- [`post_release()`](https://fledge.cynkra.com/dev/reference/release.md)
  is independent from release branch
  ([\#748](https://github.com/cynkra/fledge/issues/748)).

### Chore

- Add aviator configuration.

## fledge 0.1.99.9009 (2023-10-28)

### Features

- Release package as soon as it’s available on PPM.

## fledge 0.1.99.9008 (2023-10-23)

### Features

- New `init_release()`, to be called before `pre_release()`
  ([\#686](https://github.com/cynkra/fledge/issues/686)).

## fledge 0.1.99.9007 (2023-10-21)

### Features

- Automatically merge news from dev versions before release
  ([\#744](https://github.com/cynkra/fledge/issues/744)).

- More extensive preflight checks in
  [`post_release()`](https://fledge.cynkra.com/dev/reference/release.md),
  reduce output in quiet mode
  ([\#740](https://github.com/cynkra/fledge/issues/740)).

### Testing

- Basic testing scripts
  ([\#742](https://github.com/cynkra/fledge/issues/742)).

## fledge 0.1.99.9006 (2023-10-19)

### Bug fixes

- Extract error from first submission step, fix CRAN submission
  ([\#738](https://github.com/cynkra/fledge/issues/738)).

- Check if release exists before creating
  ([\#731](https://github.com/cynkra/fledge/issues/731)).

### Chore

- Add `version` and `ref` arguments to `create_release_branch()`, fix
  `create_release_branch(force = TRUE)`
  ([\#734](https://github.com/cynkra/fledge/issues/734)).

- `no_change()` and other functions gain ref argument
  ([\#733](https://github.com/cynkra/fledge/issues/733)).

- Pretty `check_only_modified()`
  ([\#705](https://github.com/cynkra/fledge/issues/705)).

- Refactorings for [\#686](https://github.com/cynkra/fledge/issues/686)
  ([\#729](https://github.com/cynkra/fledge/issues/729)).

### Testing

- Is this how we handle NoSuggests checks 😅
  ([\#732](https://github.com/cynkra/fledge/issues/732)).

## fledge 0.1.99.9005 (2023-10-09)

- Internal changes only.

## fledge 0.1.99.9004 (2023-10-03)

### Chore

- More efficient data frame access
  ([\#706](https://github.com/cynkra/fledge/issues/706)).

### Refactoring

- Replace httr with httr2
  ([\#712](https://github.com/cynkra/fledge/issues/712)).

### tests

- Clean up, simplify tests
  ([\#716](https://github.com/cynkra/fledge/issues/716)).

- Add a function to help run the tests without losing one’s current dir
  ([\#715](https://github.com/cynkra/fledge/issues/715)).

## fledge 0.1.99.9003 (2023-09-26)

### Testing

- Add a test for upper case conventional commit type
  ([\#711](https://github.com/cynkra/fledge/issues/711)).

## fledge 0.1.99.9002 (2023-07-11)

- Internal changes only.

## fledge 0.1.99.9001 (2023-06-22)

### Bug fixes

- Ask fledgeling for version.

- Bad merge conflict resolution from v0.1.1.

### Features

- Indent multiline NEWS items.

- More skip_if_offline() calls.

- Type stability of fledgeling object.

### Chore

- Avoid useless computation.

### Testing

- Prefer `local_options(repos = NULL)` over `skip_if_offline()`.

- Test order.

### Uncategorized

- Merge branch ‘cran-0.1.1’.

## fledge 0.1.99.9000 (2023-06-21)

- Merge branch ‘cran-0.1.1’.

## fledge 0.1.0.9047 (2023-06-16)

### Bug fixes

- Guess_next() works as expected for *.99.* versions.

## fledge 0.1.0.9046 (2023-06-13)

### Bug fixes

- Suppress clipr warnings.

### Features

- More flexible version extraction from release PR title
  ([\#678](https://github.com/cynkra/fledge/issues/678)).

## fledge 0.1.0.9045 (2023-06-09)

### Bug fixes

- Adapt to new behavior of usethis::use_news_md()
  ([\#680](https://github.com/cynkra/fledge/issues/680)).

### Chore

- Clean version header parsing
  ([\#610](https://github.com/cynkra/fledge/issues/610)).

## fledge 0.1.0.9044 (2023-06-06)

### Chore

- Tell it what to merge.

## fledge 0.1.0.9043 (2023-06-01)

### Bug fixes

- [`post_release()`](https://fledge.cynkra.com/dev/reference/release.md)
  works if the release branch doesn’t change files in the main branch.

## fledge 0.1.0.9042 (2023-05-28)

### Bug fixes

- Better error message when duplicate version name
  ([\#673](https://github.com/cynkra/fledge/issues/673)).

### Testing

- Snapshot updates for rcc-smoke (null)
  ([\#677](https://github.com/cynkra/fledge/issues/677)).

## fledge 0.1.0.9041 (2023-04-18)

### Refactoring

- Slightly simplify pre_release()
  ([\#669](https://github.com/cynkra/fledge/issues/669)).

## fledge 0.1.0.9040 (2023-04-13)

### Features

- [`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
  only works in interactive sessions or if `NEWS.md` has a preamble (or
  both) ([\#638](https://github.com/cynkra/fledge/issues/638)).

## fledge 0.1.0.9039 (2023-04-04)

### Bug fixes

- Use pkg version from open PR, not from CRAN page
  ([\#662](https://github.com/cynkra/fledge/issues/662)).

### Testing

- Snapshot updates for rcc-smoke (null)
  ([\#660](https://github.com/cynkra/fledge/issues/660)).

- Snapshot updates for rcc-smoke (null)
  ([\#647](https://github.com/cynkra/fledge/issues/647)).

- Fix snapshots after updates of upstream dependencies
  ([\#657](https://github.com/cynkra/fledge/issues/657)).

## fledge 0.1.0.9038 (2023-03-28)

- Internal changes only.

## fledge 0.1.0.9037 (2023-03-24)

### Features

- Do not write “Same as previous version” as first thing in a brand-new
  changelog ([\#655](https://github.com/cynkra/fledge/issues/655)).

- New internal `release_after_cran_built_binaries()` to support
  automated CRAN release from GHA
  ([\#651](https://github.com/cynkra/fledge/issues/651)).

### Documentation

- Update pitch ([\#656](https://github.com/cynkra/fledge/issues/656)).

## fledge 0.1.0.9036 (2023-03-21)

### Features

- Add ability to parse two-line headers
  ([\#654](https://github.com/cynkra/fledge/issues/654)).

### Refactoring

- Use the full power of {cli}
  ([\#640](https://github.com/cynkra/fledge/issues/640)).

## fledge 0.1.0.9035 (2023-03-15)

### Features

- Add special CRAN release label to release PRs
  ([\#649](https://github.com/cynkra/fledge/issues/649)).

## fledge 0.1.0.9034 (2023-03-08)

### tests

- Replace httptest with httptest2 as gh now uses httr2 instead of httr
  ([\#646](https://github.com/cynkra/fledge/issues/646)).

## fledge 0.1.0.9033 (2023-02-17)

- Internal changes only.

## fledge 0.1.0.9032 (2023-02-12)

### Bug fixes

- Bump to dev version in `pre_release()`.

## fledge 0.1.0.9031 (2023-02-09)

### Refactoring

- Update fledge URL in NEWS preamble
  ([\#622](https://github.com/cynkra/fledge/issues/622)).

## fledge 0.1.0.9030 (2023-02-05)

### Bug fixes

- Work around unexplicable behavior in demo tests.

- Remove push trigger in `fledge.yaml`, seems broken.

- [`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
  keeps updating `Date` field if it exists in `DESCRIPTION`.

### Features

- [`post_release()`](https://fledge.cynkra.com/dev/reference/release.md)
  pulls the main branch before merging
  ([\#525](https://github.com/cynkra/fledge/issues/525)).

Closes [\#525](https://github.com/cynkra/fledge/issues/525).

- New mode of operation `"samedev"`, for
  [\#147](https://github.com/cynkra/fledge/issues/147).

- [`update_news()`](https://fledge.cynkra.com/dev/reference/update_news.md)
  gains which argument, deprecate
  [`update_version()`](https://fledge.cynkra.com/dev/reference/update_version.md)
  ([\#607](https://github.com/cynkra/fledge/issues/607)).

### Chore

- Move packages from Imports to Suggests.

- Add extra snapshot.

- Clean up snapshots.

- [`usethis::use_lifecycle()`](https://usethis.r-lib.org/reference/use_lifecycle.html).

- Prepare roundtrip via fledgeling
  ([\#606](https://github.com/cynkra/fledge/issues/606)).

- Move foghorn and rversions to Suggests
  ([\#605](https://github.com/cynkra/fledge/issues/605)).

- Run fledge workflow only on main branch
  ([\#597](https://github.com/cynkra/fledge/issues/597)).

### Continuous integration

- Add test prefix to snapshot updates PR template
  ([\#582](https://github.com/cynkra/fledge/issues/582)).

### Refactoring

- Use `write_fledgling()` to write `NEWS.md`
  ([\#588](https://github.com/cynkra/fledge/issues/588)).

### Uncategorized

- Remove false Markdown link?
  ([\#592](https://github.com/cynkra/fledge/issues/592)).

## fledge 0.1.0.9029 (2022-12-30)

- Internal changes only.

## fledge 0.1.0.9028 (2022-12-22)

- Internal changes only.

## fledge 0.1.0.9027 (2022-12-09)

- Internal changes only.

## fledge 0.1.0.9026 (2022-12-06)

### Features

- Support for linked issues from other repositories
  ([\#595](https://github.com/cynkra/fledge/issues/595)).

## fledge 0.1.0.9025 (2022-11-19)

### Documentation

- Typo.

## fledge 0.1.0.9024 (2022-11-12)

- Internal changes only.

## fledge 0.1.0.9023 (2022-11-11)

### Bug fixes

- Remove partial matching warning
  ([\#579](https://github.com/cynkra/fledge/issues/579)).

### Features

- Draft fledgeling object, ready for internal use
  ([\#581](https://github.com/cynkra/fledge/issues/581)).

- Add full stop to messages
  ([\#578](https://github.com/cynkra/fledge/issues/578)).

### Chore

- Store downlit info
  ([\#580](https://github.com/cynkra/fledge/issues/580)).

### Documentation

- Cynkratemplate::use_cynkra_pkgdown() + re-add comment
  ([@krlmlr](https://github.com/krlmlr),
  [@41898282](https://github.com/41898282)+github-actions-bot,
  [@maelle](https://github.com/maelle),
  [\#568](https://github.com/cynkra/fledge/issues/568)).

### Uncategorized

- Split news ([\#584](https://github.com/cynkra/fledge/issues/584)).

## fledge 0.1.0.9022 (2022-11-10)

### Bug fixes

- Add full stop for entries

## fledge 0.1.0.9021 (2022-11-09)

- Internal changes only.

## fledge 0.1.0.9020 (2022-11-03)

- Snapshot updates for R-CMD-check-base (null)
  ([\#570](https://github.com/cynkra/fledge/issues/570))

## fledge 0.1.0.9019 (2022-10-28)

- Internal changes only.

## fledge 0.1.0.9018 (2022-10-26)

### Documentation

- Fix URL ([\#573](https://github.com/cynkra/fledge/issues/573))

## fledge 0.1.0.9017 (2022-10-24)

### Bug fixes

- Relax requirement for GitHub PAT scope
  ([\#572](https://github.com/cynkra/fledge/issues/572))

## fledge 0.1.0.9016 (2022-10-20)

- Internal changes only.

## fledge 0.1.0.9015 (2022-10-19)

- Internal changes only.

## fledge 0.1.0.9014 (2022-10-18)

- Harmonize yaml formatting

- Revert changes to matrix section

## fledge 0.1.0.9013 (2022-10-16)

- Internal changes only.

## fledge 0.1.0.9012 (2022-10-14)

- Internal changes only.

## fledge 0.1.0.9011 (2022-10-11)

- Internal changes only.

## fledge 0.1.0.9010 (2022-09-20)

### Features

- [`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md)
  returns `TRUE` if a new version has been created

## fledge 0.1.0.9009 (2022-09-20)

### Features

- Better support for merge commits of all kinds
  ([@maelle](https://github.com/maelle),
  [\#512](https://github.com/cynkra/fledge/issues/512))

### Uncategorized

- Internal changes only.

## fledge 0.1.0.9008 (2022-09-18)

### Features

- Better support for merge commits of all kinds
  ([@maelle](https://github.com/maelle),
  [\#512](https://github.com/cynkra/fledge/issues/512))

### Uncategorized

- Internal changes only.

## fledge 0.1.0.9007 (2022-09-16)

### Features

- Better support for merge commits of all kinds
  ([@maelle](https://github.com/maelle),
  [\#512](https://github.com/cynkra/fledge/issues/512))

### Uncategorized

- Internal changes only.

## fledge 0.1.0.9006 (2022-09-14)

### Features

- Better support for merge commits of all kinds
  ([@maelle](https://github.com/maelle),
  [\#512](https://github.com/cynkra/fledge/issues/512))

### Uncategorized

- Internal changes only.

## fledge 0.1.0.9005 (2022-09-13)

- Internal changes only.

## fledge 0.1.0.9004 (2022-09-12)

- Internal changes only.

## fledge 0.1.0.9003 (2022-09-12)

### Bug fixes

- Adjust empty lines and space in update_news()
  ([\#357](https://github.com/cynkra/fledge/issues/357))

- Add PR number to CC messages
  ([\#353](https://github.com/cynkra/fledge/issues/353)).

- Fix conventional commit regex
  ([\#329](https://github.com/cynkra/fledge/issues/329))

### Features

- New default `pre_release(which = "next")`
  ([\#521](https://github.com/cynkra/fledge/issues/521),
  [\#524](https://github.com/cynkra/fledge/issues/524)).

- Add which “pre-minor” and “pre-major” to update_version()
  ([\#413](https://github.com/cynkra/fledge/issues/413),
  [\#412](https://github.com/cynkra/fledge/issues/412)).

- Include reference to issue closed with a PR
  ([\#361](https://github.com/cynkra/fledge/issues/361),
  [\#411](https://github.com/cynkra/fledge/issues/411)).

- Capitalize first letter of each bullet
  ([\#360](https://github.com/cynkra/fledge/issues/360),
  [\#409](https://github.com/cynkra/fledge/issues/409)).

- Extract contributor name from PR merge message
  ([@krlmlr](https://github.com/krlmlr),
  [\#358](https://github.com/cynkra/fledge/issues/358))

- Harvest PR attribution from squash commits
  ([@maelle](https://github.com/maelle),
  [\#349](https://github.com/cynkra/fledge/issues/349))

- Harvest PR title from merge commit messages
  ([@krlmlr](https://github.com/krlmlr),
  [@maelle](https://github.com/maelle),
  [\#343](https://github.com/cynkra/fledge/issues/343))

- Improve parsing of conventional commit messages
  ([\#332](https://github.com/cynkra/fledge/issues/332)).

- Improve bump_version() (error) messages
  ([@maelle](https://github.com/maelle),
  [\#328](https://github.com/cynkra/fledge/issues/328))

- Improve bump_version() behavior in the absence of changes
  ([@krlmlr](https://github.com/krlmlr),
  [@maelle](https://github.com/maelle),
  [\#323](https://github.com/cynkra/fledge/issues/323))

- New `local_test_project()`
  ([\#318](https://github.com/cynkra/fledge/issues/318))

- Extract conventional commit messages for the changelog
  ([\#314](https://github.com/cynkra/fledge/issues/314)).

### Chore

- Turn Netlify builds off for now
  ([\#326](https://github.com/cynkra/fledge/issues/326)).

- Enable auto-style on GitHub Actions
  ([\#317](https://github.com/cynkra/fledge/issues/317)).

- Remove testthat specialization for snapshots
  ([\#309](https://github.com/cynkra/fledge/issues/309)).

### Continuous integration

- Create fledge.yaml
  ([\#520](https://github.com/cynkra/fledge/issues/520)).

### Documentation

- Add README section on related tools
  ([\#527](https://github.com/cynkra/fledge/issues/527)).

- Update summary of how fledge uses commit messages
  ([\#499](https://github.com/cynkra/fledge/issues/499),
  [\#511](https://github.com/cynkra/fledge/issues/511)).

- Fix typo in README
  ([\#501](https://github.com/cynkra/fledge/issues/501))

### Uncategorized

- Create and open draft release directly, without using
  [`usethis::use_github_release()`](https://usethis.r-lib.org/reference/use_github_release.html).

- Create tag as part of
  [`release()`](https://fledge.cynkra.com/dev/reference/release.md).

- Fix
  [`post_release()`](https://fledge.cynkra.com/dev/reference/release.md),
  still need to tag released version.

## fledge 0.1.0.9002 (2022-04-02)

- [`release()`](https://fledge.cynkra.com/dev/reference/release.md) no
  longer asks for confirmation.
- Inline
  [`devtools::submit_cran()`](https://devtools.r-lib.org/reference/submit_cran.html)
  minus the confirmation messages.

## fledge 0.1.0.9001 (2022-02-22)

- New `pre_release()`,
  [`release()`](https://fledge.cynkra.com/dev/reference/release.md) and
  [`post_release()`](https://fledge.cynkra.com/dev/reference/release.md)
  for semi-automatic CRAN releases
  ([\#27](https://github.com/cynkra/fledge/issues/27),
  [\#28](https://github.com/cynkra/fledge/issues/28)).
- Separate snapshot tests for dev version of testthat.

## fledge 0.1.0.9000 (2021-12-07)

- Same as previous version.

## fledge 0.1.1 (2023-06-16)

CRAN release: 2023-06-17

- Compatibility release for usethis 2.2.0.

## fledge 0.1.0 (2021-12-07)

CRAN release: 2021-12-07

Change log management utility, initial release.

The main entry point is
[`bump_version()`](https://fledge.cynkra.com/dev/reference/bump_version.md),
which does the following:

1.  Checks that `DESCRIPTION` and `NEWS.md` are clean before bumping,
    and that the current branch is the main branch.
2.  [`update_news()`](https://fledge.cynkra.com/dev/reference/update_news.md):
    collects `NEWS` entries from top-level commits
3.  [`update_version()`](https://fledge.cynkra.com/dev/reference/update_version.md):
    bump version in `DESCRIPTION`, add header to `NEWS.md`
4.  Depending on the kind of update:
    - If “dev”,
      [`finalize_version()`](https://fledge.cynkra.com/dev/reference/finalize_version.md):
      commit `DESCRIPTION` and `NEWS.md`, create tag with message
    - Otherwise,
      [`commit_version()`](https://fledge.cynkra.com/dev/reference/commit_version.md);
      the user needs to call
      [`tag_version()`](https://fledge.cynkra.com/dev/reference/tag_version.md)
      manually
5.  Suggests to push the changes if an upstream repository is
    configured.

If you haven’t committed since updating `NEWS.md` and `DESCRIPTION`, you
can also edit `NEWS.md` and call
[`tag_version()`](https://fledge.cynkra.com/dev/reference/tag_version.md)
again. Both the commit and the tag will be updated.

Bumping can be undone with
[`unbump_version()`](https://fledge.cynkra.com/dev/reference/unbump_version.md).

If the `DESCRIPTION` has a `"Date"` field, it is populated with the
current date in
[`update_version()`](https://fledge.cynkra.com/dev/reference/update_version.md).
Likewise, if `NEWS.md` contains dates in the headers, new versions also
get a date.

An empty list of changes adds a “Same as previous version” bullet. This
allows bumping to a dev version immediately after CRAN release.

Also includes helper functions
[`get_last_tag()`](https://fledge.cynkra.com/dev/reference/get_last_tag.md)
and
[`get_top_level_commits()`](https://fledge.cynkra.com/dev/reference/get_top_level_commits.md).

Includes vignettes: “Get started”, “Using fledge”, and “Fledge
internals”. Examples and tests are supported with a demo project,
created via
[`with_demo_project()`](https://fledge.cynkra.com/dev/reference/with_demo_project.md).

Thanks Patrick Schratz and Maëlle Salmon for your contributions!
