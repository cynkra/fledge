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
```

The infrastructure files and directories that comprise a minimal R package are created:


```r
fs::dir_ls()
## DESCRIPTION NAMESPACE   R           tea.Rproj
```

### Create and configure a Git repository

Next, one would set up this package for development and create a Git repository for the package.
We achieved this with gert code.

You could use `usethis::use_git()` function that creates an initial commit, and the repository is in a clean state.


```r
# Number of commits until now
nrow(gert::git_log())
## [1] 1
# Anything staged?
gert::git_status()
## # A tibble: 0 x 3
## # ... with 3 variables: file <chr>, status <chr>, staged <lgl>
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


```
## [1] rwxrwxr-x
```


```r
gert::git_remote_list()
## # A tibble: 1 x 2
##   name   url                          
## * <chr>  <chr>                        
## 1 origin ${TEMP}/fledge/remote
gert::git_remote_info()
## $name
## [1] "origin"
## 
## $url
## [1] "${TEMP}/fledge/remote"
## 
## $push_url
## NULL
## 
## $head
## NULL
## 
## $fetch
## [1] "+refs/heads/*:refs/remotes/origin/*"
## 
## $push
## character(0)
```

We create two functions to show the contents and tags of the remote.
In real life, you'd probably simply browse the GitHub interface for instance!


```r
fs::dir_ls(remote_url)
## ${TEMP}/fledge/remote/HEAD
## ${TEMP}/fledge/remote/config
## ${TEMP}/fledge/remote/description
## ${TEMP}/fledge/remote/hooks
## ${TEMP}/fledge/remote/info
## ${TEMP}/fledge/remote/objects
## ${TEMP}/fledge/remote/refs
show_files <- function(remote_url) {
  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  withr::with_dir(tempdir_remote, {
    gert::git_clone(remote_url)  
    fs::dir_ls("remote")
  })
}
show_files(remote_url)
## remote/DESCRIPTION remote/NAMESPACE   remote/tea.Rproj

show_tags <- function(remote_url) {
  tempdir_remote <- withr::local_tempdir(pattern = "remote")
  withr::with_dir(tempdir_remote, {
    gert::git_clone(remote_url)  
    # Only show name and ref
    gert::git_tag_list(repo = "remote")[, c("name", "ref")]
  })
}
```

### Create initial NEWS.md file

An initial NEWS file can be created with `usethis::use_news_md()`.


```r
usethis::use_news_md()
## v Writing 'NEWS.md'
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
## remote/DESCRIPTION remote/NAMESPACE   remote/NEWS.md     remote/tea.Rproj
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
## * Edit 'R/cup.R'
## * Call `use_test()` to create a matching test file
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
## remote/DESCRIPTION remote/NAMESPACE   remote/NEWS.md     remote/R           
## remote/tea.Rproj
```

### Create a test

The code in `cup.R` warrants a test (at least it would if it were actual code!):


```r
usethis::use_test("cup")
## v Adding 'testthat' to Suggests field in DESCRIPTION
## v Setting Config/testthat/edition field in DESCRIPTION to '3'
## v Creating 'tests/testthat/'
## v Writing 'tests/testthat.R'
## v Writing 'tests/testthat/test-cup.R'
## * Edit 'tests/testthat/test-cup.R'
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
## remote/DESCRIPTION remote/NAMESPACE   remote/NEWS.md     remote/R           
## remote/tea.Rproj   remote/tests
```

### Update NEWS.md

Let us look at the commit history until now.
You might use any Git tool you want to consult it, we use gert.


```r
# Only show number of files, messages
knitr::kable(gert::git_log()[-(1:3)])
```



| files|merge |message                                                          |
|-----:|:-----|:----------------------------------------------------------------|
|     3|FALSE |- Add tests for cup of tea.                                      |
|     1|FALSE |- New cup_of_tea() function makes it easy to drink a cup of tee. |
|     1|FALSE |Initial NEWS.md .                                                |
|     5|FALSE |First commit                                                     |

We have two "bulletted" messages which for fledge means two NEWS-worthy messages.

Let us update `NEWS.md`!

We use `fledge::bump_version()` to assign a new dev version number to the package and also update `NEWS.md`.

The current version number of our package is 0.0.0.9000.


```r
fledge::bump_version()
## > Scraping 4 commit messages.
## v Found 2 NEWS-worthy entries.
## 
## -- Updating NEWS --
## 
## > Adding new entries to 'NEWS.md'.
## Warning: 'Date' must be an ISO date: yyyy-mm-dd, but it is actually better to
## leave this field out completely. It is not required.
## 
## -- Update Version --
## 
## v Package version bumped to 0.0.0.9001.
## > Adding header to 'NEWS.md'.
## > Committing changes.
## 
## -- Tagging Version --
## 
## > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
## * Edit 'NEWS.md'
## ! Call `fledge::finalize_version(push = TRUE)`.
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
## # A tibble: 0 x 2
## # ... with 2 variables: name <chr>, ref <chr>
fledge::finalize_version(push = TRUE)
## > Resetting to previous commit.
## > Committing changes.
## 
## -- Tagging Version --
## 
## > Deleting tag v0.0.0.9001.
## > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
## > Force-pushing tag v0.0.0.9001.
## > Pushing main.
show_tags(remote_url)
## # A tibble: 1 x 2
##   name        ref                  
##   <chr>       <chr>                
## 1 v0.0.0.9001 refs/tags/v0.0.0.9001
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
## v Writing 'tests/testthat/test-bowl.R'
## * Edit 'tests/testthat/test-bowl.R'
```


```r
gert::git_add("tests/testthat/test-bowl.R")
gert::git_commit("Add bowl tests.")
```



```r
usethis::use_r("bowl")
## * Edit 'R/bowl.R'
## * Call `use_test()` to create a matching test file
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
## > Scraping 2 commit messages.
## v Found 1 NEWS-worthy entries.
## 
## -- Updating NEWS --
## 
## > Adding new entries to 'NEWS.md'.
## 
## -- Update Version --
## 
## v Package version bumped to 0.0.0.9002.
## > Adding header to 'NEWS.md'.
## > Committing changes.
## 
## -- Tagging Version --
## 
## > Creating tag v0.0.0.9002 with tag message derived from 'NEWS.md'.
## * Edit 'NEWS.md'
## ! Call `fledge::finalize_version(push = TRUE)`.
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
fledge::finalize_version(push = TRUE)
## > Resetting to previous commit.
## > Committing changes.
## 
## -- Tagging Version --
## 
## > Deleting tag v0.0.0.9002.
## > Creating tag v0.0.0.9002 with tag message derived from 'NEWS.md'.
## > Force-pushing tag v0.0.0.9002.
## > Pushing main.
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
## > Scraping 1 commit messages.
## v Found 1 NEWS-worthy entries.
## 
## -- Updating NEWS --
## 
## > Adding new entries to 'NEWS.md'.
## 
## -- Update Version --
## 
## v Package version bumped to 0.0.1.
## > Adding header to 'NEWS.md'.
## > Committing changes.
## i Preparing package for release (CRAN or otherwise).
## * Edit 'NEWS.md'
## ! Convert the change log in 'NEWS.md' to release notes.
## ! After CRAN release, call `fledge::tag_version()` and
## `fledge::bump_version()` to re-enter development mode
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
## -- Tagging Version --
## 
## > Creating tag v0.0.1 with tag message derived from 'NEWS.md'.
show_tags(remote_url)
## # A tibble: 2 x 2
##   name        ref                  
##   <chr>       <chr>                
## 1 v0.0.0.9001 refs/tags/v0.0.0.9001
## 2 v0.0.0.9002 refs/tags/v0.0.0.9002
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
## > Scraping 1 commit messages.
## v Found 1 NEWS-worthy entries.
## 
## -- Updating NEWS --
## 
## > Adding new entries to 'NEWS.md'.
## 
## -- Update Version --
## 
## v Package version bumped to 0.0.1.9000.
## > Adding header to 'NEWS.md'.
## > Committing changes.
## 
## -- Tagging Version --
## 
## > Creating tag v0.0.1.9000 with tag message derived from 'NEWS.md'.
## * Edit 'NEWS.md'
## ! Call `fledge::finalize_version(push = TRUE)`.
## NULL
news <- readLines("NEWS.md")
```

Push to remote, add features with relevant commits (after mergining a branch or not), `bump_version()`, etc.
Happy development, and happy smooth filling of the changelog!




```r
unlink(parent_dir, recursive = TRUE)
```
