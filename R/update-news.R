# File editing ------

update_news_impl <- function(commits, which) {

  news_items <- collect_news(commits)
  news_items <- normalize_news(news_items)
  news_lines <- regroup_news(news_items)

  if (fledge_chatty()) {
    cli_h2("Updating NEWS")
    cli_alert("Adding new entries to {.file {news_path()}}.")
  }

  fledgeling <- read_fledgling()

  if (is.null(which)) {

    dev_header_present <- grepl("(development version)", fledgeling[["news"]][["version"]][1])

    if (!dev_header_present) {
      rlang::abort("Can't find a development version NEWS header")
    }

    # FIXME: add regrouping here!!
    fledgeling[["news"]][1,]$news <- list(
      paste(
        news_lines,
        fledgeling[["news"]][1,]$news,
        collapse = "\n\n"
      )
    )
    write_fledgling(fledgeling)

    if (fledge_chatty()) {
      cli_alert("Added items to {.file {news_path()}}.")
    }

  } else {
    current_version <- desc::desc_get_version()
    new_version <- fledge_guess_version(current_version, which)
    fledgeling[["version"]] <- new_version

    maybe_date <- function(df) {
      if (nzchar(df[["date"]][1])) {
        sprintf("(%s)", as.character(get_date()))
      } else {
        ""
      }
    }

    section_df <- tibble::tibble(
      line = 3,
      h2 = fledgeling[["news"]]$h2[1],
      version = new_version,
      date = maybe_date(fledgeling[["news"]]),
      nickname = "",
      original = "",
      news = list(news_lines),
      raw = ""
    )

    fledgeling[["news"]] <- rbind(
      section_df,
      fledgeling[["news"]]
    )
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

news_comment <- function() {
  "<!-- NEWS.md is maintained by https://fledge.cynkra.com/, do not edit -->"
}

edit_news <- function() {
  local_options(usethis.quiet = TRUE)
  edit_file(news_path())
}

edit_cran_comments <- function() {
  local_options(usethis.quiet = TRUE)
  edit_file("cran-comments.md")
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

# Grouping -------

regroup_news <- function(news_items) {
  ## Only uncategorized?
  if (isTRUE(all.equal(unique(news_items$type), default_type()))) {
    return(sprintf("%s", treat_type_items(news_items, header = FALSE)))
  }

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

  # Collapse and ensure the whole section is followed by an empty line
  glue::glue_collapse(
    c(purrr::map_chr(news_types, treat_type_items)),
    sep = "\n\n"
  )
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
