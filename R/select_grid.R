#' Select a grid size by minimising the MISE cost
#'
#' Scans square grids and returns the one that minimises
#' \deqn{C(\Delta) = \frac{2 F \bar{k} - v}{(\Delta_x \Delta_y)^2},}
#' the cost that remains once the grid-independent part of the mean integrated
#' squared error is dropped. Here \eqn{\bar{k}} and \eqn{v} are the mean and the
#' variance of the counts over the cells and \eqn{F} is the Fano factor. Setting
#' `fano = 1` assumes the points fall independently and reproduces the
#' Poisson-based selector of Shimazaki and Shinomoto (2007) in two dimensions;
#' a larger `fano` inflates the sampling-error term and so selects a coarser
#' grid.
#'
#' The scan runs over `n_grid` division counts spaced evenly on a log scale
#' between `n_min` and `n_max`, with the same count on both axes.
#'
#' @param points A data frame with numeric columns `X` and `Y`, in the units of
#'   `window`.
#' @param window Numeric vector `c(xmin, xmax, ymin, ymax)` giving the
#'   rectangular observation window.
#' @param fano Fano factor held fixed during the scan. The default of 1 gives
#'   the Poisson selector.
#' @param n_min,n_max Smallest and largest number of divisions per axis.
#' @param n_grid Number of division counts to try between `n_min` and `n_max`.
#'
#' @return A list with components `nx` and `ny`, the selected number of
#'   divisions per axis, and `delta`, the cell side
#'   \eqn{\sqrt{W_x W_y / (n_x n_y)}}.
#'
#' @references
#' Shimazaki, H. and Shinomoto, S. (2007)
#' A method for selecting the bin size of a time histogram.
#' \emph{Neural Computation} \strong{19}(6), 1503-1527.
#' \doi{10.1162/neco.2007.19.6.1503}
#'
#' Omi, T. and Shinomoto, S. (2011)
#' Optimizing time histograms for non-Poissonian spike trains.
#' \emph{Neural Computation} \strong{23}(12), 3125-3144.
#' \doi{10.1162/NECO_a_00213}
#'
#' @examples
#' \dontrun{
#' select_grid(synthetic_gps, target_area)
#' select_grid(synthetic_gps, target_area, fano = 1.5)
#' }
#'
#' @export
select_grid <- function(points, window, fano = 1,
                        n_min = 8L, n_max = 400L, n_grid = 120L) {
  stop("not implemented")
}
