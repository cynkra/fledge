
<!-- README.md is generated from README.Rmd. Please edit that file -->
fledge
======

The goal of fledge is to streamline the process of versioning R packages and updating NEWS. Numbers are cheap, why not use them?

-   `bump_version()`
    -   `update_news()`: collects `NEWS` entries from
    -   `devtools::document()`
    -   `update_version()`
    -   `tag_release()`
    -   ...

Installation
------------

You can install the released version of fledge from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("fledge")
```

Install from GitHub via

``` r
remotes::install_github("krlmlr/fledge")
```
