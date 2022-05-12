# fix type commits should be translated to PATCH releases.
# feat type commits should be translated to MINOR releases.
# Commits with BREAKING CHANGE in the commits, regardless of type,
# should be translated to MAJOR releases.

# Examples
cc_examples <- c(
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
Refs: #123",

  # Custom type
  "upkeep: update rlang usage."
)
