# Feature: allow to specify a numeric version in `which`
unleash <- function(which, force = FALSE) {

  state <- check_release_state()

  switch(state,
    "pre-release" = pre_release(which, force),
    "ready-to-release" = release(),
    "accepted" = post_release(),
    "submitted" = TRUE,
    "running-release-checks" = TRUE,

    # FIXME: Improve error handling/messages
    FALSE = stop("No valid state detected.")
  )
}
