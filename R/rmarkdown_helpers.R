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
#' @param use_strings whether to read in the child file as a character string (solves working directory problems but harder to debug)
#'
#' @export
#' @examples
#' \dontrun{
#' # an example of a wrapper function that calls partial with an argument
#' # ensures distinct paths for cache and figures, so that these calls can be looped in parallel
#' regression_summary <- function(model) {
#'    hash <- digest::digest(model)
#'    options <- list(
#'        fig.path = paste0(knitr::opts_chunk$get("fig.path"), hash, "-"),
#'        cache.path = paste0(knitr::opts_chunk$get("cache.path"), hash, "-"))
#'    partial("_regression_summary.Rmd", options = options)
#' }
#' }
partial <- function(input = NULL, text = NULL, ...,
                            quiet = TRUE, options = NULL,
                            envir = parent.frame(), name = NULL,
                            use_strings = TRUE) {
  stopifnot( xor(is.null(text), is.null(input)))
  if (!is.null(input) && use_strings) {
    text <- paste0(readLines(input), collapse = "\n")
    input <- NULL
  }

  if (knitr::opts_knit$get("child")) {
    child <- knitr::opts_knit$get("child")
    knitr::opts_knit$set(child = TRUE)
    on.exit(knitr::opts_knit$set(child = child))
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
  res <- knitr::knit(input = input, text = text, ...,
                     quiet = quiet, tangle = knitr::opts_knit$get("tangle"),
                     envir = envir, encoding = encode)
  knitr::asis_output(paste(c("", res), collapse = "\n"))
}


#' Paste and output as is (render markup)
#'
#' Helper function for `knit_asis` objects, useful when e.g. [partial()] was used in a loop.
#'
#' Works like [base::paste()] with both the sep and the collapse argument set to two empty lines
#'
#' @param ... passed to [base::paste()]
#' @param sep defaults to two empty lines, passed to [base::paste()]
#' @param collapse defaults to two empty lines, passed to [base::paste()]
#'
#' @export
#' @examples
#' paste.knit_asis("# Headline 1", "## Headline 2")
paste.knit_asis <- function(..., sep = "\n\n\n", collapse = "\n\n\n") {
  knitr::asis_output(paste(..., sep = sep, collapse = collapse))
}

#' Print new lines in `knit_asis` outputs
#'
#' @param x the knit_asis object
#' @param ... ignored
#'
#' @export
print.knit_asis <- function(x, ...) {
  cat(x, sep = '\n')
}



write_to_file <- function(..., name = NULL, ext = ".Rmd") {
  if (is.null(name)) {
    filename <- paste0(tempfile(), ext)
  } else {
    filename <- paste0(name, ext)
  }
  mytext <- eval(...)
  write(mytext, filename)
  return(filename)
}


require_file <- function(file) {
  system.file(file, package = 'rmdpartials', mustWork = TRUE)
}

recursive_escape <- function(x, depth = 0, max_depth = 4,
                             escape_fun = htmltools::htmlEscape) {
  if (depth < max_depth) {
    # escape names for all vectors
    if (!is.null(names(x))) {
      names(x) <- escape_fun(names(x))
    }
    if (!is.null(rownames(x))) {
      rownames(x) <- escape_fun(rownames(x))
    }

    # escape any character vectors
    if (is.character(x)) {
      x <- escape_fun(x)
    } else if (is.list(x) && class(x) == "list") {
      # turtle down into lists
      x <- lapply(x, function(x) { recursive_escape(x, depth + 1) })
    }
  }
  x
}

safe_name <- function(x) {
  gsub("[^[:alnum:]]", "_", x)
}

#' Knit to temp dir
#'
#' Use in examples of rmarkdown partials, so they do not clutter the user directory
#'
#'
#'
#' @export
#' @examples
#' knit_to_temp_dir()
#' enlarge_plot(ggplot2::qplot(1:10))
knit_to_temp_dir <- function() {
  old_base_dir <- knitr::opts_knit$get("base.dir")
  knitr::opts_knit$set(base.dir = tempdir())
  on.exit(knitr::opts_knit$set(base.dir = old_base_dir))
}
