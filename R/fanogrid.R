#' Select a grid size for clustered point data
#'
#' Estimates the grid size and the Fano factor together, since each estimator takes the other's output as its input.
#' Starting from the Poisson solution, [select_grid()] and [estimate_fano()] are applied in turn until the grid changes by less than `tol`, or until `max_iter` rounds have run.
#' A warning is issued when the grid is still moving after the last round.
#'
#' @param points A data frame with numeric columns `X` and `Y`, in the units of `window`, all inside it.
#' @param window Numeric vector `c(xmin, xmax, ymin, ymax)` giving the rectangular observation window.
#' @param max_iter Largest number of rounds to run.
#' @param tol Relative change in the grid size below which the loop stops.
#'   Set it to 0 to run all `max_iter` rounds.
#' @param r,eta,correction Passed to [estimate_fano()].
#' @param n_min,n_max,n_grid Passed to [select_grid()].
#'
#' @return A list with the selected cell side `delta`, the Fano factor `fano` measured on that grid, the number of rounds `n_iter`, and `trace`, a data frame with one row per round.
#'
#' @examples
#' gps <- read.csv(system.file("extdata", "synthetic_gps.csv.xz",
#'                             package = "fanogrid"))
#' window <- c(xmin = -21403, xmax = -11488, ymin = -34895, ymax = -24936)
#'
#' fit <- fanogrid(gps, window)
#' fit$delta
#' fit$trace
#'
#' @export
fanogrid <- function(points, window, max_iter = 5L, tol = 0.01,
                     r = 20, eta = 0.25, correction = "isotropic",
                     n_min = 8L, n_max = 400L, n_grid = 120L) {
  check_inputs(points, window)
  stopifnot(max_iter >= 1, tol >= 0)

  grid <- select_grid(points, window, fano = 1,
                      n_min = n_min, n_max = n_max, n_grid = n_grid)

  trace <- vector("list", max_iter)
  settled <- FALSE
  for (round_i in seq_len(max_iter)) {
    fano <- estimate_fano(points, window, grid$nx, grid$ny,
                          r = r, eta = eta, correction = correction)
    next_grid <- select_grid(points, window, fano = fano,
                             n_min = n_min, n_max = n_max, n_grid = n_grid)
    trace[[round_i]] <- data.frame(iter = round_i - 1L,
                                   nx = grid$nx, ny = grid$ny,
                                   delta = grid$delta, fano = fano)
    settled <- abs(next_grid$delta - grid$delta) / grid$delta < tol
    if (settled) break
    grid <- next_grid
  }
  if (tol > 0 && !settled) {
    warning("the grid was still moving after ", max_iter,
            " rounds; raise max_iter or loosen tol")
  }
  trace <- do.call(rbind, trace[seq_len(round_i)])

  # The answer is the grid the last Fano factor was measured on, not the grid that factor would send us to next.
  last_row <- trace[nrow(trace), ]
  list(delta = last_row$delta, fano = last_row$fano, n_iter = nrow(trace),
       trace = trace)
}
