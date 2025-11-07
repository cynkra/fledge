# Automating CRAN release

`plan_release()` is run when a milestone in the development of a package
is reached and it is ready to be sent to CRAN. By default, this function
will initiate a pre-release, indicated by `9900` in the fourth component
of the version number. Pass `which = "patch"`, `which = "minor"`, or
`which = "major"` to initiate a release with the corresponding version
number.

`release()` sends to CRAN after performing several checks, and offers
help with accepting the submission.

`post_release()` should be called after the submission has been
accepted.

## Usage

``` r
plan_release(
  which = c("pre-patch", "pre-minor", "pre-major", "next", "patch", "minor", "major"),
  force = FALSE
)

release()

post_release()
```

## Arguments

- which:

  Component of the version number to update. Supported values are

  - `"pre-patch"` (default, `x.y.z.9900`)

  - `"pre-minor"` (`x.y.99.9900`),

  - `"pre-major"` (`x.99.99.9900`),

  - `"next"` (`"major"` if the current version is `x.99.99.9yyy`,
    `"minor"` if the current version is `x.y.99.9zzz`, `"patch"`
    otherwise),

  - `"patch"`

  - `"minor"`,

  - `"major"`.

- force:

  Create branches and tags even if they exist. Useful to recover from a
  previously failed attempt.

## Details

`plan_release()`:

- Ensures that no modified files are in the Git index.

- Creates a pre-release or release branch and bumps the version
  accordingly.

- Writes/updates `cran-comments.md` with useful information about the
  current release process.

- Runs
  [`urlchecker::url_update()`](https://rdrr.io/pkg/urlchecker/man/url_update.html),
  [`devtools::check_win_devel()`](https://devtools.r-lib.org/reference/check_win.html),
  and `rhub::rhub_check(platforms = rhub::rhub_platforms()$name)` in the
  background of the RStudio IDE, or prompts the user to do so.

- Opens a pull request for the release branch for final checks.
