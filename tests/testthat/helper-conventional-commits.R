cc_examples <- function() {
  c(
    # Commit message with description and breaking change footer
    "feat: allow provided config object to extend other configs

  BREAKING CHANGE: `extends` key in config file is now used for extending other config files",

    # Commit message with ! to draw attention to breaking change
    "feat!: send an email to the customer when a product is shipped",

    # Commit message with scope and ! to draw attention to breaking change
    "feat(api)!: send an email to the customer when a product is shipped",

    # Commit message with both ! and BREAKING CHANGE footer
    "chore!: drop support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6.",

    # Commit message with no body
    "docs: correct spelling of CHANGELOG",

    # Commit message with scope
    "feat(lang): add Polish language",

    # Commit message with multi-paragraph body and multiple footers
    "fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue but are
obsolete now.

Reviewed-by: Z
Refs: #123
---

Also tweak the CI workflow accordingly. :sweat_smile:",

    # Custom type
    "upkeep: update rlang usage.",

    # NOT conventional commit
    "upkeep:update",
    "use cool::blop()"
  )
}

sort_of_commit <- function(commit_message, repo) {
  file <- digest::sha1(commit_message)
  file.create(file)
  gert::git_add(file)
  gert::git_commit(commit_message, repo = repo)
}

create_cc_repo <- function(repo, commit_messages = cc_examples()) {
  tryCatch(
    gert::git_init(repo),
    error = function(e) {
      skip("Can't init repository")
    }
  )
  gert::git_config_set("user.name", "Test", repo = repo)
  gert::git_config_set("user.email", "my@test.user", repo = repo)

  purrr::walk(
    commit_messages,
    sort_of_commit,
    repo
  )
}
