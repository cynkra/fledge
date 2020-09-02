
mails = get_mails()

filtered = filter_threads_by_package(package = "oddsratio")

pkg_version = get_version_from_mail(filtered)

# workflow ---------------------------------------------------------------------

# 1. categorize mails
categorize_mails("oddsratio")

# 2. release(): for "submission" types, extract upload link
extract_upload_link("17442fc5d127db4f")

# 2.1. click link

# 2.2. delete message

# 3. post_release(): for "acceptance" types, continue with post_release()


# TODO -------------------------------------------------------------------------
# - how to handle re-submissions with the same package version? We do not want to click multiple links twice.
# -> delete message after processing it? gm_delete_message()
# - cateogorize acceptance mails
