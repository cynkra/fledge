# fledge_guess_version() works

    Code
      fledge_guess_version("1.1.1", "1.0.0")
    Condition
      Error in `fledge_guess_version()`:
      ! Can't release a version ("1.0.0") lower than the current version ("1.1.1").

---

    Code
      fledge_guess_version("1.1.1", "pre-minor")
    Condition
      Error in `fledge_guess_version()`:
      ! Can't update version from not dev to "pre-minor".

---

    Code
      fledge_guess_version("1.1.1", "pre-major")
    Condition
      Error in `fledge_guess_version()`:
      ! Can't update version from not dev to "pre-major".

---

    Code
      fledge_guess_version("1.1.1", "boo")
    Condition
      Error in `fledge_guess_version()`:
      ! Unknown version specifier "boo".

