# update_version() works

    Can't update version from not dev to pre-major.

---

    Can't bump to pre-minor from version 1.0.100.999 (patch >= 99).

---

    Can't bump to pre-minor from version 1.100.0.999 (minor >= 99).

---

    Can't increase version patch component (99) that is >= 99.

---

    Can't increase version minor component (99) that is >= 99.

# update_version() errors well

    Can't bump to pre-minor from version 0.0.99.9000 (patch >= 99).

---

    Can't bump to pre-major from version 0.99.99.9000 (patch >= 99).

