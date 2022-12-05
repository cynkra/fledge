map_dfr <- function(list, ...) {
  df_list <- purrr::map(list, ...)
  do.call(rbind, df_list)
}

is_any_named <- function(x) {
  any(nzchar(names(x)))
}
