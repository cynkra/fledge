<!-- README.md is generated from README.Rmd. Please edit that file -->

# fledge

> Smoother change tracking and versioning for R packages.

<!-- badges: start -->

[![rcc](https://github.com/cynkra/fledge/workflows/rcc/badge.svg)](https://github.com/cynkra/fledge/actions) [![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental) [![Codecov test coverage](https://codecov.io/gh/cynkra/fledge/branch/main/graph/badge.svg)](https://app.codecov.io/gh/cynkra/fledge?branch=main)

<!-- badges: end -->

Do you want to provide a changelog ([NEWS.md](https://blog.r-hub.io/2020/05/08/pkg-news/#why-write-the-changelog-as-newsmd)) more informative than [“bug fixes and performance improvements”](https://twitter.com/EmilyKager/status/1413628436984188933) to the users of your package?

Ways to achieve that are:

-   Update NEWS.md right before release by reading through commit messages. Not necessarily fun!

-   Update the changelog in every commit e.g. in every PR. Now, if there are several feature PRs around that update the changelog, you’ll have a few clicks to make to tackle conflicts. Easy enough, but potentially annoying.

-   Use fledge to

    -   fill the `NEWS.md` for you based on informative commit messages,
    -   increase the version number in `DESCRIPTION` (e.g. useful in bug reports with session information!),
    -   create git tags (more coarse-grained history compared to top-level merges see [fledge tag list on GitHub](https://github.com/cynkra/fledge/tags)).

Using fledge is a discipline / a few habits that is worth learning!

What you need to do in practice is:

-   Add a hyphen `-` or `*` at the beginning of important commit messages e.g. the merge or squash commits that merge a Pull Request. These are the commit messages that’ll be recorded in the changelog eventually! Exclude housekeeping parts of the message by typing them after a line `---`.

``` text
- Add support for bla databases.
```

or

``` text
- Add support for bla databases.

---

Also tweak the CI workflow accordingly. :sweat_smile:
```

For informative commit messages refer to the [Tidyverse style guide](https://style.tidyverse.org/news.html).

-   Run [`fledge::bump_version()`](https://cynkra.github.io/fledge/reference/bump_version.html) regularly e.g. before every coffee break or at the end of the day or of the week. If you forgot to merge one PR run [`fledge::unbump_version()`](https://cynkra.github.io/fledge/reference/unbump_version.html), merge the PR with an informative squash commit message, then run [`fledge::bump_version()`](https://cynkra.github.io/fledge/reference/bump_version.html) and go drink that coffee!

-   Run [`fledge::finalize_version()`](https://cynkra.github.io/fledge/reference/finalize_version.html) if you add to edit `NEWS.md` manually e.g. if you made a typo or are not happy with a phrasing after thinking about it. Even if you edit a lot, what’s been written in by fledge is still a good place-holder.

-   Follow the recommended steps at release (see `vignette("fledge")` usage section).

These habits are worth learning!

## Demo

[![asciinema demo](https://github.com/cynkra/fledge/raw/main/readme/demo.gif)](https://asciinema.org/a/173876)

Click on the image above to show in a separate tab.

## Installation & setup

### Once per machine

Install from cynkra’s R-universe using:

<pre class='chroma'>
<span class='nf'><a href='https://rdrr.io/r/utils/install.packages.html'>install.packages</a></span><span class='o'>(</span><span class='s'>"fledge"</span>, repos <span class='o'>=</span> <span class='s'>"https://cynkra.r-universe.dev"</span><span class='o'>)</span></pre>

Or install from GitHub using:

<pre class='chroma'>
<span class='nf'>devtools</span><span class='nf'>::</span><span class='nf'><a href='https://devtools.r-lib.org/reference/remote-reexports.html'>install_github</a></span><span class='o'>(</span><span class='s'>"cynkra/fledge"</span><span class='o'>)</span></pre>

If you are used to making workflow packages (e.g. [devtools](https://usethis.r-lib.org/articles/articles/usethis-setup.html#use-usethis-or-devtools-in-interactive-work)) available for all your interactive work, you might enjoy loading fledge in your [.Rprofile](https://rstats.wtf/r-startup.html#rprofile).

### Once per package

-   Your package needs to have a remote that indicates the default branch (e.g. GitHub remote) *or* to be using the same default branch name as your global/project `init.defaultbranch`.

-   If your package…

    -   is brand-new, remember to run [`fledge::bump_version()`](https://cynkra.github.io/fledge/reference/bump_version.html) regularly.
    -   has already undergone some development, it is not too late to jump on the train! Run [`fledge::bump_version()`](https://cynkra.github.io/fledge/reference/bump_version.html) and then [`fledge::finalize_version()`](https://cynkra.github.io/fledge/reference/finalize_version.html).

-   Add a mention of fledge usage in your contributing guide, as contributors might not know about it. A comment is added to the top of `NEWS.md`, but it tends to be ignored occasionally.

## How to get started?

Check out the general vignette `vignette("fledge")`, and for the whole game, the demo vignette `vignette("demo")`. Feel free to [ask us questions](https://github.com/cynkra/fledge/discussions)!
