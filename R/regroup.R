create_news <- function(pkg) {
  # withr::local_dir(pkg)
  if (!file.exists(news_path())) {
    cli::cli_alert_info("Created the NEWS.md file")
    file.create(news_path())
    # in that case test what the parsing looks like
  }

  news <- tinkr::yarn$new(news_path())

  xml <- news$body

  # make nodes out of versions to have headings and content in a "bag"
  versions <- xml2::xml_find_all(xml, ".//md:heading[@level='1']", news$ns)
  purrr::walk(rev(versions), nodify_version, xml = xml)
  # this below is a workaround for https://github.com/r-lib/xml2/issues/301
  purrr::walk(
    xml2::xml_find_all(xml, "//md:document/*[not(name()='section')]", news$ns),
    xml2::xml_remove
  )

  # which sections correspond to dev versions
  sections <- xml2::xml_find_all(xml, ".//section", news$ns)
  # this assumes there are not dev versions dating from before the last not dev version
  is_dev <- purrr::map_lgl(sections, function(x) {
    xml2::xml_attr(x, "version") %>% extract_version_number() %>% is_dev_version_number()
  })
  # merge them
  # TODO: regroup sub-headers
  dev_sections <- sections[is_dev]
  # place-holder, ultimately this should be the bumped version
  general_header <- sprintf("NEW %s", xml2::xml_attr(dev_sections[[1]], "version"))
  xml2::xml_add_sibling(dev_sections[[1]], "section", version = general_header, .where = "before")

  new_section <- xml2::xml_find_first(xml, sprintf("section[@version = '%s']", general_header), news$ns)
  xml2::xml_add_child(new_section, "heading", level = 1)
  xml2::xml_add_child(xml2::xml_child(new_section), "text", general_header)

  purrr::walk(
    xml2::xml_children(dev_sections),
    function(x, new_section) {
      if (xml2::xml_name(x) == "heading" && xml2::xml_attr(x, "level") == "1") {
        return()
      }
      xml2::xml_add_child(new_section, x)
    },
    new_section = new_section
  )
  purrr::walk(dev_sections, xml2::xml_remove)

  # remove the sections (not recognized by tinkr)
  sections <- xml2::xml_find_all(xml, "//md:document/*[name()='section']", news$ns)
  purrr::walk(
    xml2::xml_children(sections),
    ~ xml2::xml_add_sibling(sections[[1]], ., .where = "before")
  )
  purrr::walk(sections, xml2::xml_remove)


  # would be simpler if not https://github.com/r-lib/xml2/issues/301
  # need to re-add the comment at the top
  # use tinkr?
  news$write(news_path())
}

nodify_version <- function(version, xml) {
  version_name <- xml2::xml_text(version) # TODO: parse version number
  siblings <- xml2::xml_find_all(version, ".//following-sibling::*")
  not_version_siblings <- siblings[xml2::xml_name(siblings) != "section"]
  xml2::xml_add_parent(version, "section", version = version_name)
  purrr::walk(
    not_version_siblings,
    function(x) {
      xml2::xml_add_child(
        xml2::xml_find_first(xml, sprintf("section[@version = '%s']", version_name)),
        x
      )
      xml2::xml_remove(x)
    }
  )
}

extract_version_number <- function(string) {
  regmatches(
    string,
    regexpr("[0-9]*\\.[0-9]*\\.[0-9]*(\\.[0-9]*)?", string)
  )
}

is_dev_version_number <- function(version_number) {
  # 4 components hence 3 periods
  length(gregexpr("\\.", version_number)[[1]]) == 3
}
