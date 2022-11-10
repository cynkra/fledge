#' fledgeling object
#'
#' Contains the information that fledge manages about a repository.
#' The internal structure of this object is subject to change.
#'
#' @param name The name of the package
#' @param version A [package_version] that describes the current verson
#' @param news A data frame
#' @noRd
new_fledgeling <- function(name, version, news) {
  structure(
    list(
      name = name,
      version = version,
      news = news
    ),
    class = "fledgeling"
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
}

read_news <- function() {
  if (file.exists("NEWS.md")) {
    news <- readLines("NEWS.md")
  } else {
    news <- character()
  }

  header_rx <- '^#(?<h2>#)? +[a-zA-Z ]*?[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9] +(?<version>v?[0-9][0-9.-]*) *(?<date>\\(.*\\))? *(?<nickname>".*")?$'

  first_level_headers <- grep(header_rx, news, perl = TRUE)
  start <- first_level_headers + 1L
  end <- c(first_level_headers[-1] - 1L, length(news))

  header_df <- rematch2::re_match(news[first_level_headers], header_rx)[1:4]
  header_df <- tibble::add_column(header_df, line = first_level_headers, .before = 1)
  header_df <- tibble::add_column(header_df, original = news[first_level_headers])
  header_df$h2 <- (header_df$h2 == "#")
  header_df$news <- map2(start, end, ~ trim_empty_lines(news[seq2(.x, .y)]))
  header_df
}

read_fledgeling <- function() {
  package <- read_package()
  version <- read_version()

  header_df <- read_news()

  new_fledgeling(package, version, header_df)
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
