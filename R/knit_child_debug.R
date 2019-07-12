#' Get some debugging information on various potential problems when making partials
#'
#'
#' @param ... passed to [partial()]
#'
#' @export
#' @examples
#' knit_child_debug()
knit_child_debug <- function(...) {
  partial(require_file("_debug.Rmd"), ...)
}

