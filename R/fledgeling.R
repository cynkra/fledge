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

read_fledgeling <- function() {
  package <- unname(desc::desc_get("Package"))
  version <- desc::desc_get_version()

  if (file.exists("NEWS.md")) {
    news <- readLines("NEWS.md")
  } else {
    news <- character()
  }

  header_rx <- '^# +[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9] +(?<version>[0-9][0-9.-]*) *(?<date>\\(.*\\))? *(?<nickname>".*")?$'

  first_level_headers <- grep(header_rx, news, perl = TRUE)
  start <- first_level_headers + 1L
  end <- c(first_level_headers[-1] - 1L, length(news))

  header_df <- rematch2::re_match(news[first_level_headers], header_rx)[1:3]
  header_df$news <- map2(start, end, ~ trim_empty_lines(news[seq2(.x, .y)]))

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
