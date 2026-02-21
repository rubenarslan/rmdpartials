# Get some debugging information on various potential problems when making partials

Get some debugging information on various potential problems when making
partials

## Usage

``` r
knit_child_debug(...)
```

## Arguments

- ...:

  passed to
  [`partial()`](https://rubenarslan.github.io/rmdpartials/reference/partial.md)

## Value

Returns markdown/HTML text with class "knit_asis"

## Examples

``` r
if(!requireNamespace("pkgdown", quietly = TRUE) || !pkgdown::in_pkgdown()) {
knit_child_debug()
}
```
