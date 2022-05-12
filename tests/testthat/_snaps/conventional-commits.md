# Can parse conventional commits

    Code
      collect_news(messages)
    Message
      > Scraping 8 commit messages.
      v Found 8 NEWS-worthy entries.
    Output
      [1] "upkeep: update rlang usage.\n\nfix: prevent racing of requests\n\nIntroduce a request id and a reference to latest request. Dismiss\nincoming responses other than from latest request.\n\nRemove timeouts which were used to mitigate the racing issue but are\nobsolete now.\n\nReviewed-by: Z\nRefs: #123\nfeat(lang): add Polish language\n\ndocs: correct spelling of CHANGELOG\n\nchore!: drop support for Node 6\n\nBREAKING CHANGE: use JavaScript features not available in Node 6.\n\nfeat(api)!: send an email to the customer when a product is shipped\n\nfeat!: send an email to the customer when a product is shipped\n\nfeat: allow provided config object to extend other configs\n\n  BREAKING CHANGE: `extends` key in config file is now used for extending other config files\n\n\n"

