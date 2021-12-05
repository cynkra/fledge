rlang_version <- function() {
  if (packageVersion("rlang") > "0.99") {
    "rlang-1"
    } else {
      "rlang-legacy"
    }
}
