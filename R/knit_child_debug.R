#' Get some debugging information on various potential problems when making partials
#'
#'
#' @param ... passed to [partial()]
#'
#' @export
#' @examples
#' \dontrun{
#' knit_child_debug()
#' }
knit_child_debug <- function(...) {
  partial(require_file("inst/_debug.Rmd"), ...)
}

