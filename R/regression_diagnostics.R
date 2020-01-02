#' Show the estimated coefficients in a regression and diagnostics
#'
#'
#' @param regression an lm object
#' @param ... passed to [partial()]
#'
#' @export
#' @examples
#' # will generate figures in a temporary directory
#' data("ChickWeight")
#' regression <- lm(weight ~ Time, data = ChickWeight)
#' regression_diagnostics(regression)
regression_diagnostics <- function(regression, ...) {
  partial(require_file("inst/_regression_diagnostics.Rmd"), ...)
}
