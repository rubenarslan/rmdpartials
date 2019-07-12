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


require_file <- function(file, package = 'rmdpartials') {
  system.file(file, package = package, mustWork = TRUE)
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
