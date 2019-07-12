#' Knit a child document and output as is (render markup)
#'
#' This slightly modifies the [knitr::knit_child()] function to have different defaults.
#' - the environment defaults to the calling environment.
#' - the output receives the class `knit_asis`, so that the output will be rendered "as is" by knitr when calling inside a chunk (no need to set `results='asis'` as a chunk option).
#' - defaults to `quiet = TRUE`
#'
#' Why default to the calling environment? Typically this function defaults to the global environment. This makes sense if you want to use knit children in the same context as the rest of the document.
#' However, you may also want to use knit children inside functions to e.g. summarise a regression using a set of commands (e.g. plot some diagnostic graphs and a summary for a regression nicely formatted).
#'
#' Some caveats:
#' - the function has to return to the top-level. There's no way to [cat()] this from loops or an if-condition without without setting `results='asis'`. You can however concatenate these objects with [paste.knit_asis()]
#'
#'
#' @param input if you specify a file path here, it will be read in before being passed to knitr (to avoid a working directory mess)
#' @param text passed to [knitr::knit_child()]
#' @param ... passed to [knitr::knit_child()]
#' @param quiet passed to [knitr::knit_child()]
#' @param options defaults to NULL.
#' @param envir passed to [knitr::knit_child()]
#' @param name a name to use for cacheing and figure paths. Randomly generated if left unspecified.
#' @param show_code whether to print the R code for the partial or just the results (sets the chunk option echo = FALSE while the chunk is being rendered)
#' @param use_strings whether to read in the child file as a character string (solves working directory problems but harder to debug)
#'
#' @export
#' @examples
#' # super simple partial example
#' partial(text = "Test")
#'
#' \dontrun{
#' # an example of a wrapper function that calls partial with an argument
#' # ensures distinct paths for cache and figures, so that these calls can be looped in parallel
#' regression_summary <- function(regression) {
#'    partial("_regression_summary.Rmd")
#' }
#' }
partial <- function(input = NULL, text = NULL, ...,
                            quiet = TRUE, options = NULL,
                            envir = parent.frame(), name = NULL,
                            show_code = FALSE,
                            use_strings = TRUE) {

  # allow duplicate chunk labels in knitr, useful for knit_child
  options(knitr.duplicate.label = 'allow')

  stopifnot( xor(is.null(text), is.null(input)))

  if (!is.null(input) && use_strings) {
    text <- paste0(readLines(input), collapse = "\n")
    input <- NULL
  }

  child_mode <- knitr::opts_knit$get("child")
  if (child_mode) {
    child <- knitr::opts_knit$get("child")
    knitr::opts_knit$set(child = TRUE)
    on.exit(knitr::opts_knit$set(child = child))
  } else {
    child <- !interactive()
  }

  if (is.null(options)) {
    if (is.null(name)) {
      name <- digest::digest(stats::runif(1))
    }
    safe_name <- safe_name(name)
    options <- list(
      fig.path = paste0(knitr::opts_chunk$get("fig.path"), safe_name, "_"),
      cache.path = paste0(knitr::opts_chunk$get("cache.path"), safe_name, "_")
    )
  }

  output_file_md <- NULL
  if (!child) {
    www_dir <- tempfile("viewhtml")
    dir.create(www_dir)
    options$base.dir <- www_dir
    options <- list(
      fig.path = paste0(www_dir, "/", knitr::opts_chunk$get("fig.path"), safe_name, "_"),
      cache.path = paste0(www_dir, "/", knitr::opts_chunk$get("cache.path"), safe_name, "_")
    )
    output_file_md <- file.path(www_dir, "index.md")
    output_file_html <- file.path(www_dir, "index.html")
  }

  if (is.list(options)) {
    options$label <- options$child <- NULL
    if (length(options)) {
      optc <- knitr::opts_chunk$get(names(options), drop = FALSE)
      knitr::opts_chunk$set(options)
      on.exit({
        for (i in names(options)) if (identical(options[[i]],
                      knitr::opts_chunk$get(i))) knitr::opts_chunk$set(optc[i])
      }, add = TRUE)
    }
  }

  encode <- knitr::opts_knit$get("encoding")
  if (is.null(encode)) {
    encode <- getOption("encoding")
  }

  chunk_echo <- knitr::opts_chunk$get("echo")
  knitr::opts_chunk$set(echo = show_code)
  res <- knitr::knit(input = input, output = output_file_md, text = text, ...,
                     quiet = quiet, tangle = knitr::opts_knit$get("tangle"),
                     envir = envir, encoding = encode)
  knitr::opts_chunk$set(echo = chunk_echo)

  output <- knitr::asis_output(paste(c("", res), collapse = "\n"))
  if (child) {
    output
  } else {
    if (requireNamespace("rmarkdown", quietly = TRUE)) {
      path <- utils::capture.output(suppressMessages(rmarkdown::render(res,
                          output_file = output_file_html,
                          rmarkdown::html_document())))
      viewer <- getOption("viewer", utils::browseURL)
      viewer(path)
    } else {
      warning("The partial was not shown in the viewer, because rmarkdown is ",
              "not installed.")
    }
    invisible(output)
  }
}
