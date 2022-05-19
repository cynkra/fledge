create_news <- function(pkg) {
  #withr::local_dir(pkg)
  if (!file.exists(news_path())) {
    cli::cli_alert_info("Created the NEWS.md file")
    file.create(news_path())
  }

  xml <- news_path() %>%
    enc::read_lines_enc() %>%
    commonmark::markdown_xml() %>%
    xml2::read_xml()

  xml2::xml_ns_strip(xml)

  # make nodes out of versions
  versions <- xml2::xml_find_all(xml, ".//heading[@level='1']")
  purrr::walk(rev(versions), nodify_version, xml = xml)
  purrr::walk(
    xml2::xml_find_all(xml, "//document/*[not(name()='section')] "),
    xml2::xml_remove
  )
  browser()

  # which sections are dev ones
  # merge them

  # would be simpler if not https://github.com/r-lib/xml2/issues/301
  # need to re-add the comment at the top
  # use tinkr?
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
    }
  )
}

extract_version_number <- function(string) {
  number <- regmatches(
    string,
    regexpr("[0-9]*\\.[0-9]*\\.[0-9]*(\\.[0-9]*)?", string)
  )
}

is_dev_version_number <- function(version_number) {
  # 4 components hence 3 periods
  length( gregexpr("\\.", version_number)[[1]]) == 3
}
