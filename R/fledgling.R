#' fledgling object
#'
#' Contains the information that fledge manages about a repository.
#' The internal structure of this object is subject to change.
#'
#' @param name The name of the package
#' @param version A [package_version] that describes the current version
#' @param date The package date, or `NULL` if not present in `DESCRIPTION`
#' @param preamble The text that appears before the first section header
#' @param news A data frame FIXME
#' @noRd
new_fledgling <- function(name, version, date, preamble, news, preamble_in_file) {
  structure(
    list(
      name = name,
      version = version,
      date = date,
      preamble = preamble,
      news = news,
      preamble_in_file = preamble_in_file
    ),
    class = "fledgling"
  )
}

read_package <- function() {
  unname(desc::desc_get("Package"))
}

read_version <- function() {
  desc::desc_get_version()
}

read_date <- function() {
  desc::desc_get_field("Date", default = NULL)
}

read_news <- function(news_lines = NULL) {
  if (is.null(news_lines)) {
    if (file.exists(news_path())) {
      news_lines <- readLines(news_path())
    } else {
      news_lines <- character()
    }
  }

  news <- parse_news_md(news_lines, strict = TRUE)

  if (is.null(news)) {
    return(
      list(
        section_df = NULL,
        preamble = news_preamble(),
        preamble_in_file = FALSE
      )
    )
  }

  # NEWS content under no version
  if (length(news) == 1 && !nzchar(names(news))) {
    cli::cli_abort("All {.file NEWS.md} content must be under version headers.")
  }

  # match parsed headers to the Markdown
  get_section_start <- function(section_title, news_lines) {
    escaped_section_title <- sub("\\(", "\\\\(", section_title)
    escaped_section_title <- sub("\\)", "\\\\)", escaped_section_title)
    section_start <- which(grepl(sprintf("^(#+ +)?%s[:space:]?$", escaped_section_title), news_lines))

    if (length(section_start) == 0) {
      # what to do
    }

    if (length(section_start) > 1) {
      # what to do
    }
    section_start
  }

  duplicate_version_names_present <- anyDuplicated(names(news))
  if (duplicate_version_names_present) {
    duplicated_version_names <- toString(names(news)[duplicated(names(news))])
    cli::cli_abort(
      c(
        "Can't deal with duplicate version names: {duplicated_version_names}.",
        i = "Fix the duplication then retry."
      )
    )
  }

  starts <- purrr::map_int(names(news), get_section_start, news_lines)
  ends <- c(starts[seq_along(starts[-1]) + 1] - 1L, length(news_lines))

  section_df <- tibble::tibble(
    start = starts,
    end = ends,
    h2 = grepl("##", news_lines[starts]), # TODO does not account for all syntaxes,
    raw = map2_chr(starts, ends, ~ paste(news_lines[seq2(.x, .y)], collapse = "\n")),
    news = unname(split(news, seq_len(length(news))))
  )

  section_df$section_state <- "keep"

  section_df$title <- names(news)

  parsed_titles <- parse_versions(names(news))[, c("version", "date", "nickname")]

  section_df <- vctrs::vec_cbind(section_df, parsed_titles)

  fix_name_and_level <- function(news_list) {
    if (is.null(news_list)) {
      return(news_list)
    }

    if (!is.list(news_list[[1]])) {
      if (length(news_list[[1]]) == 1 && !nzchar(news_list[[1]])) {
        return(NULL)
      }
      names(news_list) <- default_type()
      return(news_list)
    }

    unlist(news_list[[1]], recursive = FALSE)
  }
  section_df$news <- map(section_df$news, fix_name_and_level)

  # create, update or re-use preamble
  is_preamble_absent <- (section_df[["start"]][[1]] == 1)
  if (is_preamble_absent) {
    preamble_in_file <- FALSE
    preamble <- news_preamble()
  } else {
    preamble_in_file <- TRUE
    preamble <- trim_empty_lines(news_lines[seq2(1, section_df[["start"]][[1]] - 1)])

    is_outdated_fledge_preamble <- (trimws(preamble) %in% old_news_preambles())
    if (is_outdated_fledge_preamble) preamble <- news_preamble()

    # FIXME: check the "preamble" is an HTML comment?
  }
  list(
    section_df = section_df,
    preamble = if (!is.null(preamble)) paste(preamble, collapse = "\n"),
    preamble_in_file = preamble_in_file
  )
}

read_fledgling <- function() {
  package <- read_package()
  version <- read_version()
  date <- read_date()

  news_and_preamble <- read_news()

  new_fledgling(
    package,
    version,
    date,
    preamble = news_and_preamble[["preamble"]],
    news = news_and_preamble[["section_df"]],
    preamble_in_file = news_and_preamble[["preamble_in_file"]]
  )
}

trim_empty_lines <- function(x) {
  for (start in seq_along(x)) {
    if (x[[start]] != "") {
      break
    }
  }

  for (end in rev(seq2(start, length(x)))) {
    if (x[[end]] != "") {
      break
    }
  }

  x[seq2(start, end)]
}

write_fledgling <- function(fledgeling) {
  force(fledgeling)

  # store version
  desc::desc_set_version(
    fledgeling$version,
    file = "DESCRIPTION"
  )

  if (!is.null(fledgeling$date)) {
    desc::desc_set(Date = fledgeling$date)
  }

  # store news

  news_df <- fledgeling[["news"]]
  news_lines <- purrr::map_chr(
    split(news_df, seq_len(nrow(news_df))),
    write_news_section
  )
  news_lines <- unprotect_hashtag(news_lines)

  lines <- c(
    fledgeling[["preamble"]], "",
    paste0(news_lines, collapse = "\n\n")
  )
  brio::write_lines(lines, news_path())
}

write_news_section <- function(df) {
  if (df$section_state == "keep") {
    # remove the lines that will be re-added
    raw <- sub("\n$", "", df$raw)
    return(raw)
  }

  # isTRUE as sometimes there is no previous header
  # so h2 is NULL not FALSE
  if (isTRUE(df$h2)) {
    header_sign <- "##"
  } else {
    header_sign <- "#"
  }

  version_header <- trimws(
    sprintf(
      "%s %s %s %s %s",
      header_sign,
      read_package(),
      df$version,
      if (!is.na(df$date)) df$date else "",
      if (!is.na(df$nickname)) df$nickname else ""
    )
  )

  if (isTRUE(df$h2)) {
    header_level <- 3
  } else {
    header_level <- 2
  }

  raw <- df$raw

  # If only uncategorized items for the version, no subheaders
  if (grepl(paste0("^#+ ", default_type()), raw)) {
    raw <- gsub("^#+ [^\n]*\n\n", "", raw)
  }

  section_lines <- c(version_header, "", raw, "")

  paste0(section_lines, collapse = "\n")
}

format_news_subsections <- function(news_list, header_level) {
  header_sign <- paste(rep("#", header_level), collapse = "")

  lines <- purrr::imap_chr(
    news_list,
    ~ sprintf(
      "%s %s\n\n%s",
      header_sign,
      .y,
      paste_news_lines(.x, header_level = header_level + 1)
    ),
  )

  paste(lines, collapse = "\n\n")
}

paste_news_lines <- function(lines, header_level) {
  lines <- unlist(lines, recursive = FALSE)
  if (is_any_named(lines)) {
    header_sign <- paste(rep("#", header_level), collapse = "")
    sub_header <- function(x, header_sign) {
      if (!nzchar(x)) {
        ""
      } else {
        paste(header_sign, x, "\n\n")
      }
    }
    lines <- purrr::imap_chr(
      lines,
      ~ sprintf(
        "%s%s",
        sub_header(.y, header_sign),
        paste_news_lines(.x, header_level = header_level + 1)
      )
    )
    paste(lines, collapse = "\n\n")
  } else {
    paste(lines, collapse = "\n")
  }
}
