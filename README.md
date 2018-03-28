
<!-- README.md is generated from README.Rmd. Please edit that file -->
fledge
======

The goal of fledge is to streamline the process of versioning R packages and updating NEWS. Numbers are cheap, why not use them?

-   `bump_dev_version()`
    -   `update_news()`: collects `NEWS` entries from top-level commits
    -   `update_version()`: bump version in `DESCRIPTION`, add header to `NEWS.md`
    -   `tag_version()`: commit `DESCRIPTION` and `NEWS.md`, create tag with message

You can edit `NEWS.md` and call `tag_version()` again, both the commit and the tag will be updated.

Installation
------------

Install from GitHub via

``` r
remotes::install_github("krlmlr/fledge")
```
