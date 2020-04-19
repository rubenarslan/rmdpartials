#' Print `knit_asis` as rendered HTML in the viewer
#'
#' @param x the knit_asis object
#' @param ... ignored
#'
#' @return Invisibly returns its input, either prints its input or sends it to a viewer, if one is defined
#'
#' @export
#' @examples
#' text <- paste(c("### Headline",
#' "Text"), collapse = "\n")
#' print(knitr::asis_output(text))
print.knit_asis <- function(x, ...) {
  viewer <- getOption("viewer")
  if (!is.null(viewer)) {
    if (is.null(attributes(x)$knit_meta)
        || is.null(attributes(x)$knit_meta$output.dir)) {
      www_dir <- tempfile("preview_partial")
      stopifnot(dir.create(www_dir))
    } else {
      www_dir <- attributes(x)$knit_meta$output.dir
    }
    output_file_html <- attributes(x)$knit_meta$output.file
    if (!is.null(output_file_html) && file.exists(output_file_html)) {
      path <- output_file_html
      viewer(path)
    } else {
      if (requireNamespace("rmarkdown", quietly = TRUE)) {
        input_file_md <- file.path(www_dir, "index.md")
        text <- paste0("---
pagetitle: Partial preview
---

", x)
        cat(text, file = input_file_md)
        # knitr::opts_chunk$set(screenshot.force = FALSE)
        utils::capture.output(path <- suppressMessages(
          rmarkdown::render(input_file_md, output_file = output_file_html,
                            rmarkdown::html_document(self_contained = FALSE)))
        )
        viewer(path)
      } else {
        warning("The partial was not shown in the viewer, because rmarkdown is",
                " not installed.")
      }
    }

  } else {
    message("No viewer found, probably documenting or testing")
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
#' @return Returns text with the class "knit_asis"
#'
#' @export
#' @examples
#'
#' paste.knit_asis("# Headline 1", "## Headline 2")
paste.knit_asis <- function(..., sep = "\n\n\n", collapse = "\n\n\n") {
  knitr::asis_output(paste(..., sep = sep, collapse = collapse))
}



require_file <- function(file, package = 'rmdpartials') {
  file <- gsub("^inst/", "", file)
  system.file(file, package = package, mustWork = TRUE)
}

safe_name <- function(x) {
  gsub("[^[:alnum:]]", "_", x)
}

