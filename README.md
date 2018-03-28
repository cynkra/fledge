
<!-- README.md is generated from README.Rmd. Please edit that file -->
fledge
======

The goal of fledge is to streamline the process of versioning R packages and updating NEWS. Numbers are cheap, why not use them?

Currently, this "works for me", use at your own risk.

The main entry point is `bump_version()`, which does the following:

1.  `update_news()`: collects `NEWS` entries from top-level commits
2.  `update_version()`: bump version in `DESCRIPTION`, add header to `NEWS.md`
3.  `tag_version()`: commit `DESCRIPTION` and `NEWS.md`, create tag with message

If you haven't committed since updating `NEWS.md` and `DESCRIPTION`, you can also edit `NEWS.md` and call `tag_version()` again. Both the commit and the tag will be updated.

Installation
------------

Install from GitHub via

``` r
remotes::install_github("krlmlr/fledge")
```
