#' Show the estimated coefficients in a regression and diagnostics
#'
#'
#' @param regression an lm object
#' @param ... passed to [partial()]
#'
#' @return Returns markdown/HTML text with class "knit_asis"
#'
#' @export
#' @examples
#' \dontrun{
#' # will generate figures in a temporary directory
#' if(!requireNamespace("pkgdown", quietly = TRUE) || !pkgdown::in_pkgdown()) {
#' data("ChickWeight")
#' regression <- lm(weight ~ Time, data = ChickWeight)
#' regression_diagnostics(regression)
#' }
#' }
regression_diagnostics <- function(regression, ...) {
  partial(require_file("inst/_regression_diagnostics.Rmd"), ...)
}
