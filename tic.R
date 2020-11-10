get_stage("before_script") %>%
  add_code_step(print(gert::libgit2_config()))

# installs dependencies, runs R CMD check, runs covr::codecov()
do_package_checks()

if (ci_on_travis() && ci_has_env("TIC_BUILD_PKGDOWN")) {
  # creates pkgdown site and pushes to gh-pages branch
  do_pkgdown()
}
