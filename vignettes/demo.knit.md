---
title: "Using fledge"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Using fledge}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

## Introduction

This guide will demonstrate how to use {fledge}, using a mock R package as an example.
We are going to call our package "{SuperFrob}".
We will develop it from scratch and also maintain a changelog as the development progresses.
Finally, we will demonstrate how this changelog can eventually be converted to release notes when the package is submitted to CRAN.



## Set up the development environment

Before we start development for {SuperFrob}, we set up the basic development environment required for any typical R package.

### Create a package

We will start by creating a new package.
For this demo, the package is created in a temporary directory.
A real project will live somewhere in your home directory.


```r
tempdir <- tempfile("fledge")
dir.create(tempdir)
```

The `usethis::create_package()` function sets up a package project ready for development.
The output shows the details of the package created.


```r
pkg <- usethis::create_package(file.path(tempdir, "SuperFrob"))
```

<PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Creating </span><span style='color: #0000BB;'>'/var/folders/0s/szqcsbtd4011_hjg9z562djc0000gn/T/Rtmp0ZWWy8/fledge7a231d338e7c/SuperFrob/'</span><span>
</span></CODE></PRE><PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Setting active project to </span><span style='color: #0000BB;'>'/private/var/folders/0s/szqcsbtd4011_hjg9z562djc0000gn/T/Rtmp0ZWWy8/fledge7a231d338e7c/SuperFrob'</span><span>
</span></CODE></PRE><PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Creating </span><span style='color: #0000BB;'>'R/'</span><span>
</span></CODE></PRE><PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Writing </span><span style='color: #0000BB;'>'DESCRIPTION'</span><span>
</span></CODE></PRE><PRE class="fansi fansi-output"><CODE>## <span style='color: #0000BB;'>Package</span><span>: SuperFrob
## </span><span style='color: #0000BB;'>Title</span><span>: What the Package Does (One Line, Title Case)
## </span><span style='color: #0000BB;'>Version</span><span>: 0.0.0.9000
## </span><span style='color: #0000BB;'>Authors@R</span><span> (parsed):
##     * Patrick Schratz &lt;patrick.schratz@gmail.com&gt; [aut, cre] (&lt;https://orcid.org/0000-0003-0748-6624&gt;)
## </span><span style='color: #0000BB;'>Description</span><span>: What the package does (one paragraph).
## </span><span style='color: #0000BB;'>License</span><span>: `use_mit_license()`, `use_gpl3_license()` or friends to
##     pick a license
## </span><span style='color: #0000BB;'>Encoding</span><span>: UTF-8
## </span><span style='color: #0000BB;'>LazyData</span><span>: true
## </span><span style='color: #0000BB;'>Roxygen</span><span>: list(markdown = TRUE)
## </span><span style='color: #0000BB;'>RoxygenNote</span><span>: 7.1.1
</span></CODE></PRE><PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Writing </span><span style='color: #0000BB;'>'NAMESPACE'</span><span>
</span></CODE></PRE><PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Setting active project to </span><span style='color: #0000BB;'>'&lt;no active project&gt;'</span><span>
</span></CODE></PRE>

In an interactive RStudio session, a new window opens.
Users of other environments would change the working directory manually.
For this demo, we manually set the active project.




```r
usethis::proj_set()
```

<PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Setting active project to </span><span style='color: #0000BB;'>'/private/var/folders/0s/szqcsbtd4011_hjg9z562djc0000gn/T/Rtmp0ZWWy8/fledge7a231d338e7c/SuperFrob'</span><span>
</span></CODE></PRE>

The infrastructure files and directories that comprise a minimal R package are created:


```r
fs::dir_tree()
```

<PRE class="fansi fansi-output"><CODE>## <span style='color: #0000BB;font-weight: bold;'>.</span><span>
## ├── DESCRIPTION
## ├── NAMESPACE
## └── </span><span style='color: #0000BB;font-weight: bold;'>R</span><span>
</span></CODE></PRE>


### Create and configure a Git repository

Next we set up this package for development and create a Git repository for the package.


```r
usethis::use_git()
```

<PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Initialising Git repo
</span></CODE></PRE><PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Adding </span><span style='color: #0000BB;'>'.Rhistory'</span><span>, </span><span style='color: #0000BB;'>'.RData'</span><span>, </span><span style='color: #0000BB;'>'.Rproj.user'</span><span> to </span><span style='color: #0000BB;'>'.gitignore'</span><span>
</span></CODE></PRE>



In interactive mode, the `usethis::use_git()` function creates an initial commit, and the repository is in a clean state.
In the demo this needs to be carried out manually.


```r
gert::git_add(files = ".")
```

<PRE class="fansi fansi-output"><CODE>## <span style='color: #949494;'># A tibble: 3 x 3</span><span>
##   file        status staged
##   </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>       </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #949494;font-style: italic;'>&lt;lgl&gt;</span><span> 
## </span><span style='color: #BCBCBC;'>1</span><span> .gitignore  new    TRUE  
## </span><span style='color: #BCBCBC;'>2</span><span> DESCRIPTION new    TRUE  
## </span><span style='color: #BCBCBC;'>3</span><span> NAMESPACE   new    TRUE
</span></CODE></PRE>

```r
gert::git_commit(message = "Initial commit.")
```

```
## [1] "bd919dba72bdb21b56cf78a7694c582dec91f7ee"
```


```r
gert::git_log()
```

<PRE class="fansi fansi-output"><CODE>## <span style='color: #949494;'># A tibble: 1 x 6</span><span>
##   commit                author      time                files merge message     
## </span><span style='color: #BCBCBC;'>*</span><span> </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>                 </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>       </span><span style='color: #949494;font-style: italic;'>&lt;dttm&gt;</span><span>              </span><span style='color: #949494;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #949494;font-style: italic;'>&lt;lgl&gt;</span><span> </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>       
## </span><span style='color: #BCBCBC;'>1</span><span> bd919dba72bdb21b56cf… Test &lt;test… 2020-10-04 </span><span style='color: #949494;'>13:09:37</span><span>     3 FALSE </span><span style='color: #949494;'>"</span><span>Initial co…
</span></CODE></PRE>

```r
gert::git_status()
```

<PRE class="fansi fansi-output"><CODE>## <span style='color: #949494;'># A tibble: 0 x 3</span><span>
## </span><span style='color: #949494;'># … with 3 variables: file </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span style='color: #949494;'>, status </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span style='color: #949494;'>, staged </span><span style='color: #949494;font-style: italic;'>&lt;lgl&gt;</span><span>
</span></CODE></PRE>

For working in branches, it is recommended to turn off fast-forward merging:


```r
gert::git_config_set("merge.ff", "false")
```

An alternative is to use squash commits.

### Create initial NEWS.md file

An initial NEWS file can be created with `usethis::use_news_md()`.


```r
usethis::use_news_md()
```

<PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Writing </span><span style='color: #0000BB;'>'NEWS.md'</span><span>
</span></CODE></PRE>

Let's take a look at the contents:


```r
news <- readLines(usethis::proj_path("NEWS.md"))
cat(news, sep = "\n")
```

```
## # SuperFrob 0.0.0.9000
## 
## * Added a `NEWS.md` file to track changes to the package.
```

This file needs to be tracked by Git:


```r
gert::git_add(files = ".")
```

<PRE class="fansi fansi-output"><CODE>## <span style='color: #949494;'># A tibble: 1 x 3</span><span>
##   file    status staged
##   </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>   </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #949494;font-style: italic;'>&lt;lgl&gt;</span><span> 
## </span><span style='color: #BCBCBC;'>1</span><span> NEWS.md new    TRUE
</span></CODE></PRE>

```r
gert::git_status()
```

<PRE class="fansi fansi-output"><CODE>## <span style='color: #949494;'># A tibble: 1 x 3</span><span>
##   file    status staged
##   </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>   </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #949494;font-style: italic;'>&lt;lgl&gt;</span><span> 
## </span><span style='color: #BCBCBC;'>1</span><span> NEWS.md new    TRUE
</span></CODE></PRE>

```r
gert::git_commit(message = "Initial NEWS.md .")
```

```
## [1] "1291a3a84c376bbbbb93b88cf294294e87cb7dc8"
```

## The development phase

### Create an R file

Now we start coding in the functionality for the package.
We start by creating the new R file called `super.R` and adding frobnication code.


```r
usethis::use_r("super")
```

<PRE class="fansi fansi-message"><CODE>## <span style='color: #BB0000;'>●</span><span> Edit </span><span style='color: #0000BB;'>'R/super.R'</span><span>
</span></CODE></PRE><PRE class="fansi fansi-message"><CODE>## <span style='color: #BB0000;'>●</span><span> Call </span><span style='color: #555555;'>`use_test()`</span><span> to create a matching test file
</span></CODE></PRE>

```r
writeLines("# frobnicate", "R/super.R")
```

We commit this file to Git with a relevant message.
Note the use of the bullet (-) before the commit message.
This indicates that the message should be included in `NEWS.md` when it is updated.


```r
gert::git_add(files = ".")
```

<PRE class="fansi fansi-output"><CODE>## <span style='color: #949494;'># A tibble: 1 x 3</span><span>
##   file      status staged
##   </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>     </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #949494;font-style: italic;'>&lt;lgl&gt;</span><span> 
## </span><span style='color: #BCBCBC;'>1</span><span> R/super.R new    TRUE
</span></CODE></PRE>

```r
gert::git_commit(message = "- Add support for frobmication.")
```

```
## [1] "21782d1754f1e6386143fe3e7367db20283357a7"
```

### Create a test

The code in `super.R` warrants a test:


```r
usethis::use_test("super")
```

<PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Adding </span><span style='color: #0000BB;'>'testthat'</span><span> to </span><span style='color: #00BB00;'>Suggests</span><span> field in DESCRIPTION
</span></CODE></PRE><PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Creating </span><span style='color: #0000BB;'>'tests/testthat/'</span><span>
</span></CODE></PRE><PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Writing </span><span style='color: #0000BB;'>'tests/testthat.R'</span><span>
</span></CODE></PRE><PRE class="fansi fansi-message"><CODE>## <span style='color: #00BB00;'>✓</span><span> Writing </span><span style='color: #0000BB;'>'tests/testthat/test-super.R'</span><span>
</span></CODE></PRE><PRE class="fansi fansi-message"><CODE>## <span style='color: #BB0000;'>●</span><span> Edit </span><span style='color: #0000BB;'>'tests/testthat/test-super.R'</span><span>
</span></CODE></PRE>

```r
cat(readLines("tests/testthat/test-super.R"), sep = "\n")
```

```
## test_that("multiplication works", {
##   expect_equal(2 * 2, 4)
## })
```

In a real project we would substitute the testing code from the template by real tests.
In this demo we commit straight away, again with a bulleted message.


```r
gert::git_add(files = ".")
```

<PRE class="fansi fansi-output"><CODE>## <span style='color: #949494;'># A tibble: 3 x 3</span><span>
##   file                        status   staged
##   </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>                       </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>    </span><span style='color: #949494;font-style: italic;'>&lt;lgl&gt;</span><span> 
## </span><span style='color: #BCBCBC;'>1</span><span> DESCRIPTION                 modified TRUE  
## </span><span style='color: #BCBCBC;'>2</span><span> tests/testthat.R            new      TRUE  
## </span><span style='color: #BCBCBC;'>3</span><span> tests/testthat/test-super.R new      TRUE
</span></CODE></PRE>

```r
gert::git_status()
```

<PRE class="fansi fansi-output"><CODE>## <span style='color: #949494;'># A tibble: 3 x 3</span><span>
##   file                        status   staged
##   </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>                       </span><span style='color: #949494;font-style: italic;'>&lt;chr&gt;</span><span>    </span><span style='color: #949494;font-style: italic;'>&lt;lgl&gt;</span><span> 
## </span><span style='color: #BCBCBC;'>1</span><span> DESCRIPTION                 modified TRUE  
## </span><span style='color: #BCBCBC;'>2</span><span> tests/testthat.R            new      TRUE  
## </span><span style='color: #BCBCBC;'>3</span><span> tests/testthat/test-super.R new      TRUE
</span></CODE></PRE>

```r
gert::git_commit(message = "- Add tests for frobnication.")
```

```
## [1] "48eca9dd6235754c335bdfa15388f4d679a10762"
```

### Update NEWS.md

We use `fledge::bump_version()` to assign a new dev version number to the package and also update `NEWS.md`.





























