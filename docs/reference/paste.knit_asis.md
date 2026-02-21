# Paste and output as is (render markup)

Helper function for `knit_asis` objects, useful when e.g.
[`partial()`](https://rubenarslan.github.io/rmdpartials/reference/partial.md)
was used in a loop.

## Usage

``` r
paste.knit_asis(..., sep = "\n\n\n", collapse = "\n\n\n")
```

## Arguments

- ...:

  passed to [`base::paste()`](https://rdrr.io/r/base/paste.html)

- sep:

  defaults to two empty lines, passed to
  [`base::paste()`](https://rdrr.io/r/base/paste.html)

- collapse:

  defaults to two empty lines, passed to
  [`base::paste()`](https://rdrr.io/r/base/paste.html)

## Value

Returns text with the class "knit_asis"

## Details

Works like [`base::paste()`](https://rdrr.io/r/base/paste.html) with
both the sep and the collapse argument set to two empty lines

## Examples

``` r

paste.knit_asis("# Headline 1", "## Headline 2")
#> # Headline 1
#> 
#> 
#> ## Headline 2
```
