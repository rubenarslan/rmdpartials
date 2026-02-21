# Changelog

## rmdpartials 0.6.4

### Bugfixes

- Fix `needs_preview()` to handle NULL child option safely
- Remove deprecated `encoding` parameter from
  [`knitr::knit()`](https://rdrr.io/pkg/knitr/man/knit.html) and
  [`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html)
  calls
- Remove dead `checkArgs` detection code in `needs_preview()`
- Fix inconsistent `require_file()` calls in
  [`regression_diagnostics()`](https://rubenarslan.github.io/rmdpartials/reference/regression_diagnostics.md)
  and
  [`knit_child_debug()`](https://rubenarslan.github.io/rmdpartials/reference/knit_child_debug.md)

## rmdpartials 0.6.3

- Remove `LazyData` field (no data directory in package)
- Fix NEWS.md format for CRAN
- Re-enable tests in `R CMD check` (were excluded via `.Rbuildignore`)
- Update redirected URLs (travis-ci, codecov, github.io)

## rmdpartials 0.6.2

### Bugfixes

- fix tests with new knitr
- don’t show message about testing in print.knit_asis
