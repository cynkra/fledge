library(fs)
library(tidyverse)

pkgload::load_all()

# Find all NEWS.md files reachable from CWD
news_files <- dir_ls(path = ".", regexp = "NEWS\\.md$", recurse = TRUE)

cat("Found", length(news_files), "NEWS.md file(s)\n\n")

check_roundtrip <- function(news_file) {
  original_lines <- brio::read_lines(news_file)

  tryCatch(
    {
      news_and_preamble <- read_news(original_lines)
      section_df <- news_and_preamble[["section_df"]]
      preamble <- news_and_preamble[["preamble"]]

      if (is.null(section_df)) {
        return(tibble(file = news_file, status = "skip", message = "No version sections found"))
      }

      news_sections <- write_news_sections(section_df)
      reconstructed <- paste(
        c(preamble, "", paste0(news_sections, collapse = "\n\n")),
        collapse = "\n"
      )
      original <- paste(original_lines, collapse = "\n")

      if (identical(original, reconstructed)) {
        tibble(file = news_file, status = "ok", message = "")
      } else {
        tibble(file = news_file, status = "fail", message = "Roundtrip mismatch")
      }
    },
    error = function(e) {
      tibble(file = news_file, status = "error", message = conditionMessage(e))
    }
  )
}

results <- map(news_files, check_roundtrip) |> list_rbind()

print(results)

failed <- filter(results, status %in% c("fail", "error"))
if (nrow(failed) > 0) {
  cat("\nFailed files:\n")
  walk(failed$file, \(f) cat(" -", f, "\n"))
  quit(status = 1)
} else {
  cat("\nAll NEWS.md files passed the roundtrip check.\n")
}
