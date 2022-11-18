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

read_news_section <- function(lines) {
  # FIXME add function parsing subheaders to create named nested lists
  # it'd be great to use Pandoc with "--section-divs" here instead of
  # reinventing the wheel https://pandoc.org/MANUAL.html#options-affecting-specific-writers
}

read_news <- function() {
  if (file.exists("NEWS.md")) {
    news <- readLines("NEWS.md")
  } else {
    news <- character()
  }

  parse_news(news)
}

parse_news <- function(news) {
  header_rx <- '^#(?<h2>#)? +[a-zA-Z ]*?[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9] +(?<version>v?[0-9][0-9.-]*) *(?<date>\\(.*\\))? *(?<nickname>".*")?$'

  first_level_headers <- grep(header_rx, news, perl = TRUE)
  start <- first_level_headers
  end <- c(first_level_headers[-1] - 1L, length(news))

  section_df <- rematch2::re_match(news[first_level_headers], header_rx)[1:4]
  section_df <- tibble::add_column(section_df, line = first_level_headers, .before = 1)
  section_df <- tibble::add_column(section_df, original = news[first_level_headers])
  section_df$h2 <- (section_df$h2 == "#")
  section_df$news <- map2(start + 1L, end, ~ trim_empty_lines(news[seq2(.x, .y)]))
  section_df$raw <- map2_chr(start, end, ~ paste(news[seq2(.x, .y)], collapse = "\n"))

  if (length(first_level_headers) == 0) {
    preamble <- news
  } else if (first_level_headers[[1]] == 1) {
    preamble <- NULL
  } else {
    preamble <- trim_empty_lines(news[seq2(1, first_level_headers[[1]] - 1)])
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
  desc::desc_set_version(fledgeling$version, file = "DESCRIPTION")

  # store news
  news_df <- fledgeling$news

  write_one_section <- function(df) {
    if (df$h2) {
      header_sign <- "##"
    } else {
      header_sign <- "#"
    }
    section_lines <- c(
      trimws(sprintf("%s %s %s %s %s", header_sign, read_package(), df$version, df$date, df$nickname)), "",
      unlist(df$news), ""
    )
    paste0(section_lines, collapse = "\n")
  }

  news_lines <- purrr::map_chr(split(news_df, sort(as.numeric(rownames(news_df)))), write_one_section)

  lines <- c(
    fledgeling$preamble, "",
    paste0(news_lines, collapse = "\n")
  )

  brio::write_lines(lines, news_path())
}
