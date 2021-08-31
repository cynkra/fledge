with_repo <- function(code) {
  withr::with_dir(usethis::proj_get(), code)
}

get_top_level_commits_impl <- function(since) {
  commit <- gert::git_log(max = 1)$commit

  if (!is.null(since)) {
    ab <- gert::git_ahead_behind(since, commit)
    if (ab$behind > 0) {
      abort(paste0(since, " not reachable from current HEAD."))
    }
  }

  commit <- get_first_parent(commit, since)
  message <- map_chr(commit, ~ gert::git_commit_info(.x)$message)
  tibble::tibble(commit, message)
}

get_first_parent <- function(commit, since) {
  commits <- commit
  if (!is.null(since) && commit == since) {
    return(commits)
  }

  repeat {
    all_parents <- gert::git_commit_info(commit)$parents
    first_parent <- get_parent_since(all_parents, since)
    if (is_null(first_parent)) return(commits)

    commits <- c(commits, first_parent)
    commit <- first_parent
  }
}

get_parent_since <- function(all_parents, since) {
  if (is_empty(all_parents)) return(NULL)
  if (is_null(since)) return(all_parents[[1]])

  purrr::detect(all_parents, ~ gert::git_ahead_behind(since, .x)$behind == 0)
}

get_last_tag_impl <- function() {
  repo_head <- gert::git_log(max = 1)

  all_tags <- gert::git_tag_list()

  if (length(all_tags) == 0) {
    return(NULL)
  }

  tags_ab <- map(all_tags$name, ~ gert::git_ahead_behind(upstream = repo_head$commit, ref = .x))
  names(tags_ab) <- all_tags$name
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
