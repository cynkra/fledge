get_repo <- function() {
  proj <- usethis::proj_get()
  git2r::repository(proj)
}

with_repo <- function(code) {
  withr::with_dir(usethis::proj_get(), code)
}

get_top_level_commits_impl <- function(since) {
  commit <- git2r::commits(get_repo(), time = FALSE, n = 1)[[1]]

  if (!is.null(since)) {
    since_commit <- git2r::lookup_commit(since)
    ab <- git2r::ahead_behind(commit, since_commit)
    if (ab[[2]] > 0) {
      abort(paste0(since, " not reachable from current HEAD."))
    }
  } else {
    since_commit <- NULL
  }

  get_first_parent(commit, since_commit)
}

get_first_parent <- function(commit, since) {
  commits <- list(commit)
  if (!is.null(since) && commit$sha == since$sha) {
    return(commits)
  }

  repeat {
    all_parents <- git2r::parents(commit)
    first_parent <- get_parent_since(all_parents, since)
    if (is_null(first_parent)) {
      return(commits)
    }

    commits <- c(commits, list(first_parent))
    commit <- first_parent
  }
}

get_parent_since <- function(all_parents, since) {
  if (is_empty(all_parents)) {
    return(NULL)
  }
  if (is_null(since)) {
    return(all_parents[[1]])
  }

  purrr::detect(all_parents, ~ git2r::ahead_behind(.x, since)[[2]] == 0)
}

get_last_tag_impl <- function() {
  with_repo({
    repo_head <- get_repo_head()

    all_tags <- git2r::tags()
  })

  if (length(all_tags) == 0) {
    return(NULL)
  }

  tags_ab <- map(all_tags, git2r::ahead_behind, repo_head)
  tags_only_b <- discard(tags_ab, ~ .[[1]] > 0)
  tags_b <- map_int(tags_only_b, 2)

  min_tag <- names(tags_b)[which.min(tags_b)]
  all_tags[[min_tag]]
}

get_repo_head <- function(ref = NULL) {
  # Why is this so difficult?
  git2r::commits(time = FALSE, n = 1, ref = ref)[[1]]
}
