parse_news_md <- function(news = brio::read_lines(news_path()), strict = FALSE) {
  news <- protect_hashtag(news)

  temp_file <- withr::local_tempfile(fileext = ".md")
  brio::write_lines(news, temp_file)

  out_temp_file <- withr::local_tempfile(fileext = ".html")
  pandoc::pandoc_run(
    c(
      "-t", "html", # output format
      "--wrap=preserve", # preserve soft linebreaks
      "--no-highlight",
      "-f", "gfm-autolink_bare_uris", # input format, do not transform bare URIs into links
      "-o", out_temp_file, # output temp file
      temp_file, # temp file with current Markdown news
      "--section-divs" # wrap sections into divs (for parsing)
    )
  )

  html <- xml2::read_html(out_temp_file, encoding = "UTF-8")

  if (length(xml2::xml_contents(html)) == 0) {
    return(NULL)
  }

  version_header_level <- 1
  versions <- xml2::xml_find_all(html, ".//section[@class='level1']")
  if (length(versions) == 0) {
    version_header_level <- 2
    versions <- xml2::xml_find_all(html, ".//section[@class='level2']")
  }
  if (length(versions) == 0) {
    cli::cli_abort("Empty {.file NEWS.md}")

    contents <- markdownify(html)
    return(list(contents))
  }

  if (strict) {
    check_top_level_headers(versions)
  }

  treat_section <- function(section) {
    title <- news_get_section_name(section)

    xml2::xml_remove(xml2::xml_child(section))

    children <- xml2::xml_children(section)

    no_section <- all(xml2::xml_name(children) != "section")
    if (no_section) {
      contents <- markdownify(section)
    } else {
      treat_children <- function(child) {
        if (xml2::xml_name(child) == "section") {
          treat_section(child)
        } else {
          list(markdownify(child))
        }
      }
      contents <- purrr::map(children, treat_children)
    }

    structure(
      list(contents),
      names = title
    )
  }

  info <- purrr::map(versions, treat_section)
  unlist(info, recursive = FALSE)
}

news_get_section_name <- function(section) {
  xml2::xml_text(xml2::xml_child(section))
}

protect_hashtag <- function(lines) {
  lines <- gsub(
    "(?<!#)(?<!^)(?<!`)#([[:alnum:]]*)([[:space:]]|[[:punct:]])",
    "`#\\1`{=html}\\2",
    lines,
    perl = TRUE
  )
  gsub(
    "(?<!#)(?<!^)(?<!`)#([[:alnum:]]*)$",
    "`#\\1`{=html}",
    lines,
    perl = TRUE
  )
}

unprotect_hashtag <- function(lines) {
  gsub(
    "`#([[:alnum:]]*)`{=html}",
    "#\\1",
    lines,
    perl = TRUE
  )
}


dev_header_rx <- function() {
  '^[a-zA-Z ]*?[a-zA-Z][a-zA-Z0-9\\.]*[a-zA-Z0-9] +(?<version>\\(development version\\))?$'
}
is_dev_header <- function(text) {
  grepl(dev_header_rx(), text, perl = TRUE)
}

header_rx <- function() {
  '^[a-zA-Z ]*?[a-zA-Z][a-zA-Z0-9\\.]*[a-zA-Z0-9] +(?<version>v?[0-9][0-9.-]*) *(?<date>\\(.*\\))? *(?<nickname>".*")?$'
}
is_header <- function(text) {
  grepl(header_rx(), text, perl = TRUE)
}

markdownify <- function(html) {
  temp_file <- withr::local_tempfile(fileext = ".html")
  temp_outfile <- withr::local_tempfile(fileext = ".md")
  xml2::write_html(html, temp_file)
  pandoc::pandoc_run(
    c(
      "-t", "gfm-raw_html", # output format
      "-o", temp_outfile, # output file
      "--wrap=preserve", # preserve soft linebreaks
      temp_file # input temp file with HTML news
    )
  )
  markdown_lines <- brio::read_lines(temp_outfile)
  if (grepl("^:::", markdown_lines[1])) {
    markdown_lines <- markdown_lines[-1]
  }
  if (grepl("^:::", markdown_lines[length(markdown_lines)])) {
    markdown_lines <- markdown_lines[-length(markdown_lines)]
  }
  markdown_lines
}

check_top_level_headers <- function(versions) {
  extract_version <- function(version) {
    trimws(xml2::xml_text(xml2::xml_child(version)))
  }
  version_titles <- purrr::map_chr(versions, extract_version)
  malformatted_titles <- version_titles[!(is_header(version_titles) | is_dev_header(version_titles))]
  if (length(malformatted_titles) > 0) {
    malformatted_titles_string <- toString(sprintf("'%s'", malformatted_titles))
    cli::cli_abort(
      c(
        "Can't parse version headers: {malformatted_titles_string}",
        i = "All top level headers in {.file NEWS.md} should be version titles."
      )
    )
  }
}
