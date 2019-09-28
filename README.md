
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fledge

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/krlmlr/fledge.svg?branch=master)](https://travis-ci.org/krlmlr/fledge)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/krlmlr/fledge?branch=master&svg=true)](https://ci.appveyor.com/project/krlmlr/fledge)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN
status](https://www.r-pkg.org/badges/version/fledge)](https://cran.r-project.org/package=fledge)
<!-- badges: end -->

*fledge* has been designed to streamline the process of versioning R
packages on *Git*, with the functionality to automatically update
`NEWS.md` and `DESCRIPTION` with relevant information from recent commit
messages. For details on usage and implementation, refer the [Get
Started](https://krlmlr.github.io/fledge/articles/fledge.html) article.

## Demo

[![asciinema demo](readme/demo.gif)](https://asciinema.org/a/173876)

Click on the image for a larger view.

## Installation

Install from GitHub using

``` r
devtools::install_github("krlmlr/fledge")
```

## Usage

Run *fledge* commands from your package directory for versioning as
below.

  - To configure your package for the first-time with *fledge*, use
    
    ``` r
    fledge::bump_version()
    fledge::finalize_version()
    ```
    
    From now on, use bullet points (`*` or `-`) in your commit or merge
    messages to indicate the messages that you want to include in
    NEWS.md

  - To assign a new `"dev"` version number to the R package and update
    `NEWS.md`, use
    
    ``` r
    fledge::bump_version()
    fledge::finalize_version()
    ```

  - To assign a new version number to the R package before release to
    CRAN, use
    
    ``` r
    fledge::bump_version("patch")
    fledge::commit_version()
    ```
    
    Substitute `"patch"` by `"minor"` or `"major"` if applicable.

  - To tag a version when the package has been accepted to CRAN, use
    
    ``` r
    fledge::tag_version()
    ```
    
    Call
    
    ``` r
    fledge::bump_version()
    ```
    
    to immediately switch to a development version.

  - To undo the last version bump, use
    
    ``` r
    fledge::unbump_version()
    ```
