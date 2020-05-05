is_news_consistent <- function() {
  headers <- with_repo(get_news_headers())

  versions <- package_version(headers, strict = TRUE)

  all(lengths(unclass(versions)) <= 3)
}


get_news_headers <- function() {
  news_path <- "NEWS.md"
  news <- readLines(news_path)
  top_level_headers <- grep("^# [a-zA-Z][a-zA-Z0-9.]+[a-zA-Z0-9] [0-9.-]+", news)
  top_level_headers <- utils::head(top_level_headers, 2)
  gsub("^# [^0-9]+", "", news[top_level_headers])
}


confirm_submission <- function(url) {
  parsed <- httr::parse_url(url)

  parsed$query$policy_check2 <- "on"
  parsed$query$policy_check3 <- "on"
  parsed$query$policy_check4 <- "on"
  parsed$query$confirm_submit <- "Upload Package to CRAN"

  url <- httr::build_url(parsed)
  rlang::inform(glue::glue("Visiting {url}"))
  utils::browseURL(url)
}
