#' Select a grid size for clustered point data
#'
#' Estimates the grid size and the Fano factor together. Neither can be read off
#' the data on its own: the cost function of [select_grid()] needs a Fano
#' factor, and [estimate_fano()] needs a grid on which to hold the intensity
#' constant. The two are therefore updated in turn, starting from the Poisson
#' solution \eqn{F = 1}:
#'
#' 1. \eqn{\Delta_0} is the grid chosen by [select_grid()] at \eqn{F = 1}.
#' 2. \eqn{F_n} is the Fano factor estimated by [estimate_fano()] on the grid
#'    \eqn{\Delta_n}.
#' 3. \eqn{\Delta_{n+1}} is the grid chosen by [select_grid()] at \eqn{F_n}.
#'
#' Steps 2 and 3 repeat until the grid changes by less than `tol` in relative
#' terms, or until `max_iter` rounds have run. On the synthetic data of the
#' reference below the loop settles within a few rounds.
#'
#' @param points A data frame with numeric columns `X` and `Y`, in the units of
#'   `window`.
#' @param window Numeric vector `c(xmin, xmax, ymin, ymax)` giving the
#'   rectangular observation window.
#' @param max_iter Largest number of rounds to run.
#' @param tol Relative change in the grid size below which the loop stops.
#' @param r,eta,nr,correction Passed to [estimate_fano()].
#' @param n_min,n_max,n_grid Passed to [select_grid()].
#'
#' @return A list with the selected cell side `delta`, the Fano factor `fano` it
#'   was selected under, the number of rounds `n_iter`, and `trace`, a data
#'   frame with one row per round holding `iter`, `nx`, `ny`, `delta` and
#'   `fano`.
#'
#' @references
#' Aoki, T., Koyama, S. and Fujiwara, N.
#' How fine a grid do GPS data support for urban populations when people move
#' together?
#'
#' @examples
#' \dontrun{
#' fit <- fanogrid(synthetic_gps, target_area)
#' fit$delta
#' fit$trace
#' }
#'
#' @export
fanogrid <- function(points, window, max_iter = 5L, tol = 0.01,
                     r = 20, eta = 0.25, nr = 200L,
                     correction = "isotropic",
                     n_min = 8L, n_max = 400L, n_grid = 120L) {
  stop("not implemented")
}
