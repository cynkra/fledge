# bump_version() works -- dev

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
      ! Call `fledge::finalize_version(push = TRUE)`.
    Output
      NULL

# bump_version() works -- not dev

    Code
      bump_version(which = "major")
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
      
      v Package version bumped to 1.0.0.
      > Adding header to 'NEWS.md'.
      > Committing changes.
      
      -- Preparing package for CRAN release --
      
      * Convert the change log in 'NEWS.md' to release notes.

# bump_version() errors informatively for forbidden notifications

    x Unindexed change(s) in `DESCRIPTION`.
    i Commit the change(s) before running any fledge function again.

# bump_version() errors informatively for wrong branch

    x Must be on the main branch (main) for running fledge functions.
    i Currently on branch bla.

