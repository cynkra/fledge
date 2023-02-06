# File editing ------

update_news_impl <- function(commits, which) {
  news_items <- collect_news(commits)
  news_items <- normalize_news(news_items)
  news_lines <- organize_news(news_items)

  if (fledge_chatty()) {
    cli_h2("Updating NEWS")
    cli_alert("Adding new entries to {.file {news_path()}}.")
  }

  fledgeling <- read_fledgling()

  # isTRUE() as NEWS.md can be empty
  dev_header_present <- isTRUE(
    grepl(
      "(development version)",
      fledgeling[["news"]][["title"]][1]
    )
  )

  if (which == "auto") {
    if (dev_header_present) {
      which <- "samedev"
    } else {
      which <- "dev"
    }
  }

  if (which == "samedev") {
    if (!dev_header_present) {
      rlang::abort("Can't find a development version NEWS header")
    }

    # Append and regroup
    if (is.null(fledgeling[["news"]])) {
      fledgeling[["news"]] <- tibble::tibble(
        start = 3,
        h2 = FALSE,
        version = fledgeling[["version"]],
        date = "",
        nickname = "",
        original = "",
        news = list(parse_news_md(news_lines)),
        raw = "",
        section_state = "new"
      )
    } else {
      combined <- c(
        parse_news_md(news_lines),
        fledgeling[["news"]][1, ]$news[[1]]
      )
      combined <- purrr::discard(combined, purrr::is_empty)
      fledgeling[["news"]][1, ]$news <- list(
        regroup_news(combined)
      )
      fledgeling[["news"]][1, ]$section_state <- "new"
    }
    write_fledgling(fledgeling)

    if (fledge_chatty()) {
      cli_alert("Added items to {.file {news_path()}}.")
    }
  } else {
    current_version <- desc::desc_get_version()
    new_version <- fledge_guess_version(current_version, which)
    fledgeling[["version"]] <- new_version

    # In the galley test for the demo vignette, for some reason, `is.na(get_date())`
    if (!is.null(fledgeling[["date"]]) && !is.na(get_date())) {
      fledgeling[["date"]] <- as.character(get_date())
    }

    section_df <- tibble::tibble(
      start = 3,
      end = NA,
      h2 = fledgeling[["news"]][["h2"]][1] %||% FALSE,
      version = new_version,
      date = maybe_date(fledgeling[["news"]]),
      nickname = NA,
      news = list(parse_news_md(news_lines)),
      raw = "",
      title = "",
      section_state = "new"
    )

    if (is.null(fledgeling[["news"]])) {
      fledgeling[["news"]] <- section_df
    } else {
      fledgeling[["news"]] <- rbind(
        section_df,
        fledgeling[["news"]]
      )
    }

    write_fledgling(fledgeling)

    if (fledge_chatty()) {
      cli_h2("Updating Version")

      cli_alert_success("Package version bumped to {.field {new_version}}.")

      cli_alert("Added header to {.file {news_path()}}.")
    }
  }
}

news_path <- function() {
  "NEWS.md"
}

news_preamble <- function() {
  "<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->"
}

edit_news <- function() {
  local_options(usethis.quiet = TRUE)
  edit_file(news_path())
}

edit_cran_comments <- function() {
  local_options(usethis.quiet = TRUE)
  edit_file("cran-comments.md")
}

maybe_date <- function(df) {
  # escape hatch for tests
  if (nzchar(Sys.getenv("FLEDGE_EMPTY_DATE"))) {
    return("")
  }

  formatted_date <- sprintf("(%s)", as.character(get_date()))

  # starting with an empty changelog,
  # return date
  if (is.null(df)) {
    return(formatted_date)
  }

  # if existing headers,
  # use date only if the latest one uses date
  if (is_non_empty_string(df[["date"]][1])) {
    formatted_date
  } else {
    ""
  }
}

# Normalization ----

capitalize_if_not_start_with_pkg <- function(x) {
  # leave package name alone
  pkg_name <- desc::desc_get("Package")
  pkg_name_regex <- sprintf("^%s(?: |'s)", pkg_name)
  start_with_pkg <- grepl(pkg_name_regex, x)

  x[!start_with_pkg] <- capitalize(x[!start_with_pkg])
  x
}

capitalize <- function(x) {
  # capitalization
  # Non-alphabetic characters are left unchanged.
  x <- paste0(
    toupper(substr(x, 1, 1)),
    substr(x, 2, nchar(x))
  )
  x
}

add_full_stop <- function(x) {
  # Replace only the first bullet
  sub("([^!?.])($|\n)", "\\1.\\2", x)
}

normalize_news <- function(df) {
  if (nrow(df) == 0) {
    return(df)
  }
  df$description <- capitalize_if_not_start_with_pkg(df$description)
  df$description <- add_full_stop(df$description)
  df
}

regroup_news <- function(list) {
  unique_names <- unique(names(list))
  # merge groups with the same name
  groups <- purrr::map(unique_names, merge_news_group, list)
  groups <- stats::setNames(groups, unique_names)
  # put custom first
  not_custom <- c(names(conventional_commit_types()), default_type())
  custom_names <- unique_names[!(unique_names %in% not_custom)]
  unique_names <- factor(unique_names, levels = c(custom_names, not_custom))
  groups[order(unique_names)]
}

merge_news_group <- function(name, groups) {
  this_group <- do.call(
    c,
    purrr::map(groups[names(groups) == name], unlist, recursive = FALSE)
  )
  this_group <- unique(this_group[this_group != ""])
  unname(this_group)
}

# Grouping -------

organize_news <- function(news_items) {
  # Repeat breaking changes in a distinct section
  breaking <- news_items[news_items$breaking, ]
  breaking$type <- "Breaking changes"
  news_items <- rbind(news_items, breaking)

  news_types <- split(news_items, news_items$type)

  # Order
  types <- names(news_types)
  present_types <- unique(news_items$type)
  standard_types <- c(names(conventional_commit_types()), "Breaking changes", default_type())
  custom_types <- present_types[!(present_types %in% standard_types)]
  types <- factor(types, levels = c(names(conventional_commit_types()), "Breaking changes", custom_types, default_type()))
  order <- order(types)
  news_types <- news_types[order]
  purrr::map_chr(news_types, treat_type_items)
}

treat_type_items <- function(df, header = TRUE) {
  items <- split(df, seq_len(nrow(df))) %>%
    purrr::map(add_hyphen) %>%
    purrr::map_chr(add_scope) %>%
    glue::glue_collapse(sep = "\n\n")

  if (!header) {
    sprintf("%s", items)
  } else {
    type <- df$type[1]
    sprintf("## %s\n\n%s", type, items)
  }
}

add_scope <- function(row) {
  if (is.na(row$scope)) {
    row$description
  } else {
    sprintf("### %s \n\n%s", row$scope, row$description)
  }
}
add_hyphen <- function(row) {
  row$description <- sprintf("- %s", row$description)
  row
}

bind_rows <- function(df_list) {
  do.call(rbind, df_list)
}

fledge_guess_version <- function(version, which) {
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

get_news_headers <- function() {
  read_fledgling()[["news"]][, c("start", "version", "date", "nickname")]
}

get_date <- function() {
  # For stable tests
  if (Sys.getenv("FLEDGE_DATE") != "") {
    return(as.Date(Sys.getenv("FLEDGE_DATE")))
  }
  # For stable Rmarkdown output
  if (Sys.getenv("IN_PKGDOWN") == "") {
    return(Sys.Date())
  }
  author_time <- parsedate::parse_iso_8601(Sys.getenv("GIT_COMMITTER_DATE"))
  as.Date(author_time)
}
