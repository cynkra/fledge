<!-- README.md is generated from README.Rmd. Please edit that file -->

# fledge

> Smoother change tracking and versioning for R packages.

<!-- badges: start -->

[![rcc](https://github.com/cynkra/fledge/workflows/rcc/badge.svg)](https://github.com/cynkra/fledge/actions) [![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) [![CRAN status](https://www.r-pkg.org/badges/version/fledge)](https://cran.r-project.org/package=fledge) [![Codecov test coverage](https://codecov.io/gh/cynkra/fledge/branch/main/graph/badge.svg)](https://app.codecov.io/gh/cynkra/fledge?branch=main)

<!-- badges: end -->

Do you want to provide a changelog ([NEWS.md](https://blog.r-hub.io/2020/05/08/pkg-news/#why-write-the-changelog-as-newsmd)) more informative than “bug fixes and performance improvements” (`https://twitter.com/EmilyKager/status/1413628436984188933`) to the users of your package?

Ways to achieve that are:

- Update NEWS.md right before release by reading through commit messages. Not necessarily fun!

- Update the changelog in every commit e.g. in every PR. Now, if there are several feature PRs around that update the changelog, you’ll have a few clicks to make to tackle conflicts. Easy enough, but potentially annoying.

- Use fledge to

  - fill the `NEWS.md` for you based on informative commit messages,
  - (optionally) increase the version number in `DESCRIPTION` (e.g. useful in bug reports with session information!),
  - (optionally) create git tags (more coarse-grained history compared to top-level merges see [fledge tag list on GitHub](https://github.com/cynkra/fledge/tags)).

Using fledge is a discipline, a few habits, that are worth learning!

What you need to do in practice is, **no matter your fledge commitment level**:

- For important commit messages you want recorded in the changelog, you can

  - Use the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) syntax. For instance `feat: Enhanced support for time series`. Only using conventional commits syntax will provide automatic *grouping* of changelog items into groups (Documentation, Bug Fixes, etc.).

  - Add a hyphen `-` or `*` at the beginning of the commit message. Exclude housekeeping parts of the message by typing them after a line `---`.

  ``` text

  - Add support for bla databases.
  ```

  or

  ``` text

  - Add support for bla databases.

  ---

  Also tweak the CI workflow accordingly. :sweat_smile:
  ```

  - Use informative merge commit messages as those will also be included by default in the changelog. On GitHub you can [control the default commit message when merging a pull request](https://github.blog/changelog/2022-08-23-new-options-for-controlling-the-default-commit-message-when-merging-a-pull-request/).

  - (GitHub repositories only) For merge commits with the default not self-contained message (“Merge pull request…”), rely on fledge’s querying GitHub API to get the PR title and include it in the changelog.

For informative commit messages refer to the [Tidyverse style guide](https://style.tidyverse.org/news.html).

Then, for **full fledge use = fledge-assisted management of NEWS.md, DESCRIPTION version numbers, and git tags**:

- Run [`fledge::bump_version()`](https://cynkra.github.io/fledge/reference/bump_version.html) regularly e.g. before every coffee break or at the end of the day or of the week. If you forgot to merge one PR run [`fledge::unbump_version()`](https://cynkra.github.io/fledge/reference/unbump_version.html), merge the PR with an informative squash commit message, then run [`fledge::bump_version()`](https://cynkra.github.io/fledge/reference/bump_version.html) and go drink that coffee!

- Run [`fledge::finalize_version()`](https://cynkra.github.io/fledge/reference/finalize_version.html) if you need to edit `NEWS.md` manually e.g. if you made a typo or are not happy with a phrasing in retrospect. Even if you edit a lot, what’s been written in by fledge is still a good place-holder.

- Follow the recommended steps at release (see `vignette("fledge")` usage section).

OR, for **light fledge use = filling of NEWS.md between releases**:

- Have a development version header as produced by `usethis::use_development_version()`.

<pre class='chroma'>
<span><span class='c'># mypackage (development version)</span></span></pre>

- Regularly run [`fledge::update_news()`](https://cynkra.github.io/fledge/reference/update_news.html), preferentially on the main branch to avoid merge conflicts.

These habits are worth learning!

## Demo

[![asciinema demo](https://github.com/cynkra/fledge/raw/main/readme/demo.gif)](https://asciinema.org/a/173876)

Click on the image above to show in a separate tab.

## Installation & setup

### Once per machine

Install from CRAN using:

<pre class='chroma'>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"fledge"</span><span class='o'>)</span></span></pre>

Install from cynkra’s R-universe (development version) using:

<pre class='chroma'>
<span><span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"fledge"</span>, repos <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"https://cynkra.r-universe.dev"</span>, <span class='s'>"https://cloud.r-project.org"</span><span class='o'>)</span><span class='o'>)</span></span></pre>

Or install from GitHub (development version as well) using:

<pre class='chroma'>
<span><span class='nf'>remotes</span><span class='nf'>::</span><span class='nf'><a href='https://remotes.r-lib.org/reference/install_github.html'>install_github</a></span><span class='o'>(</span><span class='s'>"cynkra/fledge"</span><span class='o'>)</span></span></pre>

If you are used to making workflow packages (e.g. [devtools](https://usethis.r-lib.org/articles/articles/usethis-setup.html#use-usethis-or-devtools-in-interactive-work)) available for all your interactive work, you might enjoy loading fledge in your [.Rprofile](https://rstats.wtf/r-startup.html#rprofile).

### Once per package

- Your package needs to have a remote that indicates the default branch (e.g. GitHub remote) *or* to be using the same default branch name as your global/project `init.defaultbranch`.

- Add a mention of fledge usage in your contributing guide, as contributors might not know about it. A comment is added to the top of `NEWS.md`, but it tends to be ignored occasionally.

##### For full use

- If your package…

  - is brand-new, remember to run [`fledge::bump_version()`](https://cynkra.github.io/fledge/reference/bump_version.html) regularly.
  - has already undergone some development, it is not too late to jump on the train! Run [`fledge::bump_version()`](https://cynkra.github.io/fledge/reference/bump_version.html) and then [`fledge::finalize_version()`](https://cynkra.github.io/fledge/reference/finalize_version.html).

##### For light use

- Your package needs a development version header as produced by `usethis::use_development_version()`.

<pre class='chroma'>
<span><span class='c'># mypackage (development version)</span></span></pre>

## How to get started?

Check out the general vignette `vignette("fledge")`, and for the whole game, the demo vignette `vignette("demo")`. Feel free to [ask us questions](https://github.com/cynkra/fledge/discussions)!

## Related tools

- [newsmd](https://github.com/Dschaykib/newsmd): manually add updates (version or bullet points) to the `NEWS.md` file.
- [autonewsmd](https://github.com/kapsner/autonewsmd): Auto-Generate Changelog using Conventional Commits.
