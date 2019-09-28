## fledge

_fledge_ has been designed to streamline the process of versioning R packages on _Git_, with the functionality to update `NEWS.md` and `Description` with relevant information from recent commit messages.  
For details on usage and implementation, refer the [Get Started](get-started-link) vignette.
      
## Demo
Click [here][demo_url] to view a demo of _fledge_ in action.

## Installation
Install from GitHub using

```
remotes::install_github("krlmlr/fledge")
```
## Usage

Run _fledge_ commands from your package directory for versioning as below.

* To configure your package for the first-time with _fledge_, use

    ```
    fledge::bump_version()
    fledge::finalize_version()
    ```
 Use bullet points (`*` or `-`) in your commit or merge messages to indicate the messages that you want to include in NEWS.md

* To assign a new "`dev`" version number to the R package and update `NEWS.md`, use
 
    ```
    fledge::bump_version()
    fledge::finalize_version()
    ```

* To assign a new version number to the R package before release to CRAN, use

    ```
    fledge::bump_version(which)
    fledge::commit_version()
    ```
where `which` can be "`patch`", "`minor`" or "`major`" as applicable.

* To tag a version when the package has been accepted to CRAN, use

    ```
    fledge::tag_version(force = TRUE)
    fledge::bump_version()
    ```

[get-started-link]: http://PutGetStartedLinkHere.com
[demo_url]: https://asciinema.org/a/173876