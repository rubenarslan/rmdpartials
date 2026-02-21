# Show the estimated coefficients in a regression and diagnostics

Show the estimated coefficients in a regression and diagnostics

## Usage

``` r
regression_diagnostics(regression, ...)
```

## Arguments

- regression:

  an lm object

- ...:

  passed to
  [`partial()`](https://rubenarslan.github.io/rmdpartials/reference/partial.md)

## Value

Returns markdown/HTML text with class "knit_asis"

## Examples

``` r
if (FALSE) { # \dontrun{
# will generate files in a temporary directory
if(!requireNamespace("pkgdown", quietly = TRUE) || !pkgdown::in_pkgdown()) {
data("ChickWeight")
regression <- lm(weight ~ Time, data = ChickWeight)
regression_diagnostics(regression)
}
} # }
```
