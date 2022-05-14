# Imported from bg 0.0.0.9000 on 2022-02-17: do not edit by hand

"_PACKAGE"

## usethis namespace: start
#' @import rlang
## usethis namespace: end
NULL
#'
#'
#'
#'
new_bg <- function(x) {
  stopifnot(is.list(x))
  stopifnot(vapply(x, inherits, what = "process", logical(1)))

  vctrs::new_list_of(x, class = "bg")
}

print.bg <- function(x, ...) {
  bg_livelog(x)
}

bg_livelog <- function(x) {
  names <- names2(x)

  spinner <- c("-", "/", "|", "\\")
  spin <- function() {
    cat(spinner[[1]], "\r", sep = "")
    spinner <<- c(spinner[-1], spinner[[1]])
  }

  tryCatch(
    {
      for (i in seq_along(names)) {
        if (names[[i]] == "") {
          writeLines(paste0("[[", i, "]]"))
        } else {
          writeLines(paste0("$", names[[i]]))
        }

        ps <- x[[i]]

        if (is_interactive()) {
          while (is.null(ps$get_exit_status())) {
            writeLines(ps$read_output_lines())
            error <- ps$read_error_lines()
            if (length(error) > 0) {
              message(paste(error, collapse = "\n"))
            }
            spin()
            Sys.sleep(0.1)
          }
        }

        writeLines(ps$read_output_lines())
        error <- ps$read_error_lines()
        if (length(error) > 0) {
          message(paste(error, collapse = "\n"))
        }

        if (is.null(ps$get_exit_status())) {
          message("Process ", get_pid(ps), " still running.")
        } else {
          message("Process ", get_pid(ps), " exited with code ", ps$get_exit_status(), ".")
        }
      }
    },
    interrupt = function(e) {
      message("Interrupted, processes continue running in the background.")
    },
    finally = for (i in seq2(i + 1L, length(names))) {
      if (names[[i]] == "") {
        writeLines(paste0("[[", i, "]]"))
      } else {
        writeLines(paste0("$", names[[i]]))
      }

      ps <- x[[i]]

      if (is.null(ps$get_exit_status())) {
        message("Process ", get_pid(ps), " still running.")
      } else {
        message("Process ", get_pid(ps), " exited with code ", ps$get_exit_status(), ".")
      }
    }
  )

  invisible(x)
}

# For mocking
get_pid <- function(ps) {
  ps$get_pid()
}

#'
#'
#'
bg_r <- function(...) {
  quos <- enquos(...)
  squashed <- lapply(quos, quo_squash, warn = TRUE)
  funs <- lapply(squashed, new_function, args = list())
  processes <- lapply(funs, callr::r_bg)
  new_bg(processes)
}
