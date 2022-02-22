library(tidyverse)

code <- map(fs::dir_ls("../bg/R"), brio::read_lines)
all_code <- reduce(code, c, "")

bg_version <- desc::desc_get_version("../bg/DESCRIPTION")

header <- paste0("# Imported from bg ", bg_version, " on ", Sys.Date(), ": do not edit by hand")

final_code <- c(
  header,
  "",
  all_code[!str_detect(all_code, "^#' (?!@import)")]
)

brio::write_lines(final_code, "R/bg.R")
