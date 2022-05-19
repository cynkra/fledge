<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->


## upkeep

update rlang usage.


## Bug fixes

prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue but are
obsolete now.

Reviewed-by: Z
Refs: #123

## Features

### lang

add Polish language


## Documentation

correct spelling of CHANGELOG


## Chore

Breaking change: drop support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6.


## Features

### api

Breaking change: send an email to the customer when a product is shipped


## Features

Breaking change: send an email to the customer when a product is shipped


## Features

allow provided config object to extend other configs

  BREAKING CHANGE: `extends` key in config file is now used for extending other config files



