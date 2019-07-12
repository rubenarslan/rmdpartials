#' Generate a small plot that will be enlarged in a modal when clicked
#'
#'
#' @param plot a plot
#' @param large_plot a larger version of the same plot. defaults to the first plot if left empty, but this only works for ggplot2 and similar, not base plots
#' @param plot_name optional: specify a meaningful plot name (needs to be unique in the document)
#' @param width_small width for the small plot
#' @param height_small height for the small plot
#' @param width_large width for the large plot
#' @param height_large height for the large plot
#' @param ... passed to [partial()]
#'
#' @export
#' @examples
#' # will generate figures in a temporary directory
#' enlarge_plot(plot(1:100), large_plot = plot(1:100))
enlarge_plot <- function(plot,
                         large_plot = plot,
                         plot_name = NULL,
                         width_small = 2,
                         height_small = 2,
                         width_large = 7,
                         height_large = 7,
                         ...) {
  if (is.null(plot_name)) {
    plot_name <- digest::digest(stats::runif(1))
  }

  partial(require_file("_enlarge_plot.Rmd"), name = plot_name,
          ...)
}
