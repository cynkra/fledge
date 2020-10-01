get_mails <- function() {
  gmailr::gm_auth_configure()
  gmailr::gm_auth(email = "fledge.package@gmail.com", path = "~/.config/gmail/credentials.json")
  gmailr::gm_messages()
}

filter_messages_by_package <- function(package) {
  mails <- get_mails()
  # filter all CRAN mails
  # FIXME: simpler?
  cran_filtered <- purrr::keep(
    mails[[1]]$messages, ~ {
      subject <- gmailr::gm_subject(gmailr::gm_message(.x$id))
      stringr::str_detect(subject, "CRAN")
    }
  )

  # filter by package
  package_filtered <- purrr::keep(
    cran_filtered, ~ {
      subject <- gmailr::gm_subject(gmailr::gm_message(.x$id))
      stringr::str_detect(subject, sprintf(" %s ", package))
    }
  )

  map_chr(package_filtered, ~ .x$id)
}

get_version_from_mail <- function(message) {

  # find package name and version
  match <- stringr::str_extract(gmailr::gm_subject(message), "(?<=submission )(.*)")

  split <- stringr::str_split(match, " ")[[1]]
  names(split) <- c("package", "version")
  return(split)
}

categorize_mails <- function(package) {

  filtered <- filter_messages_by_package(package = package)

  purrr::map_dfr(filtered, ~ {
    msg <- gmailr::gm_message(.x)
    subject <- gmailr::gm_subject(msg)

    if (grepl("pretest-publish", subject)) {
      type <- "acceptance"
    } else if (grepl("submission", subject)) {
      type <- "submission"
    } else {
      type <- NA
    }

    # Caution: date is the forwarded date here!
    # FIXME: fix date format
    date <- gmailr::gm_date(msg)
    id <- gmailr::gm_id(msg)

    meta <- get_version_from_mail(msg)

    return(structure(c(
      type = type, date = date,
      package = meta[["package"]],
      version = meta[["version"]],
      id = id
    )))
  })
}

extract_upload_link <- function(id) {

  msg <- gmailr::gm_message(id)

  # find upload link
  stringr::str_extract(
    stringr::str_squish(gmailr::gm_body(msg)),
    "(?<=into your browser: )(.*)(?= If)"
  )
}
