## Pre-release checks

- [ ] Review CRP last edited {{{ crp_date }}}.
    {{{ crp_changes }}}
- [ ] Check on win-builder, R devel
- [ ] Review PR
{{{ check_cran_comments }}}

## Action items

- Run `fledge::release()`{{{ fledge_gha_workflow_release }}}
- Confirm CRAN e-mail
- When the package is accepted on CRAN, run `fledge::post_release()`{{{ fledge_gha_workflow_release }}}
