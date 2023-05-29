parse_versions <- function(version_headers) {
  list <- purrr::map(version_headers, parse_version)
  do.call(rbind, list)
}

parse_version <- function(version_header) {
  version_header <- trimws(version_header)

  header_rx <- '^(?<prefix>[a-zA-Z ]*?[a-zA-Z][a-zA-Z0-9. ]*[a-zA-Z0-9]) +(?<version>v?[0-9][0-9.-]*) *(?<date>\\(.*\\))? *(?<nickname>["\'].*["\'])?$'
  released_df <- rematch2::re_match(version_header, header_rx)[1:5]

  released_df[["version"]] <- sub("^v", "", released_df[["version"]])
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
    dev_df[["version"]] <- sub("^v", "", dev_df[["version"]])
    dev_df[["nickname"]] <- NA_character_
    dev_df[["date"]] <- NA_character_
    dev_df
  }
}
