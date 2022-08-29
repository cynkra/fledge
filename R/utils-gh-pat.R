check_gh_pat <- function(needed_scopes = "repo") {
  if (!nzchar(gh::gh_token()) || nzchar(Sys.getenv("FLEDGE_TEST_NO_PAT"))) {
    abort(
      message = c(
        x = "Can't find a GitHub Personal Access Token (PAT).",
        i = 'See for instance `?gh::gh_token` or https://usethis.r-lib.org/reference/github-token.html'
      )
    )
  }

  scopes <- switch(needed_scopes,
    repo = "repo",
    v4_api = v4_scopes()
  )
  current_scopes <- gh_scopes()
  missing_scopes <- scopes[!(scopes %in% current_scopes)]

  if (length(missing_scopes) > 0) {
    if (needed_scopes == "repo") {
      abort(
        message = c(
          x = sprintf("Missing scopes for GitHub V3 API (used for opening a PR): %s", toString(missing_scopes)),
          i = 'See for instance https://usethis.r-lib.org/reference/github-token.html'
        )
      )
    } else {
      abort(
        message = c(
          x = sprintf("Missing scopes for GitHub GraphQL API (used for finding issues linked to PR): %s", toString(missing_scopes)),
          i = 'See https://docs.github.com/en/graphql/guides/forming-calls-with-graphql'
        )
      )
    }
  }
}

v4_scopes <- function() {
  c(
    "repo", "read:packages",
    "read:org", "read:public_key", "read:repo_hook",
    "user", "read:discussion", "read:enterprise",
    "read:gpg_key"
  )
}

gh_scopes <- function() {
  if (nzchar(Sys.getenv("FLEDGE_TEST_SCOPES"))) {
    v4_scopes()
  } else if (nzchar(Sys.getenv("FLEDGE_TEST_SCOPES_BAD"))) {
    "useless"
  } else {
    trimws(strsplit(gh::gh_whoami()[["scopes"]], ",")[[1]])
  }
}
