# Convert text or file to a partial

This adds the `knit_asis` class to a markdown chunk, so that it can be
rendered in the viewer and simply echoed in other knitr chunks. Won't
preserve figures unless the path happens to be the same or you
explicitly pass it to the knit_meta argument.

## Usage

``` r
as.partial(text = NULL, knit_meta = list())
```

## Arguments

- text:

  will be returned with the class "knit_asis"

- knit_meta:

  you can pass a path to figures and other resources here

## Value

Returns its input as text with class "knit_asis"

## Examples

``` r
my_partial <- as.partial("## Headline
Text")
```
