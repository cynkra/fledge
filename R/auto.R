is_news_consistent <- function() {
  last_two <- with_repo(get_two_news_headers())
  if (length(last_two) < 2) return(TRUE)

  length(unclass(package_version(last_two[[2]]))[[1]]) <= 3
}


get_two_news_headers <- function() {
  news_path <- "NEWS.md"
  news <- readLines(news_path)
  top_level_headers <- grep("^# [a-zA-Z][a-zA-Z0-9.]+[a-zA-Z0-9] [0-9.-]+", news)
  top_level_headers <- utils::head(top_level_headers, 2)
  gsub("^#[^0-9]+", "", news[top_level_headers])
}
