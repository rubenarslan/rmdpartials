#' Print `knit_asis` as rendered HTML in the viewer
#'
#' @param x the knit_asis object
#' @param ... ignored
#'
#' @export
#' @examples
#' text <- paste(c("### Headline",
#' "Text"), collapse = "\n")
#' knitr::asis_output(text)
print.knit_asis <- function(x, ...) {
  viewer <- getOption("viewer")
  if (!is.null(viewer)) {
    if (is.null(attributes(x)$knit_meta)
        || is.null(attributes(x)$knit_meta$output.dir)) {
      www_dir <- tempfile("preview_partial")
      dir.create(www_dir)
    } else {
      www_dir <- attributes(x)$knit_meta$output.dir
    }
    output_file_html <- file.path(www_dir, "index.html")
    if (file.exists(output_file_html)) {
      path <- output_file_html
      viewer(path)
    } else {
      input_file_md <- file.path(www_dir, "index.md")
      cat(x, file = input_file_md)

      if (requireNamespace("rmarkdown", quietly = TRUE)) {
        # knitr::opts_chunk$set(screenshot.force = FALSE)
        utils::capture.output(path <- suppressMessages(
          rmarkdown::render(input_file_md, output_file = output_file_html,
                            rmarkdown::html_document(self_contained = FALSE)))
        )
        viewer(path)
      } else {
        warning("The partial was not shown in the viewer, because rmarkdown is ",
                "not installed.")
      }
    }

  } else {
    message("No viewer found, probably checking")
    cat(x)
  }
  invisible(x)
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


function ()
{
  opt <- peek_option("rlang_interactive")
  if (!is_null(opt)) {
    if (!is_bool(opt)) {
      options(rlang_interactive = NULL)
      abort("`rlang_interactive` must be a single `TRUE` of `FALSE`")
    }
    return(opt)
  }
  if (is_true(peek_option("knitr.in.progress"))) {
    return(FALSE)
  }
  if (is_true(peek_option("rstudio.notebook.executing"))) {
    return(FALSE)
  }
  if (identical(Sys.getenv("TESTTHAT"), "true")) {
    return(FALSE)
  }
  interactive()
}