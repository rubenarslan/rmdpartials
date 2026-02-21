# Knit a child document and output as is (render markup)

This modifies and extends the
[`knitr::knit_child()`](https://rdrr.io/pkg/knitr/man/knit_child.html)
function. Defaults change as follows:

- the environment defaults to the calling environment, or if passed, to
  arguments passed via ...

- the output receives the class `knit_asis`, so that the output will be
  rendered "as is" by knitr when calling inside a chunk (no need to set
  `results='asis'` as a chunk option).

- defaults to `quiet = TRUE`

- the package additionally renders `knit_asis` objects in the viewer
  when printed to make previewing partials easier. This is achieved
  using
  [`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html)
  and done in a temporary directory (only when used interactively/not in
  child mode).

- the package takes care of some troubles behind the scenes that you
  might find yourself in if you nest partials (by trying to resolve path
  ambiguities, using text instead of files for sources, and some
  functionality to prevent iteratively overwriting generated figures and
  other files)

## Usage

``` r
partial(
  input = NULL,
  ...,
  text = NULL,
  output = NULL,
  quiet = TRUE,
  options = NULL,
  envir = parent.frame(),
  name = NULL,
  cacheable = NA,
  show_code = FALSE,
  use_strings = TRUE,
  render_preview = needs_preview(),
  preview_output_format = NULL
)
```

## Arguments

- input:

  if you specify a file path here, it will be read in before being
  passed to knitr (to avoid a working directory mess)

- ...:

  ignored, but you can use it to clarify which variables will be used in
  the rmd partial

- text:

  passed to
  [`knitr::knit_child()`](https://rdrr.io/pkg/knitr/man/knit_child.html)

- output:

  if you specify a file path here, where to put the file

- quiet:

  passed to
  [`knitr::knit_child()`](https://rdrr.io/pkg/knitr/man/knit_child.html)

- options:

  defaults to NULL.

- envir:

  passed to
  [`knitr::knit_child()`](https://rdrr.io/pkg/knitr/man/knit_child.html)

- name:

  a name to use for cacheing and figure paths. Randomly generated if
  left unspecified.

- cacheable:

  whether the results of this partial can be cached in knitr

- show_code:

  whether to print the R code for the partial or just the results (sets
  the chunk option echo = FALSE while the chunk is being rendered)

- use_strings:

  whether to read in the child file as a character string (solves
  working directory problems but harder to debug)

- render_preview:

  true if interactive mode is auto-detected, false when actually
  knitting the partial as a child

- preview_output_format:

  defaults to
  [`rmarkdown::html_document()`](https://pkgs.rstudio.com/rmarkdown/reference/html_document.html)
  with self_contained set to true

## Value

Returns rendered markdown with the class "knit_asis". When used
interactively, the knit_meta attributes will additionally contain the
path of a rendered preview in a temporary directory.

## Details

Why default to the calling environment? Typically this function defaults
to the global environment. This makes sense if you want to use knit
children in the same context as the rest of the document. However, you
may also want to use knit children to respect conventional scoping rules
inside functions to e.g. summarise a regression using a set of commands
(e.g. plot some diagnostic graphs and a summary for a regression nicely
formatted).

Some caveats:

- the function has to return to the top-level. There's no way to
  [`cat()`](https://rdrr.io/r/base/cat.html) this from loops or an
  if-condition without without setting `results='asis'`. You can however
  concatenate these objects with
  [`paste.knit_asis()`](https://rubenarslan.github.io/rmdpartials/reference/paste.knit_asis.md)

- currently not yet producing expected results in RStudio notebooks in
  interactive use

## Examples

``` r
# super simple partial example
partial(text = "Test")
#> 
#> Test

# an example of a wrapper function that calls partial with an argument
# ensures distinct paths for cache and figures, so that these calls can be looped in parallel
regression_diagnostics <- function(regression, ...) {
   partial(system.file("_regression_diagnostics.Rmd",
           package = "rmdpartials", mustWork = TRUE),
           regression = regression, ...)
}
```
