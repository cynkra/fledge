# bump_version() works -- dev

    unused argument (classes = "descMessage")

# bump_version() errors informatively for forbidden notifications

    x Unindexed change(s) in `DESCRIPTION`.
    i Commit the change(s) before running any fledge function again.

# bump_version() errors informatively for wrong branch

    x Must be on the main branch (main) for running fledge functions.
    i Currently on branch bla.

# bump_version() errors well for wrong arguments

    `no_change_behavior` must be one of "bump", "noop", or "fail", not "blabla".

---

    `which` must be one of "dev", "patch", "pre-minor", "minor", "pre-major", or "major", not "blabla".

