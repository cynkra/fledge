check_gh_pat <- function(needed_scopes = "repo") {
  # Checks are always successful if no GitHub is requested
  if (nzchar(Sys.getenv("FLEDGE_TEST_NOGH"))) {
    return(TRUE)
  }

  if (!nzchar(gh::gh_token()) || nzchar(Sys.getenv("FLEDGE_TEST_NO_PAT"))) {
    cli::cli_abort(
      message = c(
        x = "Can't find a GitHub Personal Access Token (PAT).",
        i = 'See for instance {.code ?gh::gh_token} or {.url https://usethis.r-lib.org/reference/github-token.html}'
      )
    )
  }

  if (is.null(needed_scopes)) {
    # For the V4 API, the API itself will error if there is a problem
    # but for the issues linked from a PR, no scope needed
    return(TRUE)
  }

  scopes <- "repo"

  current_scopes <- gh_scopes()
  missing_scopes <- scopes[!(scopes %in% current_scopes)]

  if (length(missing_scopes) > 0) {
    cli::cli_abort(
      message = c(
        x = "Missing scopes for GitHub V3 API (used for opening a PR): {.val {toString(missing_scopes)}}",
        i = 'See for instance https://usethis.r-lib.org/reference/github-token.html'
      )
    )
  }
}

gh_scopes <- function() {
  if (nzchar(Sys.getenv("FLEDGE_TEST_SCOPES")) || nzchar(Sys.getenv("FLEDGE_GHA_CI"))) {
    "repo"
  } else if (nzchar(Sys.getenv("FLEDGE_TEST_SCOPES_BAD"))) {
    "useless"
  } else {
    trimws(strsplit(gh::gh_whoami()[["scopes"]], ",")[[1]])
  }
}
