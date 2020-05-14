#' Knit a child document and output as is (render markup)
#'
#' This modifies and extends the [knitr::knit_child()] function. Defaults change as follows:
#' - the environment defaults to the calling environment, or if passed, to arguments passed via ...
#' - the output receives the class `knit_asis`, so that the output will be rendered "as is" by knitr when calling inside a chunk (no need to set `results='asis'` as a chunk option).
#' - defaults to `quiet = TRUE`
#' - the package additionally renders `knit_asis` objects in the viewer when printed to make previewing partials easier. This is achieved using [rmarkdown::render()] and done in a temporary directory (only when used interactively/not in child mode).
#' - the package takes care of some troubles behind the scenes that you might find yourself in if you nest partials (by trying to resolve path ambiguities, using text instead of files for sources, and some functionality to prevent iteratively overwriting generated figures and other files)
#'
#' Why default to the calling environment? Typically this function defaults to the global environment. This makes sense if you want to use knit children in the same context as the rest of the document.
#' However, you may also want to use knit children to respect conventional scoping rules inside functions to e.g. summarise a regression using a set of commands (e.g. plot some diagnostic graphs and a summary for a regression nicely formatted).
#'
#' Some caveats:
#' - the function has to return to the top-level. There's no way to [cat()] this from loops or an if-condition without without setting `results='asis'`. You can however concatenate these objects with [paste.knit_asis()]
#' - currently not yet producing expected results in RStudio notebooks in interactive use
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
#' @param render_preview true if interactive mode is auto-detected, false when actually knitting the partial as a child
#' @param preview_output_format defaults to [rmarkdown::html_document()] with self_contained set to true
#'
#'
#' @return Returns rendered markdown with the class "knit_asis". When used interactively, the knit_meta attributes will additionally contain the path of a rendered preview in a temporary directory.
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
                    use_strings = TRUE,
                    render_preview = needs_preview(),
                    preview_output_format = NULL) {

  stopifnot( xor(is.null(text), is.null(input)))

  if (!is.null(output)) {
    if (missing(render_preview) && !render_preview) {
      # override render_preview default if output is specified
      render_preview <- TRUE
    } else if (!missing(render_preview) && !render_preview) {
      # but if render_preview was explicitly set, inform user
      stop("You cannot save an output file without enabling `render_preview`.")
    }
  }

  dots <-  rlang::dots_list(...,
                            .ignore_empty = "none",
                            .preserve_empty = FALSE,
                            .homonyms = "error",
                            .check_assign = TRUE)
  if (any(names(dots) == "")) {
    stop("All arguments passed via dots must be named.")
  }

  if (length(dots) > 0) {
    arguments_given <- TRUE
    # if dots argument were passed, they constitute the environment
    envir <- rlang::as_environment(dots, parent = envir)
  } else {
    arguments_given <- FALSE
    envir <- envir # if I don't do this, rmarkdown doesn't use the right
    # environment for some reason (knitr does)
  }

  # allow duplicate chunk labels in knitr, useful for knit_child
  dupes <- getOption("knitr.duplicate.label")
  on.exit(options(knitr.duplicate.label = dupes), add = TRUE)
  options(knitr.duplicate.label = 'allow')

  # prepare options
  knit_options <- list()
  if (is.null(options)) {
    options <- list()
  }
  stopifnot(is.list(options))

  # prepare chunk prefixes
  if (is.null(name)) {
    if(arguments_given) {
      name <- substr(digest::digest(envir), 1, 10)
    } else {
      name <- substr(digest::digest(stats::runif(1)), 1, 10)
    }
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


  # save the original working directory for relative paths, in case we use tmp
  if (!is.null(input) && use_strings) {
    if (!isAbsolutePath(input) &&
        !is.null(knitr::opts_knit$get("rmdpartials_original_wd"))) {
      input <- file.path(knitr::opts_knit$get("rmdpartials_original_wd"), input)
    }
    text <- paste0(readLines(input), collapse = "\n")
    input <- NULL
  }


  # decide whether to render as
  # a) child (in working directory, with knitr)
  # b) preview (in tmp directory, with rmarkdown)
  if (!render_preview) {
    knit_options$child <- TRUE
    if (is.null(knitr::opts_knit$get("output.dir"))) {
      knit_options$output.dir <- getwd()
    }
  } else if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    warning("No preview generated for the partial, because rmarkdown is ",
            "not installed.")
    knit_options$child <- TRUE
    render_preview <- FALSE
  } else {
    # prepare rendering a preview in a temporary location
    oldwd <- getwd()
    www_dir <- tempfile("rmdpartial")
    stopifnot(dir.create(www_dir))
    on.exit(knitr::opts_knit$set(rmdpartials_original_wd = NULL), add = TRUE)
    knitr::opts_knit$set(rmdpartials_original_wd = oldwd)
    on.exit(setwd(oldwd), add = TRUE)
    setwd(www_dir)
    www_dir <- getwd() # fix messy paths through tempfile
    file_name <- "index"

    input_file_rmd <- file.path(paste0(file_name, ".Rmd"))
    output_file_md <- file.path(paste0(file_name, ".knit.md"))
    output_file_html <- file.path(paste0(file_name, ".html"))

    options$fig.path <- paste0(knitr::opts_chunk$get("fig.path"),
                               safe_name, "_")
    options$cache.path <- paste0(knitr::opts_chunk$get("cache.path"),
                                 safe_name, "_")
  }

  # reduce odds of duplicate chunk names
  knit_options$unnamed.chunk.label <- "rmdpartial"

  # handle chunk options and resetting them
  options$label <- options$child <- NULL
  options$echo <- show_code
  optc <- knitr::opts_chunk$get(names(options), drop = FALSE)
  on.exit({
    for (i in names(options)) if (identical(options[[i]],
                  knitr::opts_chunk$get(i))) knitr::opts_chunk$set(optc[i])
  }, add = TRUE)
  knitr::opts_chunk$set(options)

  # handle knit options and resetting them
  optk <- knitr::opts_knit$get(names(knit_options), drop = FALSE)
  on.exit({
      for (i in names(knit_options)) if (identical(knit_options[[i]],
                    knitr::opts_knit$get(i))) knitr::opts_knit$set(optk[i])
  }, add = TRUE)
  knitr::opts_knit$set(knit_options)

  # taken from knit_child
  encode <- knitr::opts_knit$get("encoding")
  if (is.null(encode)) {
    encode <- getOption("encoding")
  }

  knit_meta <- list()
  if (!render_preview) {
    # a) render with knitr as child document
    knit_meta$output.dir <- knit_options$output.dir
    res <- knitr::knit(input = input, output = NULL, text = text,
                       quiet = quiet, tangle = knitr::opts_knit$get("tangle"),
                       envir = envir, encoding = encode)
  } else {
    # b) render with rmarkdown as preview
    text <- paste0("---
pagetitle: Partial preview
---

", text)
    cat(text, file = input_file_rmd)
    knit_meta$output.dir <- www_dir
    knit_meta$output.file <- output_file_html
    if (is.null(preview_output_format)) {
      preview_output_format <- rmarkdown::html_document(self_contained = TRUE)
    }

      # knitr::opts_chunk$set(screenshot.force = FALSE)
      messages <- utils::capture.output(
        path <- suppressMessages(
        rmarkdown::render(input_file_rmd,
                          output_format = preview_output_format,
                          output_file = output_file_html,
                          envir = envir, encoding = encode,
                          clean = FALSE
                          )
        )
      )
    knit_meta$rmarkdown_output <- messages
    res <- paste0(readLines(output_file_md), collapse = "\n")

    if (!is.null(output)) {
      # if the resulting file was supposed to be saved
      if (!isAbsolutePath(output) && exists("oldwd")) {
        output <- file.path(oldwd, output)
      }
      stopifnot(!file.exists(output))
      files <- file.path(knit_meta$output.dir, "index_files")
      if (dir.exists(files)) {
        new_files <- file.path(dirname(output), basename(files))
        stopifnot(!dir.exists(new_files))
        dir.create(new_files)
        file.copy(files, new_files,
                copy.date = TRUE, recursive = TRUE)
      }
      file.copy(path, output, copy.date = TRUE)
    }
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
  if (identical(Sys.getenv("TESTTHAT_interactive"), "true")) {
    return(TRUE)
  }
  if (identical(Sys.getenv("TESTTHAT"), "true")) {
    return(FALSE)
  }
  interactive()
}


needs_preview <- function() {
  # unfortunately opts_knit child is not always set if the child is not called
  # via a chunk option
  child <- knitr::opts_knit$get("child")


  # for checks, we don't want to clutter the build dir and it's running
  # examples that users will run as interactive
  checking <- Sys.getenv("checkArgs") != ""

  # so we build our own
  ## if there is a viewer available, we are probably in RStudio and not knitting
  interactive <- is_interactive()

  (!child && (checking || interactive))
}


#' Convert text or file to a partial
#'
#' This adds the `knit_asis` class to a markdown chunk, so that it can be rendered
#' in the viewer and simply echoed in other knitr chunks. Won't preserve figures
#' unless the path happens to be the same or you explicitly pass it to the knit_meta argument.
#'
#' @return Returns its input as text with class "knit_asis"
#'
#' @param text will be returned with the class "knit_asis"
#' @param knit_meta you can pass a path to figures and other resources here
#'
#' @export
#' @examples
#' my_partial <- as.partial("## Headline
#' Text")
as.partial <- function(text = NULL, knit_meta = list()) {
  knitr::asis_output(paste(c("", text), collapse = "\n"),
                   meta = knit_meta)
}

isAbsolutePath <- function(pathname) {
  if (regexpr("^~", pathname) != -1L)
    return(TRUE)
  if (regexpr("^.:(/|\\\\)", pathname) != -1L)
    return(TRUE)
  components <- strsplit(pathname, split = "[/\\]")[[1L]]
  if (length(components) == 0L)
    return(FALSE)
  (components[1L] == "")
}
