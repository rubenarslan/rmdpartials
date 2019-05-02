#' Generate a small plot that will be enlarged in a modal when clicked
#'
#'
#' @param plot a ggplot2 plot
#' @param plot_name optional: specify a meaningful plot name (needs to be unique in the document)
#'
#' @export
#' @examples
#' # will generate figure in a temporary directory
#' knit_to_temp_dir()
#' enlarge_plot(ggplot2::qplot(1:10))
enlarge_plot <- function(plot, plot_name = NULL,
                         width_small = 2,
                         height_small = 2,
                         width_large = 7,
                         height_large = 7) {
  if (is.null(plot_name)) {
    plot_name <- digest::digest(stats::runif(1))
  }

  asis_knit_child(require_file("_enlarge_plot.Rmd"), name = plot_name)
}