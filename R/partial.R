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
#' @param ... ignored, but you can use it to clarify which variables will be used in the rmd partial
#' @param text passed to [knitr::knit_child()]
#' @param output if you specify a file path here, where to put the file
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
partial <- function(input = NULL, ...,
                    text = NULL, output = NULL,
                    quiet = TRUE, options = NULL,
                    envir = parent.frame(), name = NULL,
                    show_code = FALSE,
                    use_strings = TRUE) {

  # allow duplicate chunk labels in knitr, useful for knit_child
  envir <- envir # if I don't do this, rmarkdown somehow doesn't use the right
  # environment for some reason (knitr does)
  dupes <- getOption("knitr.duplicate.label")
  options(knitr.duplicate.label = 'allow')
  on.exit(options(knitr.duplicate.label = dupes))

  knit_options <- list()

  stopifnot( xor(is.null(text), is.null(input)))

  if (!is.null(input) && use_strings) {
    text <- paste0(readLines(input), collapse = "\n")
    input <- NULL
  }

  if (is.null(options)) {
    options <- list()
  }
  stopifnot(is.list(options))

  if (is.null(name)) {
    # xxx <- function(...) {
    #   digest::digest(list(...))
    # }
    name <- substr(digest::digest(stats::runif(1)), 1, 10)
  }
  safe_name <- safe_name(name)
  if (is.null(options$fig.path)) {
    options$fig.path <- paste0(
      knitr::opts_chunk$get("fig.path"), safe_name, "_")
  }
  if (is.null(options$cache.path)) {
    options$cache.path <- paste0(
      knitr::opts_chunk$get("cache.path"), safe_name, "_")
  }


  # unfortunately opts_knit child is not always set if the child is not called
  # via a chunk option
  child <- knitr::opts_knit$get("child")

  # so we build our own
  ## if there is a viewer available, we are probably in RStudio and not knitting
  not_interactive <- !is_interactive()

  # if an output file is specified
  if (!is.null(output)) {
    knitr::opts_knit$set(output.dir = dirname(output))
  }

  ## if we are not in the working directory, we have presumably already started
  ## knitting in a temporary directory
  in_tmp_dir <- !is.null(knitr::opts_knit$get("output.dir")) &&
    !identical(knitr::opts_knit$get("output.dir"), getwd())


  child_mode <- is.null(output) && (child || not_interactive || in_tmp_dir)

  if (child_mode) {
    knit_options$child <- TRUE
    if (is.null(knitr::opts_knit$get("output.dir"))) {
      knit_options$output.dir <- getwd()
    }
  } else {
    if (!is.null(output)) {
      www_dir <- dirname(output)
      file_name <- tools::file_path_sans_ext(basename(output))
    } else {
      www_dir <- tempfile("preview_partial")
      dir.create(www_dir)
      file_name <- "index"
    }

    input_file_rmd <- file.path(www_dir, paste0(file_name, ".Rmd"))
    output_file_md <- file.path(www_dir, paste0(file_name, ".knit.md"))
    output_file_html <- file.path(www_dir, paste0(file_name, ".html"))

    knit_options$base.dir <- www_dir
    knit_options$output.dir <- www_dir
    options$fig.path <- paste0(www_dir, "/",
                              knitr::opts_chunk$get("fig.path"), safe_name, "_")
    options$cache.path <- paste0(www_dir, "/",
                            knitr::opts_chunk$get("cache.path"), safe_name, "_")
  }

  # handle chunk options
  options$label <- options$child <- NULL
  options$echo <- show_code
  optc <- knitr::opts_chunk$get(names(options), drop = FALSE)
  knitr::opts_chunk$set(options)
  on.exit({
    for (i in names(options)) if (identical(options[[i]],
                  knitr::opts_chunk$get(i))) knitr::opts_chunk$set(optc[i])
  }, add = TRUE)

  # handle knit options
  optk <- knitr::opts_knit$get(names(knit_options), drop = FALSE)
  knitr::opts_knit$set(knit_options)
  on.exit({
      for (i in names(knit_options)) if (identical(knit_options[[i]],
                    knitr::opts_knit$get(i))) knitr::opts_knit$set(optk[i])
  }, add = TRUE)

  encode <- knitr::opts_knit$get("encoding")
  if (is.null(encode)) {
    encode <- getOption("encoding")
  }

  knit_meta <- NULL
  if (child_mode) {
    res <- knitr::knit(input = input, output = NULL, text = text,
                       quiet = quiet, tangle = knitr::opts_knit$get("tangle"),
                       envir = envir, encoding = encode)
  } else {
    cat(text, file = input_file_rmd)
    knit_meta <- list()
    knit_meta$output.dir <- knit_options$output.dir
    knit_meta$output.file <- output_file_html

    if (requireNamespace("rmarkdown", quietly = TRUE)) {
      # knitr::opts_chunk$set(screenshot.force = FALSE)
      path <- utils::capture.output(path <- suppressMessages(
        rmarkdown::render(input_file_rmd, output_file = output_file_html,
                          envir = envir, encoding = encode,
                          clean = FALSE,
                          rmarkdown::html_document(self_contained = FALSE))
      ))
    } else {
      warning("The partial was not shown in the viewer, because rmarkdown is ",
              "not installed.")
    }

    res <- paste0(readLines(output_file_md), collapse = "\n")
  }


  knitr::asis_output(paste(c("", res), collapse = "\n"),
                            meta = knit_meta)
}

is_interactive <- function()
  {
  if (identical(getOption("knitr.in.progress"), TRUE)) {
    return(FALSE)
  }
  if (identical(getOption("rstudio.notebook.executing"), TRUE)) {
    return(FALSE)
  }
  if (identical(Sys.getenv("TESTTHAT"), "true")) {
    return(FALSE)
  }
  interactive()
}
