parse_news_md <- function(news = brio::read_lines(news_path())) {
  news <- protect_hashtag(news)

  temp_file <- withr::local_tempfile(fileext = ".md")
  brio::write_lines(news, temp_file)

  out_temp_file <- withr::local_tempfile(fileext = ".html")
  pandoc::pandoc_run(
    c(
      "-t", "html", # output format
      "--wrap=preserve", # option for output format
      "-f", "gfm", # input format
      "-o", out_temp_file, # output temp file
      temp_file, # temp file with curret Markdown news
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
    contents <- markdownify(html)
    return(list(contents))
  }

  treat_section <- function(section) {
    children <- xml2::xml_children(section)

    header <- children[grepl("^h[1-9]", xml2::xml_name(children))][1]
    title <- xml2::xml_text(header)
    xml2::xml_remove(header)

    children <- xml2::xml_children(section)

    no_section <- all(xml2::xml_name(children) != "section")
    if (no_section) {
      contents <- markdownify(section)
      return(
        structure(
          list(contents),
          names = title
        )
      )
    } else {
      treat_children <- function(child) {
        if (xml2::xml_name(child) == "section") {
          treat_section(child)
        } else {
          list(markdownify(child))
        }
      }
      structure(
        list(purrr::map(children, treat_children)),
        names = title
      )
    }
  }

  info <- purrr::map(versions, treat_section)
  unlist(info, recursive = FALSE)
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

markdownify <- function(html) {
  temp_file <- withr::local_tempfile(fileext = ".html")
  temp_outfile <- withr::local_tempfile(fileext = ".md")
  xml2::write_html(html, temp_file)
  pandoc::pandoc_run(
    c(
      "-t", "gfm-raw_html", # output format
      "-o", temp_outfile, # output file
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
