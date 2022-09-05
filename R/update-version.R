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

  dates <- grep("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", headers$extra)
  length(dates) > 0
}

get_news_headers <- function() {
  news <- readLines(news_path())
  rx <- "^# +(?<package>[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9]) +(?<version>[0-9][0-9.-]*) *(?<extra>.*)$"
  out <- rematch2::re_match(news, rx)
  out <- tibble::add_column(out, line = seq_len(nrow(out)), .before = 1)
  out[!is.na(out$package), grep("^[^.]", names(out), value = TRUE)]
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

  if (which %in% c("patch", "minor", "major", "dev")) {
    version_components[["dev"]] <- switch(which,
      dev = {
        if (!is.na(version_components[["dev"]]) && version_components[["dev"]] >= 9999) {
          rlang::abort(
            sprintf(
              "Can't increase version dev component (%s) that is >= 9999.",
              version_components[["dev"]]
            )
          )
        }
        if (is.na(version_components[["dev"]])) {
          9000
        } else {
          version_components["dev"] + 1
        }
      },
      NA
    )

    version_components[["patch"]] <- switch(which,
      dev = version_components[["patch"]],
      patch = {
        if (version_components[["patch"]] >= 99) {
          rlang::abort(
            sprintf(
              "Can't increase version patch component (%s) that is >= 99.",
              version_components[["patch"]]
            )
          )
        }
        version_components["patch"] + 1
      },
      0
    )

    version_components[["minor"]] <- switch(which,
      dev = version_components[["minor"]],
      patch = version_components[["minor"]],
      minor = {
        if (version_components[["minor"]] >= 99) {
          rlang::abort(
            sprintf(
              "Can't increase version minor component (%s) that is >= 99.",
              version_components[["minor"]]
            )
          )
        }
        version_components["minor"] + 1
      },
      major = 0
    )

    version_components[["major"]] <- switch(which,
      major = version_components[["major"]] + 1,
      version_components[["major"]]
    )
  } else {
    # pre-minor and pre-major

    if (is.na(version_components["dev"])) {
      rlang::abort(sprintf("Can't update version from not dev to %s.", which))
    }

    if (version_components["patch"] > 99) {
      rlang::abort(sprintf("Can't bump to %s from version %s (patch > 99).", which, version))
    }

    if (version_components["minor"] > 99) {
      rlang::abort(sprintf("Can't bump to %s from version %s (minor > 99).", which, version))
    }

    version_components["dev"] <- "9000"
    version_components["patch"] <- "99"
    # pre-minor: make patch 99
    # pre-major: make both minor and patch 99
    if (which == "pre-major") {
      version_components["minor"] <- "99"
    }
  }

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
