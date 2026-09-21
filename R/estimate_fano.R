#' Estimate the Fano factor of a point pattern
#'
#' The Fano factor \eqn{F} is the ratio of the variance of the cell counts to
#' their mean. For a Poisson process \eqn{F = 1}; points that arrive in groups
#' push it above one. The estimate uses the ball approximation
#' \deqn{F = 1 + \bar{\lambda} (K_{inhom}(r) - \pi r^2),}
#' where \eqn{K_{inhom}} is the inhomogeneous K-function and \eqn{\bar{\lambda}}
#' the mean intensity, so the value depends on the radius `r` over which the
#' clustering is counted rather than on the shape of a counting cell.
#'
#' The intensity is taken to be constant within each cell of the `nx` by `ny`
#' grid and is estimated from the cell counts. Cells whose intensity falls in
#' the lowest `eta` quantile are dropped and the window is restricted to the
#' cells that remain, which keeps the \eqn{1/\lambda_i \lambda_j} weights in
#' \eqn{K_{inhom}} from blowing up where the intensity is near zero. The weight
#' of each point uses the leave-one-out intensity \eqn{(k - 1)/|S|}, with the
#' point's own contribution to its cell count removed.
#'
#' @param points A data frame with numeric columns `X` and `Y`, in the units of
#'   `window`.
#' @param window Numeric vector `c(xmin, xmax, ymin, ymax)` giving the
#'   rectangular observation window.
#' @param nx,ny Number of grid cells along the x and y axis. These set the
#'   cells over which the intensity is taken to be constant.
#' @param r Radius of the ball, in the units of `window`, over which the excess
#'   clustering is counted.
#' @param eta Fraction of cells to drop, taken from the low-intensity end.
#' @param nr Number of sub-intervals of \eqn{[0, r]} at which
#'   \eqn{K_{inhom}} is evaluated.
#' @param correction Edge correction passed to
#'   [spatstat.explore::Kinhom()]: one of `"isotropic"`, `"translate"` or
#'   `"border"`.
#'
#' @return A single number, the estimated Fano factor.
#'
#' @references
#' Aoki, T., Koyama, S. and Fujiwara, N.
#' How fine a grid do GPS data support for urban populations when people move
#' together?
#'
#' @examples
#' \dontrun{
#' estimate_fano(synthetic_gps, target_area, nx = 40, ny = 40)
#' }
#'
#' @export
estimate_fano <- function(points, window, nx, ny,
                          r = 20, eta = 0.25, nr = 200L,
                          correction = "isotropic") {
  stop("not implemented")
}
