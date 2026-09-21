#' Synthetic GPS points with a known amount of clustering
#'
#' One realisation of a clustered point pattern over a 9.9 km by 10.0 km area of
#' Tokyo. The underlying population density is piecewise constant on the 250-meter
#' grid of the 2015 Japanese population census (JIS X 0410 quarter mesh, cells of
#' about 283 m by 231 m), so the scale a grid-size selector should recover is set
#' by construction. Points are then drawn by a multi-generational Poisson cluster
#' process with a Gaussian offspring kernel of standard deviation 2 m, which
#' places points in groups a few metres across in the way people who travel
#' together do.
#'
#' The process was tuned to a Fano factor of 1.5 and an expected 10,000 points;
#' this realisation has 10,070. Coordinates are in metres in the Japan Plane
#' Rectangular CS IX projection (EPSG:6677). [target_area] holds the window.
#'
#' @format A data frame with 10,070 rows and 2 columns:
#' \describe{
#'   \item{X}{Easting in metres (EPSG:6677).}
#'   \item{Y}{Northing in metres (EPSG:6677).}
#' }
#'
#' @source Generated with the census-based simulator of Aoki, Koyama and
#'   Fujiwara at `fano = 1.5`, `N = 10000`, `sigma_h = 2.0`, `seed = 42`.
"synthetic_gps"

#' Observation window for the synthetic GPS points
#'
#' The rectangle over which [synthetic_gps] was generated, in metres in the
#' Japan Plane Rectangular CS IX projection (EPSG:6677). It measures 9,915 m
#' along x and 9,959 m along y. Every function in this package takes a window in
#' this form.
#'
#' @format A named numeric vector of length 4, with elements `xmin`, `xmax`,
#'   `ymin` and `ymax`.
"target_area"
