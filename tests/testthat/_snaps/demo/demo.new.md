---
title: "Using fledge"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{demo}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

## Introduction

This guide will demonstrate how to use {fledge}, using a mock R package as an example.
We are going to call our package "{tea}".
We will develop it from scratch and also maintain a changelog as the development progresses.
Finally, we will demonstrate how this changelog can eventually be converted to release notes when the package is submitted to CRAN.

:::{.alert .alert-info}
We are typing this demo as an R Markdown vignette therefore we will be using R tools for creating files, editing them, and interacting with git: in real life you can be using e.g. an IDE or the command line. The fledge package won't care!
:::



## Set up the development environment

Before we start development for {tea}, we set up the basic development environment required for any typical R package.

### Create a package

We will start by creating a new package.
For this demo, the package is created in a temporary directory.
A real project will live somewhere in your home directory.

The `usethis::create_package()` function sets up a package project ready for development.


```r
pkg <- usethis::create_package("tea")
```



In an interactive RStudio session, a new window opens and you would work there.
Users of other environments would change the working directory manually.
For this demo, we manually set the active project.




```r
usethis::proj_set()
## [32mv[39m Setting active project to [34m'${TEMP}/fledge/tea'[39m
```

The infrastructure files and directories that comprise a minimal R package are created:


```r
fs::dir_tree()
## [01;34m.[0m
## +-- DESCRIPTION
## +-- NAMESPACE
## +-- [01;34mR[0m
## \-- tea.Rproj
```

### Create and configure a Git repository

Next, one would set up this package for development and create a Git repository for the package.
We achieved this with gert code.

You could use `usethis::use_git()` function that creates an initial commit, and the repository is in a clean state.


```r
gert::git_log()
## [90m# A tibble: 1 x 6[39m
##   commit             author           time                files merge message   
## [90m*[39m [3m[90m<chr>[39m[23m              [3m[90m<chr>[39m[23m            [3m[90m<dttm>[39m[23m              [3m[90m<int>[39m[23m [3m[90m<lgl>[39m[23m [3m[90m<chr>[39m[23m     
## [90m1[39m 4e376b5d2cee0b6c3~ Maëlle Salmon <~ 2021-09-27 [90m14:47:37[39m     5 FALSE [90m"[39mFirst co~
gert::git_status()
## [90m# A tibble: 0 x 3[39m
## [90m# ... with 3 variables: file <chr>, status <chr>, staged <lgl>[39m
```

For working in branches, it is recommended to turn off fast-forward merging:


```r
gert::git_config_set("merge.ff", "false")
# gert::git_config_global_set("merge.ff", "false") # to set globally
```

An alternative is to use squash commits.

We also set up a git remote.
In real life you might be using a function like `usethis::use_github()`.
We set up a local remote using a git repo we secretly created earlier.


```r
# In real life this would be an actual URL not a filepath :-)
remote_url <- file.path(parent_dir, "remote")
gert::git_remote_add(remote_url, name = "origin")
gert::git_push(remote = "origin")
```

We create a function to show the contents of the remote.
In real life, you'd probably simply browse the GitHub interface for instance!


```r
show_files <- function(remote_url) {
  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  withr::with_dir(tempdir_remote, {
    gert::git_clone(remote_url)  
    fs::dir_tree("remote")
  })
}
show_files(remote_url)
## [34;42mremote[0m
## +-- DESCRIPTION
## +-- NAMESPACE
## \-- tea.Rproj

show_tags <- function(remote_url) {
  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  withr::with_dir(tempdir_remote, {
    gert::git_clone(remote_url)  
    gert::git_tag_list(repo = "remote")
  })
}
```

### Create initial NEWS.md file

An initial NEWS file can be created with `usethis::use_news_md()`.


```r
usethis::use_news_md()
## [32mv[39m Writing [34m'NEWS.md'[39m
```

Let's take a look at the contents:


```r
news <- readLines(usethis::proj_path("NEWS.md"))
cat(news, sep = "\n")
## # tea 0.0.0.9000
## 
## * Added a `NEWS.md` file to track changes to the package.
```

This file needs to be tracked by Git:


```r
gert::git_add("NEWS.md")
gert::git_commit("Initial NEWS.md .")
gert::git_push(remote = "origin")
```


```r
show_files(remote_url)
## [34;42mremote[0m
## +-- DESCRIPTION
## +-- NAMESPACE
## +-- NEWS.md
## \-- tea.Rproj
```

:::{.alert .alert-info}
Note that we have done nothing fledge specific yet.
:::

## The development phase

### Create an R file

Now we start coding in the functionality for the package.
We start by creating the new R file called `cup.R` and adding code (well only a comment).


```r
usethis::use_r("cup")
## [31m*[39m Edit [34m'R/cup.R'[39m
## [31m*[39m Call [90m`use_test()`[39m to create a matching test file
writeLines("# cup", "R/cup.R")
```

We commit this file to Git with a relevant message.

:::{.alert .alert-info}
That is our first fledge specific step!
Note the **use of the bullet (-) at the beginning of the commit message**.
This indicates that the message should be included in `NEWS.md` when it is updated.
:::

It does not matter how and where you type the commit message (gert in R, RStudio Git window, command line, VSCode, etc.).
What's important is the content of the commit message.


```r
gert::git_add("R/cup.R")
gert::git_commit("- New cup_of_tea() function makes it easy to drink a cup of tee.")
gert::git_push()
```


```r
show_files(remote_url)
## [34;42mremote[0m
## +-- DESCRIPTION
## +-- NAMESPACE
## +-- NEWS.md
## +-- [01;34mR[0m
## |   \-- [32mcup.R[0m
## \-- tea.Rproj
```

### Create a test

The code in `cup.R` warrants a test (at least it would if it were actual code!):


```r
usethis::use_test("cup")
## [32mv[39m Adding [34m'testthat'[39m to [32mSuggests[39m field in DESCRIPTION
## [32mv[39m Setting [32mConfig/testthat/edition[39m field in DESCRIPTION to [34m'3'[39m
## [32mv[39m Creating [34m'tests/testthat/'[39m
## [32mv[39m Writing [34m'tests/testthat.R'[39m
## [32mv[39m Writing [34m'tests/testthat/test-cup.R'[39m
## [31m*[39m Edit [34m'tests/testthat/test-cup.R'[39m
cat(readLines("tests/testthat/test-cup.R"), sep = "\n")
## test_that("multiplication works", {
##   expect_equal(2 * 2, 4)
## })
```

In a real project we would substitute the testing code from the template by real tests.
In this demo we commit straight away, **again with a bulleted message**.


```r
gert::git_add("DESCRIPTION")
gert::git_add("tests/testthat.R")
gert::git_add("tests/testthat/test-cup.R")
gert::git_commit("- Add tests for cup of tea.")
gert::git_push()
```


```r
show_files(remote_url)
## [34;42mremote[0m
## +-- DESCRIPTION
## +-- NAMESPACE
## +-- NEWS.md
## +-- [01;34mR[0m
## |   \-- [32mcup.R[0m
## +-- tea.Rproj
## \-- [01;34mtests[0m
##     +-- [01;34mtestthat[0m
##     |   \-- [32mtest-cup.R[0m
##     \-- [32mtestthat.R[0m
```

### Update NEWS.md

Let us look at the commit history until now.
You might use any Git tool you want to consult it, we use gert.


```r
knitr::kable(gert::git_log())
```



|commit                                   |author                                 |time                | files|merge |message                                                          |
|:----------------------------------------|:--------------------------------------|:-------------------|-----:|:-----|:----------------------------------------------------------------|
|a413ddfb67be8ec19b44efce6cf5a1a93d3654d3 |Maëlle Salmon <maelle.salmon@yahoo.se> |2021-11-26 15:58:55 |     3|FALSE |- Add tests for cup of tea.                                      |
|09873894dec809bc05a8e601595102a702f502c6 |Maëlle Salmon <maelle.salmon@yahoo.se> |2021-11-26 15:58:55 |     1|FALSE |- New cup_of_tea() function makes it easy to drink a cup of tee. |
|e14a2721c200029e0c9b1e59af0d6680fabadda8 |Maëlle Salmon <maelle.salmon@yahoo.se> |2021-11-26 15:58:55 |     1|FALSE |Initial NEWS.md .                                                |
|4e376b5d2cee0b6c3401986ab1682b03026fb397 |Maëlle Salmon <maelle.salmon@yahoo.se> |2021-09-27 14:47:37 |     5|FALSE |First commit                                                     |

We have two "bulletted" messages which for fledge means two NEWS-worthy messages.

Let us update `NEWS.md`!

We use `fledge::bump_version()` to assign a new dev version number to the package and also update `NEWS.md`.

The current version number of our package is 0.0.0.9000.


```r
fledge::bump_version()
## > Scraping [32m[32m4[32m[39m commit messages.
## [32mv[39m Found [32m[32m2[32m[39m NEWS-worthy entries.
## 
## -- [1m[1mUpdating NEWS[1m[22m --
## 
## > Adding new entries to [34m[34mNEWS.md[34m[39m.
## Warning: 'Date' must be an ISO date: yyyy-mm-dd, but it is actually better to
## leave this field out completely. It is not required.
## 
## -- [1m[1mUpdate Version[1m[22m --
## 
## [32mv[39m Package version bumped to [32m[32m0.0.0.9001[32m[39m.
## > Adding header to [34m[34mNEWS.md[34m[39m.
## > Committing changes.
## 
## -- [1m[1mTagging Version[1m[22m --
## 
## > Creating tag [32mv0.0.0.9001[39m with tag message derived from [34mNEWS.md[39m.
## [31m*[39m Edit [34m'NEWS.md'[39m
## [33m![39m Call [30m[47m[30m[47m`fledge::finalize_version(push = TRUE)`[47m[30m[49m[39m.
## NULL
```

The new version number is 0.0.0.9001.

:::{.alert .alert-info}
If you run `fledge::bump_version()` too early by mistake (e.g. you wanted to do one more code edit), you can run `fledge::unbump_version()`!
This should happen immediately after bumping.
If you have pushed or edited code in the meantime, it's too late -- just continue and assign a new version when you are done with the edits.
:::

### Review NEWS.md

Let us see what `NEWS.md` looks like after that bump.


```r
news <- readLines("NEWS.md")
cat(news, sep = "\n")
## <!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->
## 
## # tea 0.0.0.9001
## 
## - Add tests for cup of tea.
## - New cup_of_tea() function makes it easy to drink a cup of tee.
## 
## 
## # tea 0.0.0.9000
## 
## * Added a `NEWS.md` file to track changes to the package.
```

While reviewing we notice that there was a typo in one of the comments (congrats if you noticed right away that we typed "tee" instead of "tea"!).

:::{.alert .alert-warning}
The fledge package adds a comment about not editing `NEWS.md` by hand to `NEWS.md` but actually you can... if you do it right! Read on.
:::

Let's fix the typo, which you'd do by hand.


```r
news <- gsub("tee", "tea", news)
cat(news, sep = "\n")
## <!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->
## 
## # tea 0.0.0.9001
## 
## - Add tests for cup of tea.
## - New cup_of_tea() function makes it easy to drink a cup of tea.
## 
## 
## # tea 0.0.0.9000
## 
## * Added a `NEWS.md` file to track changes to the package.
writeLines(news, "NEWS.md")
```

This does not affect the original commit message, only `NEWS.md`.
([Editing commit messages](https://docs.github.com/en/github/committing-changes-to-your-project/creating-and-editing-commits/changing-a-commit-message#amending-older-or-multiple-commit-messages) is not something fledge supports).

### Finalize version


:::{.alert .alert-warning}
After tweaking `NEWS.md`, it is important to use `fledge::finalize_version()` and not to commit manually.
:::

Using `fledge::finalize_version()` instead of committing manually ensures that the tag is set to the correct version in spite of the `NEWS.md` update.
It should be called when `NEWS.md` is manually updated.
Note that it should be called after `fledge::bump_version()`, an error is raised if another commit has been added after that.


```r
show_tags(remote_url)
## [90m# A tibble: 0 x 3[39m
## [90m# ... with 3 variables: name <chr>, ref <chr>, commit <chr>[39m
fledge::finalize_version(push = TRUE)
## > Resetting to previous commit.
## > Committing changes.
## 
## -- [1m[1mTagging Version[1m[22m --
## 
## > Deleting tag [32m[32mv0.0.0.9001[32m[39m.
## > Creating tag [32mv0.0.0.9001[39m with tag message derived from [34mNEWS.md[39m.
## > Force-pushing tag [32m[32mv0.0.0.9001[32m[39m.
## > Pushing [32m[32mmain[32m[39m.
show_tags(remote_url)
## [90m# A tibble: 1 x 3[39m
##   name        ref                   commit                                  
## [90m*[39m [3m[90m<chr>[39m[23m       [3m[90m<chr>[39m[23m                 [3m[90m<chr>[39m[23m                                   
## [90m1[39m v0.0.0.9001 refs/tags/v0.0.0.9001 0d7593d76cf1815a80c31ee1ada56e0d4cbc6d8d
```

Let's look at NEWS.md now:


```r
news <- readLines("NEWS.md")
cat(news, sep = "\n")
## <!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->
## 
## # tea 0.0.0.9001
## 
## - Add tests for cup of tea.
## - New cup_of_tea() function makes it easy to drink a cup of tea.
## 
## 
## # tea 0.0.0.9000
## 
## * Added a `NEWS.md` file to track changes to the package.
```

The version of the package is 0.0.0.9001.

A tag has been created for the version which is good practice, and crucial when using fledge: for updating the changelog, fledge looks through all commit messages **since the latest tag**.

### Change code and commit

{tea} with cup is tested, now we want to enhance with bowl.
This requires changes to the code, and perhaps a new test.
We create a branch (whose name starts with a "f" for "feature") and switch to this branch to implement this.


```r
gert::git_branch_create("f-bowl", checkout = TRUE)
```

On the branch, separate commits are used for the tests and the implementation.
These commit messages do not need to be formatted specially, because {fledge} will ignore them anyway.

This time we write the tests first, test-driven development.


```r
usethis::use_test("bowl")
## [32mv[39m Writing [34m'tests/testthat/test-bowl.R'[39m
## [31m*[39m Edit [34m'tests/testthat/test-bowl.R'[39m
```


```r
gert::git_add("tests/testthat/test-bowl.R")
gert::git_commit("Add bowl tests.")
```



```r
usethis::use_r("bowl")
## [31m*[39m Edit [34m'R/bowl.R'[39m
## [31m*[39m Call [90m`use_test()`[39m to create a matching test file
writeLines("# bowl of tea", "R/bowl.R")
```


```r
gert::git_add("R/bowl.R")
gert::git_commit("Add bowl implementation.")
```

This branch can be pushed to the remote as usual.
Only when merging we specify the message to be included in the changelog, again with a bullet.[^merge-ff]
You might be used to doing the merges on a remote (e.g. GitHub pull requests) but here we demonstrate a local merge commit.

[^merge-ff]: Note that we really need a merge commit here; the default is to fast-forward which doesn't give us the opportunity to insert the message intended for the changelog.
Earlier, we set the `merge.ff` config option to `"false"` to achieve this.


```r
gert::git_branch_checkout("main")
gert::git_merge("f-bowl", commit = FALSE)
## Merge was not committed due to merge conflict(s). Please fix and run git_commit() or git_merge_abort()
gert::git_commit("- New bowl_of_tea() function makes it easy to drink a bowl of tea.")
```

The same strategy can be used when merging a pull/merge/... request on GitHub, GitLab, ...: use bullet points in the merge commit message to indicate the items to include in `NEWS.md`.

Now that we have added bowl support to our package, it is time to bump the version again.


```r
fledge::bump_version()
## > Scraping [32m[32m2[32m[39m commit messages.
## [32mv[39m Found [32m[32m1[32m[39m NEWS-worthy entries.
## 
## -- [1m[1mUpdating NEWS[1m[22m --
## 
## > Adding new entries to [34m[34mNEWS.md[34m[39m.
## 
## -- [1m[1mUpdate Version[1m[22m --
## 
## [32mv[39m Package version bumped to [32m[32m0.0.0.9002[32m[39m.
## > Adding header to [34m[34mNEWS.md[34m[39m.
## > Committing changes.
## 
## -- [1m[1mTagging Version[1m[22m --
## 
## > Creating tag [32mv0.0.0.9002[39m with tag message derived from [34mNEWS.md[39m.
## [31m*[39m Edit [34m'NEWS.md'[39m
## [33m![39m Call [30m[47m[30m[47m`fledge::finalize_version(push = TRUE)`[47m[30m[49m[39m.
## NULL
news <- readLines("NEWS.md")
writeLines(news)
## <!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->
## 
## # tea 0.0.0.9002
## 
## - New bowl_of_tea() function makes it easy to drink a bowl of tea.
## 
## 
## # tea 0.0.0.9001
## 
## - Add tests for cup of tea.
## - New cup_of_tea() function makes it easy to drink a cup of tea.
## 
## 
## # tea 0.0.0.9000
## 
## * Added a `NEWS.md` file to track changes to the package.
```

It seems we do not even need to amend the `NEWS.md` by hand this time as we made no typo!

## Prepare for release

After multiple cycles of development, review and testing, we decide that our package is ready for release to CRAN.
This is where {fledge} simplifies the release process by making use of the all the commit messages that we provided earlier.


A difference between publishing on CRAN and publishing on GitHub is that there's an external system controlling your publication on CRAN so your package might need some tweaks between the first release candidate and what version you end up publishing on CRAN.

### Bump version for release

We wish to release this package as a patch and so we use `fledge::bump_version()` with the "patch" argument.
Other values for the arguments are "dev" (default), "minor" and "major".


```r
fledge::bump_version("patch")
## > Scraping [32m[32m1[32m[39m commit messages.
## [32mv[39m Found [32m[32m1[32m[39m NEWS-worthy entries.
## 
## -- [1m[1mUpdating NEWS[1m[22m --
## 
## > Adding new entries to [34m[34mNEWS.md[34m[39m.
## 
## -- [1m[1mUpdate Version[1m[22m --
## 
## [32mv[39m Package version bumped to [32m[32m0.0.1[32m[39m.
## > Adding header to [34m[34mNEWS.md[34m[39m.
## > Committing changes.
## [36mi[39m Preparing package for release (CRAN or otherwise).
## [31m*[39m Edit [34m'NEWS.md'[39m
## [33m![39m Convert the change log in [34m[34mNEWS.md[34m[39m to release notes.
## 
## [33m![39m After CRAN release, call [30m[47m[30m[47m`fledge::tag_version()`[47m[30m[49m[39m and
## [30m[47m[30m[47m`fledge::bump_version()`[47m[30m[49m[39m to re-enter development mode
```

This updates the version of our package to 0.0.1.

### Generate release notes

We review the `NEWS.md` that were generated by {fledge}:


```r
news <- readLines("NEWS.md")
cat(news, sep = "\n")
## <!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->
## 
## # tea 0.0.1
## 
## - Same as previous version.
## 
## 
## # tea 0.0.0.9002
## 
## - New bowl_of_tea() function makes it easy to drink a bowl of tea.
## 
## 
## # tea 0.0.0.9001
## 
## - Add tests for cup of tea.
## - New cup_of_tea() function makes it easy to drink a cup of tea.
## 
## 
## # tea 0.0.0.9000
## 
## * Added a `NEWS.md` file to track changes to the package.
```

Some of the intermediate commit messages are not relevant in the release notes for this release.
We need to edit `NEWS.md` to convert the changelog to meaningful release notes.
E.g. in real life we might [re-organize bullets](https://style.tidyverse.org/news.html#organisation-3).

:::{.alert .alert-warning}
Unlike with development versions, we commit the changes to `NEWS.md` manually, not with a fledge function.
:::

The package is now ready to be released to CRAN.
I prefer `devtools::use_release_issue()` to create a checklist of things to do before release, and `devtools::submit_cran()` to submit.
The `devtools::release()` function is a more verbose alternative.

## After release

Some time passed and our {tea} package was accepted on CRAN.
At this stage, {fledge} can help to tag the released version and create a new version for development.

### Tag version

It is now the time to tag the released version using the `fledge::tag_version()` function.


```r
fledge::tag_version()
## 
## -- [1m[1mTagging Version[1m[22m --
## 
## > Creating tag [32mv0.0.1[39m with tag message derived from [34mNEWS.md[39m.
gert::git_push(remote = "origin")
show_tags(remote_url)
## [90m# A tibble: 1 x 3[39m
##   name        ref                   commit                                  
## [90m*[39m [3m[90m<chr>[39m[23m       [3m[90m<chr>[39m[23m                 [3m[90m<chr>[39m[23m                                   
## [90m1[39m v0.0.0.9001 refs/tags/v0.0.0.9001 0d7593d76cf1815a80c31ee1ada56e0d4cbc6d8d
```

It is advised to push to remote, with `git push --tags` from the command line, or your favorite Git client.

### Create GitHub release

If your package is hosted on GitHub, `usethis::use_github_release()` creates a draft GitHub release from the contents already in `NEWS.md`.
You need to submit the draft release from the GitHub release page.

### Restart development

We will now make the package ready for future development.
The `fledge::bump_version()` takes care of it.


```r
fledge::bump_version()
## > Scraping [32m[32m1[32m[39m commit messages.
## [32mv[39m Found [32m[32m1[32m[39m NEWS-worthy entries.
## 
## -- [1m[1mUpdating NEWS[1m[22m --
## 
## > Adding new entries to [34m[34mNEWS.md[34m[39m.
## 
## -- [1m[1mUpdate Version[1m[22m --
## 
## [32mv[39m Package version bumped to [32m[32m0.0.1.9000[32m[39m.
## > Adding header to [34m[34mNEWS.md[34m[39m.
## > Committing changes.
## 
## -- [1m[1mTagging Version[1m[22m --
## 
## > Creating tag [32mv0.0.1.9000[39m with tag message derived from [34mNEWS.md[39m.
## [31m*[39m Edit [34m'NEWS.md'[39m
## [33m![39m Call [30m[47m[30m[47m`fledge::finalize_version(push = TRUE)`[47m[30m[49m[39m.
## NULL
news <- readLines("NEWS.md")
```

Push to remote, add features with relevant commits (after mergining a branch or not), `bump_version()`, etc.
Happy development, and happy smooth filling of the changelog!




```r
unlink(parent_dir, recursive = TRUE)
```
