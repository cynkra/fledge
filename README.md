<!-- README.md is generated from README.Rmd. Please edit that file -->

# fledge

<!-- badges: start -->

[![tic](https://github.com/cynkra/fledge/workflows/tic/badge.svg?branch=master)](https://github.com/cynkra/fledge/actions) [![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing) [![CRAN status](https://www.r-pkg.org/badges/version/fledge)](https://cran.r-project.org/package=fledge) [![Codecov test coverage](https://codecov.io/gh/cynkra/fledge/branch/master/graph/badge.svg)](https://codecov.io/gh/cynkra/fledge?branch=master)

<!-- badges: end -->

{fledge} has been designed to streamline the process of versioning R packages on *Git*, with the functionality to automatically update `NEWS.md` and `DESCRIPTION` with relevant information from recent commit messages. Numbers are cheap, why not use them?

For details on usage and implementation, refer to `vignette("fledge")`.

## Demo

[![asciinema demo](https://github.com/cynkra/fledge/raw/master/readme/demo.gif)](https://asciinema.org/a/173876)

Click on the image to show in a separate tab.

## Installation

Install from GitHub using

<pre class='chroma'>
<span class='nf'>devtools</span><span class='nf'>::</span><span class='nf'><a href='https://devtools.r-lib.org//reference/remote-reexports.html'>install_github</a></span><span class='o'>(</span><span class='s'>"cynkra/fledge"</span><span class='o'>)</span></pre>

## Usage

Run {fledge} commands from your package directory for versioning as below.

-   To configure your package for the first-time with {fledge}, use

    <pre class='chroma'>
    <span class='nf'>fledge</span><span class='nf'>::</span><span class='nf'><a href='https://cynkra.github.io/fledge/reference/bump_version.html'>bump_version</a></span><span class='o'>(</span><span class='o'>)</span>
    <span class='nf'>fledge</span><span class='nf'>::</span><span class='nf'><a href='https://cynkra.github.io/fledge/reference/finalize_version.html'>finalize_version</a></span><span class='o'>(</span><span class='o'>)</span></pre>

    From now on, use bullet points ([`*`](https://rdrr.io/r/base/Arithmetic.html) or [`-`](https://rdrr.io/r/base/Arithmetic.html)) in your commit or merge messages to indicate the messages that you want to include in NEWS.md

-   To assign a new `"dev"` version number to the R package and update `NEWS.md`, use

    <pre class='chroma'>
    <span class='nf'>fledge</span><span class='nf'>::</span><span class='nf'><a href='https://cynkra.github.io/fledge/reference/bump_version.html'>bump_version</a></span><span class='o'>(</span><span class='o'>)</span>
    <span class='nf'>fledge</span><span class='nf'>::</span><span class='nf'><a href='https://cynkra.github.io/fledge/reference/finalize_version.html'>finalize_version</a></span><span class='o'>(</span><span class='o'>)</span></pre>

-   To assign a new version number to the R package before release to CRAN, use

    <pre class='chroma'>
    <span class='nf'>fledge</span><span class='nf'>::</span><span class='nf'><a href='https://cynkra.github.io/fledge/reference/bump_version.html'>bump_version</a></span><span class='o'>(</span><span class='s'>"patch"</span><span class='o'>)</span>
    <span class='nf'>fledge</span><span class='nf'>::</span><span class='nf'><a href='https://cynkra.github.io/fledge/reference/commit_version.html'>commit_version</a></span><span class='o'>(</span><span class='o'>)</span></pre>

    Substitute `"patch"` by `"minor"` or `"major"` if applicable.

-   To tag a version when the package has been accepted to CRAN, use

    <pre class='chroma'>
    <span class='nf'>fledge</span><span class='nf'>::</span><span class='nf'><a href='https://cynkra.github.io/fledge/reference/tag_version.html'>tag_version</a></span><span class='o'>(</span><span class='o'>)</span></pre>

    Call

    <pre class='chroma'>
    <span class='nf'>fledge</span><span class='nf'>::</span><span class='nf'><a href='https://cynkra.github.io/fledge/reference/bump_version.html'>bump_version</a></span><span class='o'>(</span><span class='o'>)</span></pre>

    to immediately switch to a development version.

-   To undo the last version bump, use

    <pre class='chroma'>
    <span class='nf'>fledge</span><span class='nf'>::</span><span class='nf'><a href='https://cynkra.github.io/fledge/reference/unbump_version.html'>unbump_version</a></span><span class='o'>(</span><span class='o'>)</span></pre>
