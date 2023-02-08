<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# fledge 0.0.1

## Bug fixes

- Prevent racing of requests.

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue but are
obsolete now.

Reviewed-by: Z
Refs: #123

## Features

### lang

- Add Polish language.

### api

- Breaking change: send an email to the customer when a product is shipped.

- Breaking change: send an email to the customer when a product is shipped.

- Allow provided config object to extend other configs.

  BREAKING CHANGE: `extends` key in config file is now used for extending other config files

## Chore

- Breaking change: drop support for Node 6.

BREAKING CHANGE: use JavaScript features not available in Node 6.

## Documentation

- Correct spelling of CHANGELOG.

## Breaking changes

- Breaking change: drop support for Node 6.

BREAKING CHANGE: use JavaScript features not available in Node 6.

### api

- Breaking change: send an email to the customer when a product is shipped.

- Breaking change: send an email to the customer when a product is shipped.

## upkeep

- Update rlang usage.

