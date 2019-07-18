#' Generate a small plot that will be enlarged in a modal when clicked
#'
#'
#' @param x a dataset
#' @param y another dataset
#' @param by variables you plan to merge on
#' @param ... passed to dplyr join functions
#'
#' @export
#' @examples
#' # will generate figures in a temporary directory
#' if (requireNamespace("dplyr", quietly = TRUE)) {
#'    join_sets(band_members, band_instruments)
#' }
join_sets <- function(x, y, by = NULL, ...) {


  if (requireNamespace("dplyr", quietly = TRUE) &
      requireNamespace("DT", quietly = TRUE) &
      requireNamespace("rlang", quietly = TRUE)) {
    if (is.null(by)) {
      by <- intersect(colnames(x), colnames(y))
      names(by) <- by
    } else if (is.null(names(by))) {
      names(by) <- by
    }
    x_name <- deparse(substitute(x))
    y_name <- deparse(substitute(y))
    in_x_not_y <- dplyr::select(dplyr::anti_join(x = x, y = y, by = by, ...),
                    !!!rlang::syms(names(by)), dplyr::everything())
    in_y_not_x <- dplyr::anti_join(x = x, y = y, by = by, ...)
    in_x_and_y <- dplyr::semi_join(x = x, y = y, by = by, ...)
    x_rows <- nrow(x)
    y_rows <- nrow(y)
    x_duplicates <- nrow(dplyr::filter(
      dplyr::group_by(x, !!!rlang::syms(names(by))),
                                       dplyr::n() > 1))
    y_duplicates <- nrow(dplyr::filter(
      dplyr::group_by(y, !!!rlang::syms(unname(by))),
                                       dplyr::n() > 1))

    codebook::asis_knit_child(require_file("_join_sets.Rmd"))
  } else {
    warning("dplyr, rlang, and DT are required to use this function")
  }
}
