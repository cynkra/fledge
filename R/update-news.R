# File editing ------

update_news_impl <- function(commits) {
  news_items <- collect_news(commits)
  news_items <- normalize_news(news_items)
  news_lines <- regroup_news(news_items)

  if (fledge_chatty()) {
    cli_h2("Updating NEWS")
    cli_alert("Adding new entries to {.file {news_path()}}.")
  }

  add_to_news(news_lines)
}

news_path <- function() {
  "NEWS.md"
}

news_comment <- function() {
  "<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->"
}

add_to_news <- function(news) {
  if (!file.exists(news_path())) {
    file.create(news_path())
  }

  enc::transform_lines_enc(news_path(), make_prepend(news))
  invisible(news_path())
}

make_prepend <- function(news) {
  force(news)

  function(x) {
    # Not empty news file needs to be tweaked
    if (length(x) > 0) {
      # Remove fledge NEWS.md comment
      if (x[[1]] == news_comment()) {
        x <- x[-1]
        # Remove empty line at the top
        if (x[[1]] == "") {
          x <- x[-1]
        }
      }
    }

    c(news_comment(), "", news, x)
  }
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
    return(sprintf("%s\n\n", treat_type_items(news_items, header = FALSE)))
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
    c(purrr::map_chr(news_types, treat_type_items), ""),
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
