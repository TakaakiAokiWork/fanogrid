#' Estimate the Fano factor of a point pattern
#'
#' The Fano factor is the ratio of the variance of the cell counts to their mean, and it is 1 for a Poisson process.
#' It is estimated from the inhomogeneous K-function at radius `r`, on a grid of `nx` by `ny` cells within which the intensity is taken to be constant.
#'
#' @param points A data frame with numeric columns `X` and `Y`, in the units of `window`, all inside it.
#' @param window Numeric vector `c(xmin, xmax, ymin, ymax)` giving the rectangular observation window.
#' @param nx,ny Number of grid cells along the x and y axis.
#' @param r Radius, in the units of `window`, over which the clustering is counted.
#' @param eta Fraction of cells to drop, taken from the low-intensity end.
#' @param correction Edge correction passed to [spatstat.explore::Kinhom()]: one of `"isotropic"`, `"translate"` or `"border"`.
#'
#' @return A single number, the estimated Fano factor.
#'
#' @examples
#' gps <- read.csv(system.file("extdata", "synthetic_gps.csv.xz",
#'                             package = "fanogrid"))
#' window <- c(xmin = -21403, xmax = -11488, ymin = -34895, ymax = -24936)
#'
#' estimate_fano(gps, window, nx = 43, ny = 43)
#'
#' @export
estimate_fano <- function(points, window, nx, ny,
                          r = 20, eta = 0.25, correction = "isotropic") {
  check_inputs(points, window)
  stopifnot(nx >= 1, nx == round(nx), ny >= 1, ny == round(ny),
            r > 0, eta >= 0, eta < 1)
  correction_column <- c(isotropic = "iso", translate = "trans",
                         border = "border")
  correction <- match.arg(correction, names(correction_column))

  xmin <- window[["xmin"]]
  ymin <- window[["ymin"]]
  cell_width <- (window[["xmax"]] - xmin) / nx
  cell_height <- (window[["ymax"]] - ymin) / ny
  cell_area <- cell_width * cell_height

  cell_of_point <- cell_index(points, window, nx, ny)
  cell_counts <- tabulate(cell_of_point, nbins = nx * ny)
  cell_intensity <- cell_counts / cell_area

  # Drop the low-intensity cells.
  # The threshold comes from the occupied cells, so empty cells, which are the part of the rectangle that holds no data, fall below it and go as well.
  threshold <- stats::quantile(cell_intensity[cell_counts > 0], eta,
                               names = FALSE)
  cell_is_kept <- cell_intensity >= threshold
  point_is_kept <- cell_is_kept[cell_of_point]

  # The window is the union of the kept cells, each an exact rectangle.
  kept_cells <- which(cell_is_kept)
  ix <- ((kept_cells - 1) %/% ny) + 1L
  iy <- ((kept_cells - 1) %% ny) + 1L
  rectangles <- lapply(seq_along(kept_cells), function(k) {
    x0 <- xmin + (ix[k] - 1) * cell_width
    y0 <- ymin + (iy[k] - 1) * cell_height
    sf::st_polygon(list(rbind(
      c(x0, y0), c(x0 + cell_width, y0),
      c(x0 + cell_width, y0 + cell_height), c(x0, y0 + cell_height), c(x0, y0)
    )))
  })
  kept_window <- spatstat.geom::as.owin(sf::st_union(sf::st_sfc(rectangles)))

  kept_pattern <- spatstat.geom::ppp(
    points$X[point_is_kept], points$Y[point_is_kept],
    window = kept_window, check = FALSE
  )
  mean_intensity <- sum(point_is_kept) / spatstat.geom::area(kept_window)

  # Leave-one-out weight: the point's own contribution to its cell count is removed, which would otherwise make each point look like a cluster of one.
  loo_intensity <- (cell_counts - 1) / cell_area
  point_weights <- loo_intensity[cell_of_point][point_is_kept]
  point_weights[is.na(point_weights) | point_weights <= 0] <- mean_intensity

  # Only K at the far end of the range is used, and that value does not depend on the intermediate radii, so the estimate is evaluated on c(0, r).
  k_inhom <- spatstat.explore::Kinhom(kept_pattern, lambda = point_weights,
                                      r = c(0, r), correction = correction)
  k_at_r <- k_inhom[[correction_column[[correction]]]][2]
  1 + mean_intensity * (k_at_r - pi * r^2)
}
