#' Check whether all versions NEWS.md have been git-tagged
#'
#' @return `NULL`
#' @export
#'
#' @example man/examples/check-tags.R
check_tags <- function() {
  versions <- get_news_headers()[["version"]]
  tags <- gsub("^v", "", gert::git_tag_list()[["name"]])

  untagged_versions <- versions[!(versions %in% tags)]
  if (length(untagged_versions) == 0) {
    return(NULL)
  }

  rlang::warn(
    sprintf(
      "Version%s with no corresponding tags: %s.",
      ifelse(length(untagged_versions) == 1, "", "s"),
      toString(untagged_versions)
    )
  )
  return(NULL)
}
