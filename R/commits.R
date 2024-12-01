with_repo <- function(code) {
  withr::with_dir(usethis::proj_get(), code)
}

local_repo <- function(.local_envir = caller_env()) {
  withr::local_dir(usethis::proj_get(), .local_envir = .local_envir)
}

get_top_level_commits_impl <- function(since, ref = "HEAD") {
  commit <- gert::git_log(ref, max = 1)$commit

  commit <- get_first_parent(commit, since)
  message <- map_chr(commit, ~ gert::git_commit_info(.x)$message)
  merge <- map_lgl(commit, ~ (length(gert::git_commit_info(.x)$parents) > 1))
  tibble::tibble(commit, message, merge)
}

get_first_parent <- function(commit, since) {
  commits <- commit
  if (!is.null(since) && commit == since) {
    return(commits)
  }

  repeat {
    all_parents <- gert::git_commit_info(commit)$parents
    if (is_empty(all_parents)) {
      return(commits)
    }

    first_parent <- all_parents[[1]]

    if (!is_null(since) && gert::git_ahead_behind(since, first_parent)$ahead == 0) {
      return(commits)
    }

    commits <- c(commits, first_parent)
    commit <- first_parent
  }
}

get_last_tag_impl <- function(ref = "HEAD", pattern = NULL) {
  repo_head <- gert::git_log(ref, max = 1)

  all_tags <- gert::git_tag_list()

  if (length(all_tags) == 0) {
    return(NULL)
  }

  tag_names <- all_tags$name
  if (!is.null(pattern)) {
    tag_names <- grep(pattern, tag_names, value = TRUE, perl = TRUE)
  }

  tags_ab <- map(
    set_names(tag_names),
    ~ gert::git_ahead_behind(upstream = repo_head$commit, ref = .x)
  )
  tags_only_b <- discard(tags_ab, ~ .[[1]] > 0)
  tags_b <- map_int(tags_only_b, 2)
  names(tags_b) <- names(tags_only_b)

  # in case no tag exists yet, return the most recent commit
  if (length(tags_b) == 0) {
    return(NULL)
  }

  min_tag <- which.min(tags_b)
  gert::git_tag_list(match = names(min_tag))
}

get_last_version_tag_impl <- function(current_version = NULL, pattern = NULL) {
  all_tags <- gert::git_tag_list()

  if (nrow(all_tags) == 0) {
    return(NULL)
  }

  if (is.null(current_version)) {
    current_version <- read_fledgling()$version
  }

  current_version <- base::as.package_version(current_version)

  version_tags <- all_tags[grep("^v[0-9]+(?:[.][0-9]+)+$", all_tags$name), ]

  if (!is.null(pattern)) {
    version_tags <- version_tags[grep(pattern, version_tags$name, perl = TRUE), ]
  }

  versions <- base::as.package_version(sub("^v", "", version_tags$name))

  version_tags <- version_tags[versions <= current_version, ]
  versions <- versions[versions <= current_version]

  if (length(versions) == 0) {
    return(NULL)
  }
  version_tags[order(versions, decreasing = TRUE) == 1, ]
}
