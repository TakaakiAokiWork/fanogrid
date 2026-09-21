#' Select a grid size by minimising the MISE cost
#'
#' Scans square grids and returns the one that minimises the mean integrated squared error, with the sampling-error term scaled by the Fano factor.
#' A warning is issued when the chosen grid sits at either end of the scan range.
#'
#' @param points A data frame with numeric columns `X` and `Y`, in the units of `window`, all inside it.
#' @param window Numeric vector `c(xmin, xmax, ymin, ymax)` giving the rectangular observation window.
#' @param fano Fano factor held fixed during the scan.
#' @param n_min,n_max Smallest and largest number of divisions per axis.
#' @param n_grid Number of division counts to try, spaced evenly on a log scale.
#'
#' @return A list with the number of divisions per axis, `nx` and `ny`, and the cell side `delta`.
#'
#' @examples
#' gps <- read.csv(system.file("extdata", "synthetic_gps.csv.xz",
#'                             package = "fanogrid"))
#' window <- c(xmin = -21403, xmax = -11488, ymin = -34895, ymax = -24936)
#'
#' select_grid(gps, window)
#' select_grid(gps, window, fano = 2)
#'
#' @export
select_grid <- function(points, window, fano = 1,
                        n_min = 8L, n_max = 400L, n_grid = 120L) {
  check_inputs(points, window)
  stopifnot(length(fano) == 1, is.finite(fano),
            n_min >= 1, n_max >= n_min, n_grid >= 1)

  width_x <- window[["xmax"]] - window[["xmin"]]
  width_y <- window[["ymax"]] - window[["ymin"]]
  n_points <- nrow(points)

  # Candidate divisions per axis, spaced evenly on a log scale so that each one is about the same fraction finer than the last.
  # Rounding to whole divisions leaves duplicates at the coarse end, which unique() drops.
  division_counts <- unique(round(
    exp(seq(log(n_min), log(n_max), length.out = n_grid))
  ))

  costs <- vapply(division_counts, function(n) {
    counts <- tabulate(cell_index(points, window, n, n), nbins = n * n)
    mean_count <- n_points / (n * n)
    var_count <- (sum(counts^2) - n_points^2 / (n * n)) / (n * n)
    cell_area <- (width_x / n) * (width_y / n)
    (2 * fano * mean_count - var_count) / cell_area^2
  }, numeric(1))

  best_n <- division_counts[which.min(costs)]
  if (best_n == division_counts[1] ||
      best_n == division_counts[length(division_counts)]) {
    warning("the selected grid sits at the edge of the scan range; ",
            "widen n_min or n_max")
  }
  list(nx = best_n, ny = best_n,
       delta = sqrt(width_x * width_y / (best_n * best_n)))
}
