check_release_state <- function(which) {

  # meta info
  new_version <- desc::desc_get_version()
  pkg <- desc::desc_get_field("Package")
  version_components <- length(strsplit(as.character(desc::desc_get_version()), "[.]|-")[[1]])
  # mirrors do not seem to work (due to CRAN vacay?)
  cran_details <- withr::with_options(
    list(repos = structure(c(CRAN = "https://cloud.r-project.org/"))),
    tryCatch(foghorn::cran_details(pkg, src = "website"), error = function(e) {
      print("Package not yet on CRAN, skipping {foghorn} checks.")
      return(NULL)
    })
  )
  if (!is.null(cran_details)) {
    cran_version <- as.character(cran_details[1, "version"])
  }
  cran_inc <- withr::with_options(
    list(repos = structure(c(CRAN = "https://cloud.r-project.org/"))),
    {
      incoming <- foghorn::cran_incoming(
        pkg,
        c("pretest", "inspect", "pending", "publish", "waiting", "recheck")
      )
      ifelse(nrow(incoming) == 0, FALSE, TRUE)
    }
  )

  # determine state
  if (version_components == 4) {
    return("pre-release")
  } else if (new_version == cran_version) {
    return("accepted")
  } else if (cran_inc) {
    return("submitted")
  } else if (is_cran_comments_good()) {
    return("ready-to-release")
  } else {
    return("running-release-checks")
  }
}
