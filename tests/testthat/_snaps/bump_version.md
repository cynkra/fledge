# bump_version() works -- dev

    Code
      bump_version()
    Message
      > Digesting messages from 3 commits.
      v Found 1 NEWS-worthy entry.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.0.9001.
      > Added header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9001 with tag message derived from 'NEWS.md'.
      ! Call `fledge::finalize_version(push = TRUE)`.

---

    x No change since last version.
    i Use `no_change_behavior = "bump"` to force a version bump, or
              `no_change_behavior = "noop"` to do nothing.

---

    Code
      bump_version(no_change_behavior = "noop")
    Message
      i No change since last version.

---

    Code
      bump_version(no_change_behavior = "bump")
    Message
      > Digesting messages from 1 commits.
      i Same as previous version.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 0.0.0.9002.
      > Added header to 'NEWS.md'.
      > Committing changes.
      
      -- Tagging Version --
      
      > Creating tag v0.0.0.9002 with tag message derived from 'NEWS.md'.
      ! Call `fledge::finalize_version(push = TRUE)`.

# bump_version() works -- not dev

    Code
      bump_version(which = "major")
    Message
      > Digesting messages from 3 commits.
      v Found 1 NEWS-worthy entry.
      
      -- Updating NEWS --
      
      > Adding new entries to 'NEWS.md'.
      
      -- Updating Version --
      
      v Package version bumped to 1.0.0.
      > Added header to 'NEWS.md'.
      > Committing changes.
      
      -- Preparing package for CRAN release --
      
      * Convert the change log in 'NEWS.md' to release notes.

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

# bump_version() does nothing if no preamble and not interactive

    Code
      bump_version()
    Message
      i Can't act non-interactively on a NEWS.md with no fledge-like preamble (HTML comment).

