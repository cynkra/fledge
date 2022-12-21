update_version_impl <- function(which) {
  desc <- desc::desc(file = "DESCRIPTION")

  if (desc$has_fields("Date")) {
    desc$set("Date", get_date())
  }

  desc <- fledge_bump_version(desc, which)

  new_version <- desc$get_version()

  if (fledge_chatty()) {
    cli_h2("Updating Version")

    cli_alert_success("Package version bumped to {.field {new_version}}.")

    cli_alert("Adding header to {.file {news_path()}}.")
  }

  header <- paste0(
    "# ", desc$get("Package"), " ", new_version,
    if (date_in_news_headers()) paste0(" (", get_date(), ")"),
    "\n"
  )
  add_to_news(header)

  desc$write()
}

date_in_news_headers <- function() {
  headers <- get_news_headers()
  if (nrow(headers) == 0) {
    # Add date by default
    return(TRUE)
  }

  dates <- headers[["date"]][nzchar(headers[["date"]])]
  length(dates) > 0
}

get_news_headers <- function() {
  read_fledgling()[["news"]][, c("line", "version", "date", "nickname")]
}

get_date <- function() {
  # For stable Rmarkdown output
  if (Sys.getenv("IN_PKGDOWN") == "") {
    return(Sys.Date())
  }
  author_time <- parsedate::parse_iso_8601(Sys.getenv("GIT_COMMITTER_DATE"))
  as.Date(author_time)
}

fledge_bump_version <- function(desc, which) {
  version <- desc$get_version()
  version_components <- get_version_components(version)
  dev <- version_components[["dev"]]
  patch <- version_components[["patch"]]
  minor <- version_components[["minor"]]
  major <- version_components[["major"]]

  if (which %in% c("patch", "minor", "major", "dev")) {
    dev <- switch(which,
      dev = {
        if (!is.na(dev) && dev >= 9999) {
          rlang::abort(
            sprintf(
              "Can't increase version dev component (%s) that is >= 9999.",
              dev
            )
          )
        }
        if (is.na(dev)) {
          9000
        } else {
          dev + 1
        }
      },
      NA
    )

    patch <- switch(which,
      dev = patch,
      patch = {
        if (patch >= 99) {
          rlang::abort(
            sprintf(
              "Can't increase version patch component (%s) that is >= 99.",
              patch
            )
          )
        }
        patch + 1
      },
      0
    )

    minor <- switch(which,
      dev = minor,
      patch = minor,
      minor = {
        if (minor >= 99) {
          rlang::abort(
            sprintf(
              "Can't increase version minor component (%s) that is >= 99.",
              minor
            )
          )
        }
        minor + 1
      },
      major = 0
    )

    major <- switch(which,
      major = major + 1,
      major
    )
  } else {
    # pre-minor and pre-major

    if (is.na(dev)) {
      rlang::abort(sprintf("Can't update version from not dev to %s.", which))
    }

    if (patch >= 99) {
      rlang::abort(sprintf("Can't bump to %s from version %s (patch >= 99).", which, version))
    }

    if (minor >= 99) {
      rlang::abort(sprintf("Can't bump to %s from version %s (minor >= 99).", which, version))
    }

    dev <- "9000"
    patch <- "99"
    # pre-minor: make patch 99
    # pre-major: make both minor and patch 99
    if (which == "pre-major") {
      minor <- "99"
    }
  }

  version_components <- c(
    major = major,
    minor = minor,
    patch = patch,
    dev = dev
  )
  new_version <- paste(version_components[!is.na(version_components)], collapse = ".")
  desc$set_version(new_version)
  return(desc)
}

get_version_components <- function(version) {
  # from https://github.com/r-lib/desc/blob/daece0e5816e17a461969489bfdda2d50b4f5fe5/R/version.R#L53
  components <- as.numeric(strsplit(format(version), "[-\\.]")[[1]])
  c(
    major = components[1],
    minor = components[2],
    patch = components[3],
    dev = components[4] # can be NA
  )
}
