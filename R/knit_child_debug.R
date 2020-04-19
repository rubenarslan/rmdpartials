#' Get some debugging information on various potential problems when making partials
#'
#'
#' @param ... passed to [partial()]
#'
#' @return Returns markdown/HTML text with class "knit_asis"
#'
#' @export
#' @examples
#' if(!requireNamespace("pkgdown", quietly = TRUE) || !pkgdown::in_pkgdown()) {
#' knit_child_debug()
#' }
knit_child_debug <- function(...) {
  partial(require_file("inst/_debug.Rmd"), ...)
}

