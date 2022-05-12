# unbump_version() works

    Code
      bump_version()
    Message
      > Scraping 3 commit messages.
    Output
      Called from: collect_news(messages)
      debug at /home/runner/work/fledge/fledge/R/update-news.R#17: message_items <- messages %>% gsub("\r\n", "\n", .) %>% purrr::discard(~. == 
          "") %>% purrr::map_chr(remove_housekeeping) %>% purrr::map(extract_newsworthy_items) %>% 
          unlist()
      debug at /home/runner/work/fledge/fledge/R/update-news.R#24: if (length(message_items) == 0) {
          if (length(range) <= 1) {
              message_items <- "- Same as previous version."
          }
          else {
              message_items <- "- Internal changes only."
          }
      }
      debug at /home/runner/work/fledge/fledge/R/update-news.R#32: if (fledge_chatty()) {
          cli_alert_success("Found {.field {length(message_items)}} NEWS-worthy entries.")
      }
      debug at /home/runner/work/fledge/fledge/R/update-news.R#33: cli_alert_success("Found {.field {length(message_items)}} NEWS-worthy entries.")
    Message
      v Found 1 NEWS-worthy entries.
    Output
      debug at /home/runner/work/fledge/fledge/R/update-news.R#36: paste0(paste(message_items, collapse = "\n"), "\n\n")
    Message
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.0.9001.
      > Adding header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
      ! Call `fledge::finalize_version()`.
    Output
      NULL
    Code
      unbump_version()
    Message
      i Checking if working copy is clean.
      i Checking if last tag points to last commit.
      i Checking if commit messages match.
      v Safety checks complete.
      > Deleting tag v0.0.0.9001.
      v Resetting to parent commit 42.
    Code
      use_r("blop")
      gert::git_add("R/blop.R")
    Output
      # A tibble: 1 x 3
        file     status staged
        <chr>    <chr>  <lgl> 
      1 R/blop.R new    TRUE  
    Code
      c <- gert::git_commit("* Add cool blop.", author = default_gert_author(),
      committer = default_gert_committer())
      bump_version()
    Message
      > Scraping 4 commit messages.
    Output
      Called from: collect_news(messages)
      debug at /home/runner/work/fledge/fledge/R/update-news.R#17: message_items <- messages %>% gsub("\r\n", "\n", .) %>% purrr::discard(~. == 
          "") %>% purrr::map_chr(remove_housekeeping) %>% purrr::map(extract_newsworthy_items) %>% 
          unlist()
      debug at /home/runner/work/fledge/fledge/R/update-news.R#24: if (length(message_items) == 0) {
          if (length(range) <= 1) {
              message_items <- "- Same as previous version."
          }
          else {
              message_items <- "- Internal changes only."
          }
      }
      debug at /home/runner/work/fledge/fledge/R/update-news.R#32: if (fledge_chatty()) {
          cli_alert_success("Found {.field {length(message_items)}} NEWS-worthy entries.")
      }
      debug at /home/runner/work/fledge/fledge/R/update-news.R#33: cli_alert_success("Found {.field {length(message_items)}} NEWS-worthy entries.")
    Message
      v Found 2 NEWS-worthy entries.
    Output
      debug at /home/runner/work/fledge/fledge/R/update-news.R#36: paste0(paste(message_items, collapse = "\n"), "\n\n")
    Message
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.0.9001.
      > Adding header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
      ! Call `fledge::finalize_version()`.
    Output
      NULL

