#' Transform a text file
#'
#' Reads a file from disk, applies a function on the contents, and optionally
#' writes the file back if different.
#' The line ending separator of the input file is used if it can be read and
#' contains at least one, otherwise [native_eol()] is used.
#'
#' @family file functions
#' @param path A vector of file paths.
#' @param fun A function that returns a character vector.
#' @param write_back Should the results of the transformation be written back
#'   to the file?
#' @param verbose Should the function show a message with a list of changed
#'   files?
#' @return A named logical vector of the same length as `path` that indicates
#'   if a file has changed (`TRUE` or `FALSE`), or if an error occurred (`NA`)
#' @inheritParams base::readLines
#' @inheritParams read_lines_enc
#' @inheritParams write_lines_enc
#' @param file_encoding The encoding to assume for the input file.
#' @noRd
transform_lines <- function(path, fun, write_back = TRUE, verbose = is_interactive()) {
  ret <- map_lgl(set_names(path), transform_lines_one, fun = fun, write_back = write_back)

  if (verbose) {
    if (!any(ret, na.rm = TRUE)) {
      ui_info("No files changed.")
    } else {
      cli::cli_inform(c(
        "v" = "Files changed:",
        "*" = "{.file {names(ret)[which(ret)]}}"
      ))
    }
    invisible(ret)
  } else {
    ret
  }
}

transform_lines_one <- function(path, fun, write_back = TRUE) {
  text <- brio::read_lines(path)
  eol <- detect_eol(path)
  tryCatch(
    {
      new_text <- fun(text)
      if (!isTRUE(identical(unclass(text), unclass(new_text)))) {
        if (write_back) {
          brio::write_lines(new_text, path, eol = eol)
        }
        TRUE
      } else {
        FALSE
      }
    },
    error = function(e) {
      warning("When processing ", path, ": ", conditionMessage(e), call. = FALSE)
      NA
    }
  )
}

detect_eol <- function(path) {
  con <- file(path, "rb")
  on.exit(close(con), add = TRUE)

  repeat {
    byte <- readBin(con, raw(1L))
    if (length(byte) == 0) return(native_eol())
    if (byte == 0x0d) return("\r\n")
    if (byte == 0x0a) return("\n")
  }
}

#' The native end-of-line identifier on the current platform
#'
#' Returns CRLF on Windows and LF on Linux/OS X.
#' @noRd
native_eol <- if (.Platform$OS.type == "windows") {
  function() "\r\n"
} else {
  function() "\n"
}
