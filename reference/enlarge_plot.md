# Generate a small plot that will be enlarged in a modal when clicked

Generate a small plot that will be enlarged in a modal when clicked

## Usage

``` r
enlarge_plot(
  plot,
  large_plot = plot,
  plot_name = NULL,
  width_small = 2,
  height_small = 2,
  width_large = 7,
  height_large = 7,
  ...
)
```

## Arguments

- plot:

  a plot

- large_plot:

  a larger version of the same plot. defaults to the first plot if left
  empty, but this only works for ggplot2 and similar, not base plots

- plot_name:

  optional: specify a meaningful plot name (needs to be unique in the
  document)

- width_small:

  width for the small plot

- height_small:

  height for the small plot

- width_large:

  width for the large plot

- height_large:

  height for the large plot

- ...:

  passed to
  [`partial()`](https://rubenarslan.github.io/rmdpartials/reference/partial.md)

## Value

Returns markdown/HTML text with class "knit_asis"

## Examples

``` r
if (FALSE) { # \dontrun{
if(!requireNamespace("pkgdown", quietly = TRUE) || !pkgdown::in_pkgdown()) {
# will generate files in a temporary directory
if (requireNamespace("ggplot2")) {
dist <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, hp)) +
         ggplot2::geom_point()
enlarge_plot(dist,
large_plot = dist + ggplot2::theme_classic(base_size = 18))
} else {
graphics::hist(stats::rbeta(200, 3, 4))
dist <- grDevices::recordPlot()
enlarge_plot(dist)
}
}
} # }
```
