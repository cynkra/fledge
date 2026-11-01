# Create example repo for fledge demos

Create example repo for fledge demos

## Usage

``` r
create_demo_project(
  open = rlang::is_interactive(),
  name = "tea",
  maintainer = NULL,
  email = NULL,
  date = "2021-09-27",
  dir = file.path(tempdir(), "fledge"),
  news = FALSE
)
```

## Arguments

- open:

  Whether to open the new project.

- name:

  Package name.

- maintainer:

  Name for DESCRIPTION and git.

- email:

  Email for DESCRIPTION and git.

- date:

  String of time for DESCRIPTION and git.

- dir:

  Directory within which to create the mock package folder.

- news:

  If TRUE, create a NEWS.md file.

## Value

The path to the newly created mock package.
