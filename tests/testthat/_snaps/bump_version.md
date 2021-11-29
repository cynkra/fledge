# bump_version() works

    Code
      config$value[config$name == "init.defaultbranch"]
    Output
      [1] "main" "main"

---

    Code
      get_main_branch()
    Output
      [1] "main"

---

    Code
      gert::git_branch()
    Output
      [1] "main"

