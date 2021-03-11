with_repo <- function(code) {
  withr::with_dir(usethis::proj_get(), code)
}

get_top_level_commits_impl <- function(since) {
  commit <- gert::git_log(max = 1)

  if (!is.null(since)) {
    ab <- gert::git_ahead_behind(ref = commit$commit, upstream = since)
    if (ab$behind > 0) {
      abort(paste0(since, " not reachable from current HEAD."))
    }
    utils::head(gert::git_log(), ab$behind + 1)
  } else {
    gert::git_log()
  }

}

get_first_parent <- function(commit, since) {
  commits <- list(commit)
  if (!is.null(since) && commit$sha == since$sha) {
    return(commits)
  }

  repeat {
    all_parents <- git2r::parents(commit)
    first_parent <- get_parent_since(all_parents, since)
    if (is_null(first_parent)) return(commits)

    commits <- c(commits, list(first_parent))
    commit <- first_parent
  }
}

get_parent_since <- function(all_parents, since) {
  if (is_empty(all_parents)) return(NULL)
  if (is_null(since)) return(all_parents[[1]])

  purrr::detect(all_parents, ~ git2r::ahead_behind(.x, since)[[2]] == 0)
}

get_last_tag_impl <- function() {
  repo_head <- gert::git_log(max = 1)

  all_tags <- gert::git_tag_list()

  if (length(all_tags) == 0) {
    return(NULL)
  }

  tags_ab <- map(all_tags$name, ~ gert::git_ahead_behind(upstream = repo_head$commit, ref = .x))
  # in case no tag exists yet, return the most recent commit
  if (length(tags_ab) == 0) {
    return(NULL)
  }
  names(tags_ab) <- all_tags$name
  tags_only_b <- discard(tags_ab, ~ .[[1]] > 0)
  tags_b <- map_int(tags_only_b, 2)
  names(tags_b) <- names(tags_only_b)

  min_tag <- which.min(tags_b)
  gert::git_tag_list(match = names(min_tag))$commit
}
