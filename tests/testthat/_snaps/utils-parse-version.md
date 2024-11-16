# fledge_guess_version() works

    Code
      fledge_guess_version("1.1.1", "1.0.0")
    Condition
      Error in `fledge_guess_version()`:
      ! Can't release a version ("1.0.0") lower than the current version ("1.1.1").

---

    Code
      fledge_guess_version("1.1.1", "pre-minor")
    Output
      [1] "1.1.99.9900"

---

    Code
      fledge_guess_version("1.1.1", "pre-major")
    Output
      [1] "1.99.99.9900"

---

    Code
      fledge_guess_version("1.1.1", "boo")
    Condition
      Error in `fledge_guess_version()`:
      ! Unknown version specifier "boo".

