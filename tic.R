get_stage("before_script") %>%
  add_code_step(print(git2r::libgit2_version())) %>%
  add_code_step(print(git2r::libgit2_features()))

# installs dependencies, runs R CMD check, runs covr::codecov()
do_package_checks()

if (ci_on_ghactions() && ci_has_env("TIC_BUILD_PKGDOWN")) {
  # creates pkgdown site and pushes to gh-pages branch
  do_pkgdown()
}
