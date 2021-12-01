# finalize_version(push = TRUE)

    Code
      knitr::kable(gert::git_config()[gert::git_config()$name != "user.signingkey", ])
    Output
      
      
      |name                         |value                                     |level  |
      |:----------------------------|:-----------------------------------------|:------|
      |user.name                    |Maëlle Salmon                             |global |
      |user.email                   |maelle.salmon@yahoo.se                    |global |
      |core.editor                  |vim                                       |global |
      |gpg.program                  |gpg                                       |global |
      |commit.gpgsign               |true                                      |global |
      |credential.helper            |cache                                     |global |
      |init.defaultbranch           |main                                      |global |
      |core.bare                    |false                                     |local  |
      |core.repositoryformatversion |0                                         |local  |
      |core.filemode                |true                                      |local  |
      |core.logallrefupdates        |true                                      |local  |
      |user.name                    |Maëlle Salmon                             |local  |
      |user.email                   |maelle.salmon@yahoo.se                    |local  |
      |init.defaultbranch           |main                                      |local  |
      |remote.origin.url            |/tmp/Rtmp7Vn3F6/fledge71632814b6d8/remote |local  |
      |remote.origin.fetch          |+refs/heads/*:refs/remotes/origin/*       |local  |
      |branch.main.remote           |origin                                    |local  |
      |branch.main.merge            |refs/heads/main                           |local  |

---

    Code
      show_tags(remote_url)
    Output
      # A tibble: 1 x 2
        name        ref                  
        <chr>       <chr>                
      1 v0.0.0.9001 refs/tags/v0.0.0.9001

---

    Code
      show_files(remote_url)
    Output
      remote/DESCRIPTION remote/NAMESPACE   remote/NEWS.md     remote/R           
      remote/R/bla.R     remote/tea.Rproj   

