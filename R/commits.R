with_repo <- function(code) {
  withr::with_dir(usethis::proj_get(), code)
}

get_top_level_commits_impl <- function(since) {
  commit <- gert::git_log(max = 1)

  if (!is.null(since)) {

    ab <- gert::git_ahead_behind(ref = commit$commit, upstream = since$commit)
    if (ab$behind > 0) {
      abort(paste0(since, " not reachable from current HEAD."))
    }
    gert::git_log()[1:(ab$behind + 1), ]
  } else {
    since_commit <- NULL
    since_commit
  }
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
  gert::git_tag_list(match = names(min_tag))
}
