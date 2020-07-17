check_pre_release_state <- function(which, force = FALSE) {

  # check version number
  if (length(strsplit(as.character(desc::desc_get_version()), "[.]|-")[[1]]) < 4) {
    ui_oops(paste0(
      ui_code("pre_release()"),
      ": Package versions needs to indicate a dev version before calling ",
      ui_code("pre_release()"), "."
    ))
    state <- FALSE
    return(state)
  } else if (file.exists("cran-comments.md")) {
    ui_oops(paste0(ui_code("pre_release()"), ": cran-comments.md already exists."))
    state <- FALSE
    return(state)
  } else if (file.exists("CRAN-RELEASE")) {
    ui_oops(paste0(ui_code("pre_release()"), ": CRAN-RELEASE already exists."))
    state <- FALSE
    return(state)
  } else if (git2r::is_branch(sprintf("cran-%s", update_version_helper(which)))) {
    ui_oops(sprintf(paste0(
      ui_code("pre_release()"),
      ": 'cran-%s' branch already exists.", update_version_helper(which)
    )))
    state <- FALSE
  } else {
    state <- TRUE
  }
}
