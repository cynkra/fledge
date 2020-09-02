get_mails = function() {
  gmailr::gm_auth_configure()
  gmailr::gm_auth(email = "fledge.package@gmail.com", path = "~/.config/gmail/credentials.json")
  gmailr::gm_threads()
}

filter_threads_by_package <- function(package) {
  # filter all CRAN mails
  # FIXME: simpler?
  cran_filtered <- purrr::keep(
    mails[[1]]$threads,
    ~ stringr::str_extract(.x$snippet, "CRAN") %in% "CRAN"
  )

  # filter by package
  purrr::keep(
    cran_filtered,
    ~ stringr::str_extract(.x$snippet, package) %in% package
  )
}

get_version_from_mail <- function(filtered_mails) {

  msg <- gmailr::gm_thread(filtered_mails[[1]]$id)$messages[[1]]
  # find package name and version
  match = stringr::str_extract(gmailr::gm_subject(msg), "(?<=submission )(.*)")

  split = stringr::str_split(match, " ")[[1]]
  names(split) = c("package", "version")
  return(split)

}

categorize_mails = function(package) {

  filtered = filter_threads_by_package(package = package)
  meta = get_version_from_mail(filtered)

  purrr::map_dfr(filtered, ~ {

    # FIXME: do for all mails in thread
    msg = gmailr::gm_thread(.x$id)$messages[[1]]
    subject = gmailr::gm_subject(msg)

    if (grepl("submission", subject)) {
      type = "submission"
    } else {
      type = NA
    }

    # Caution: date is the forwarded date here!
    # FIXME: fix date format
    date = gmailr::gm_date(msg)
    id = gmailr::gm_id(msg)

    return(structure(c(type = type, date = date,
                       package = meta[["package"]],
                       version = meta[["version"]],
                       id = id)))
  })
}

extract_upload_link = function(id) {

  msg <- gm_message("17442fc5d127db4f")

  # find package name and version
  stringr::str_extract(gm_subject(msg), "(?<=submission )(.*)")

  # find upload link
  stringr::str_extract(
    stringr::str_squish(gm_body(msg)),
    "(?<=into your browser: > > )(.*)(?= > > If)"
  )

}
