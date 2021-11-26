#' Update NEWS.md and DESCRIPTION with a new version
#'
#' Bumps a version component and adds to `NEWS.md` and `DESCRIPTION`.
#'
#' @example man/examples/tag-version.R
#'
#' @export
update_version <- function(which = "dev") {
  check_which(which)
  update_version_impl(which)
  invisible(NULL)
}

#' @rdname update_version
#' @usage NULL
#' @aliases NULL
check_which <- function(which) {
  #' @param which Component of the version number to update. Supported
  #'   values are `"dev"` (default), `"patch"`, `"minor"` and `"major"`.
  stopifnot(
    is.character(which), length(which) == 1, !is.na(which),
    which %in% c("dev", "patch", "minor", "major")
  )
}
