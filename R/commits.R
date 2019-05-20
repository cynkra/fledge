#' @import purrr
NULL

get_top_level_commits_impl <- function(since) {
  repo <- git2r::repository()

  commit <- git2r::commits(repo, time = FALSE, n = 1)[[1]]

  since <- git2r::lookup_commit(since)

  get_first_parent(commit, since)
}

get_first_parent <- function(commit, since) {
  commits <- list(commit)
  if (!is.null(since) && commit$sha == since$sha) {
    return(commits)
  }

  repeat {
    all_parents <- git2r::parents(commit)
    if (length(all_parents) == 0) return(commits)

    # Compatibility with git-flow, where tags were set on the production branch
    # which was then merged to master
    if (!is.null(since)) {
      if (some(all_parents, ~.$sha == since$sha)) return(commits)
    }

    first_parent <- all_parents[[1]]
    commits <- c(commits, list(first_parent))
    commit <- first_parent
  }
}

get_last_tag_impl <- function() {
  repo <- git2r::repository()

  repo_head <- git2r::commits(repo, time = FALSE, n = 1)[[1]]

  all_tags <- git2r::tags(repo)
  if (length(all_tags) == 0) return(NULL)

  tags_ab <- map(all_tags, git2r::ahead_behind, repo_head)
  tags_only_b <- discard(tags_ab, ~.[[1]] > 0)
  tags_b <- map_int(tags_only_b, 2)

  min_tag <- names(tags_b)[which.min(tags_b)]
  all_tags[[min_tag]]
}
