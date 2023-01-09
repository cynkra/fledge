#' fledgling object
#'
#' Contains the information that fledge manages about a repository.
#' The internal structure of this object is subject to change.
#'
#' @param name The name of the package
#' @param version A [package_version] that describes the current version
#' @param preamble The text that appears before the first section header
#' @param news A data frame FIXME
#' @noRd
new_fledgling <- function(name, version, preamble, news) {
  structure(
    list(
      name = name,
      version = version,
      preamble = preamble,
      news = news
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

read_news <- function() {
  if (file.exists("NEWS.md")) {
    news <- readLines("NEWS.md")
  } else {
    news <- character()
  }

  parse_news(news)
}

get_header_df <- function(news, header_rx) {
  first_level_headers <- grep(header_rx, news, perl = TRUE)
  start <- first_level_headers

  if (length(start) == 0) {
    return(NULL)
  }

  end <- if (length(start) > 1) {
    c(first_level_headers[-1] - 1L, length(news))
  } else {
    min(which(grepl("^# ", news[(start + 1):length(news)])) - 1L, length(news) - start) + start
  }

  section_df <- rematch2::re_match(news[first_level_headers], header_rx)
  section_df <- section_df[-c(ncol(section_df) - 1, ncol(section_df))]
  section_df <- tibble::add_column(section_df, line = first_level_headers, .before = 1)
  section_df <- tibble::add_column(section_df, original = news[first_level_headers])
  section_df$h2 <- (section_df$h2 == "#")
  section_df$news <- map2(start + 1L, end, ~ parse_news_md(trim_empty_lines(news[seq2(.x, .y)])))

  fix_name <- function(news_list) {
    if (is.null(news_list)) {
      return(news_list)
    }

    if (is.null(names(news_list))) {
      stats::setNames(news_list, default_type())
    } else {
      news_list
    }
  }
  section_df$news <- map(section_df$news, fix_name)
  section_df$raw <- map2_chr(start, end, ~ paste(news[seq2(.x, .y)], collapse = "\n"))
  section_df
}

dev_header_rx <- function() {
  '^#(?<h2>#)? +[a-zA-Z ]*?[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9] +(?<version>\\(development version\\))?$'
}

header_rx <- function() {
  '^#(?<h2>#)? +[a-zA-Z ]*?[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9] +(?<version>v?[0-9][0-9.-]*) *(?<date>\\(.*\\))? *(?<nickname>".*")?$'
}

parse_news <- function(news) {
  section_df <- get_header_df(news, header_rx())
  dev_header <- get_header_df(news, dev_header_rx())

  if (!is.null(dev_header)) {
    section_df <- tibble::add_row(
      section_df,
      dev_header,
      .before = 1
    )
  }

  # changelog absent or empty
  if (is.null(section_df)) {
    return(
      list(
        section_df = NULL,
        preamble = news_preamble()
      )
    )
  }

  section_df$date[is.na(section_df$date)] <- ""
  section_df$nickname[is.na(section_df$nickname)] <- ""

  # re-use current preamble
  # FIXME: check the "preamble" is an HTML comment?
  if (section_df[["line"]][[1]] == 1) {
    preamble <- news_preamble()
  } else {
    preamble <- trim_empty_lines(news[seq2(1, section_df[["line"]][[1]] - 1)])
  }

  list(
    section_df = section_df,
    preamble = if (!is.null(preamble)) paste(preamble, collapse = "\n")
  )
}

read_fledgling <- function() {
  package <- read_package()
  version <- read_version()

  news_and_preamble <- read_news()

  new_fledgling(package, version, news_and_preamble$preamble, news_and_preamble$section_df)
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
  # store version
  desc::desc_set_version(
    fledgeling$version,
    file = "DESCRIPTION"
  )

  # store news

  news_df <- fledgeling$news
  news_lines <- purrr::map_chr(
    split(news_df, sort(as.numeric(rownames(news_df)))),
    write_news_section
  )
  news_lines <- unprotect_hashtag(news_lines)

  lines <- c(
    fledgeling$preamble, "",
    paste0(news_lines, collapse = "\n\n")
  )
  brio::write_lines(lines, news_path())
}

write_news_section <- function(df) {
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
      df$date,
      df$nickname
    )
  )

  # If only uncategorized items for the version, no subheaders
  if (length(df$news[[1]]) == 1 && names(df$news[[1]]) == default_type()) {
    section_lines <- c(
      version_header, "",
      paste(df$news[[1]][[1]], collapse = "\n"), ""
    )
  } else {
    if (isTRUE(df$h2)) {
      header_level <- 3
    } else {
      header_level <- 2
    }

    section_lines <- c(
      version_header, "",
      format_news_subsections(df$news[[1]], header_level), ""
    )
  }
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
