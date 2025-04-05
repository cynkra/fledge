parse_versions <- function(version_headers) {
  list <- purrr::map(version_headers, parse_version)
  do.call(rbind, list)
}

parse_version <- function(version_header) {
  version_header <- trimws(version_header)

  header_rx <- '^(?<prefix>[a-zA-Z ]*?[a-zA-Z][a-zA-Z0-9. ]*[a-zA-Z0-9]) +v?(?<version>[0-9][0-9.-]*) *(?<date>\\(.*\\))? *(?<nickname>["\'].*["\'])?$'
  released_df <- rematch2::re_match(version_header, header_rx)[1:5]

  if (!nzchar(released_df[["nickname"]])) {
    released_df[["nickname"]] <- NA_character_
  }
  if (!nzchar(released_df[["date"]])) {
    released_df[["date"]] <- NA_character_
  }

  dev_header_rx <- '^(?<prefix>[a-zA-Z ]*?[a-zA-Z][a-zA-Z0-9. ]*[a-zA-Z0-9]) +(?<version>\\(development version\\))'
  dev_df <- rematch2::re_match(version_header, dev_header_rx)[1:3]

  if (is.na(dev_df[["version"]])) {
    released_df
  } else {
    dev_df[["nickname"]] <- NA_character_
    dev_df[["date"]] <- NA_character_
    dev_df
  }
}

fledge_guess_version <- function(version, which) {
  version_components <- get_version_components(version)
  dev <- version_components[["dev"]]
  patch <- version_components[["patch"]]
  minor <- version_components[["minor"]]
  major <- version_components[["major"]]

  if (grepl("^[0-9]+[.][0-9]+[.][0-9]+(?:[.][0-9]+)?$", as.character(which))) {
    if (as.character(which) < version) {
      cli_abort(
        "Can't release a version ({.val {which}}) lower than the current version ({.val {version}})."
      )
    }

    return(which)
  }

  if (which %in% c("patch", "minor", "major", "dev")) {
    dev <- switch(which,
      dev = {
        if (!is.na(dev) && dev >= 9999) {
          cli::cli_abort(
            "Can't increase version dev component ({.val {dev}}) that is >= 9999."
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
          cli::cli_abort(
            "Can't increase version patch component {.val {patch}} that is >= 99."
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
          cli::cli_abort(
            "Can't increase version minor component ({.val {minor}}) that is >= 99."
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
  } else if (which == "pre-patch") {
    dev <- max(dev + 1, 9900)
  } else if (which == "pre-minor") {
    if (patch > 99) {
      cli::cli_abort("Can't bump to {.val {which}} from version {.val {version}} (patch > 99).")
    } else if (patch == 99) {
      dev <- max(dev + 1, 9900)
    } else {
      patch <- 99
      dev <- 9900
    }
  } else if (which == "pre-major") {
    if (minor > 99) {
      cli::cli_abort("Can't bump to {.val {which}} from version {.val {version}} (minor > 99).")
    } else if (minor == 99) {
      dev <- max(dev + 1, 9900)
    } else {
      dev <- 9900
      patch <- 99
      minor <- 99
    }
  } else if (which == "same") {
    dev <- NA
  } else {
    cli::cli_abort("Unknown version specifier {.val {which}}.")
  }

  version_components <- c(
    major = major,
    minor = minor,
    patch = patch,
    dev = dev
  )
  paste(version_components[!is.na(version_components)], collapse = ".")
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

is_dev_version <- function(version) {
  classed_version <- package_version(version, strict = TRUE)
  unclassed_version <- unclass(classed_version)[[1]]
  length(unclassed_version) >= 4 && unclassed_version[[4]] >= 9000
}
