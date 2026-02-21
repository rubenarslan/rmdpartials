# Print `knit_asis` as rendered HTML in the viewer

Print `knit_asis` as rendered HTML in the viewer

## Usage

``` r
# S3 method for class 'knit_asis'
print(x, ...)
```

## Arguments

- x:

  the knit_asis object

- ...:

  ignored

## Value

Invisibly returns its input, either prints its input or sends it to a
viewer, if one is defined

## Examples

``` r
text <- paste(c("### Headline",
"Text"), collapse = "\n")
print(knitr::asis_output(text))
#> ### Headline
#> Text
```
