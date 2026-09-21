# Cell index of each point on an nx by ny grid over `window`.
#
# Both estimators bin the points, and the alternation in fanogrid() only makes sense if they bin them the same way, so the rule lives here rather than in each of them.
# Cells are numbered (ix - 1) * ny + iy, running down the y axis first.
# A point sitting exactly on the far edge belongs to the last cell.
cell_index <- function(points, window, nx, ny) {
  width_x <- window[["xmax"]] - window[["xmin"]]
  width_y <- window[["ymax"]] - window[["ymin"]]
  ix <- pmin(floor((points$X - window[["xmin"]]) / width_x * nx) + 1, nx)
  iy <- pmin(floor((points$Y - window[["ymin"]]) / width_y * ny) + 1, ny)
  (ix - 1) * ny + iy
}

# Shared argument checks.
# The window carries the cell geometry and serves as the observation window of the point pattern, so a point outside it would be counted in an edge cell and then handed to Kinhom as if it were inside.
check_inputs <- function(points, window) {
  stopifnot(
    is.data.frame(points),
    all(c("X", "Y") %in% names(points)),
    is.numeric(points$X), is.numeric(points$Y),
    nrow(points) >= 2,
    is.numeric(window), length(window) == 4,
    all(c("xmin", "xmax", "ymin", "ymax") %in% names(window)),
    window[["xmin"]] < window[["xmax"]],
    window[["ymin"]] < window[["ymax"]],
    all(points$X >= window[["xmin"]]), all(points$X <= window[["xmax"]]),
    all(points$Y >= window[["ymin"]]), all(points$Y <= window[["ymax"]])
  )
  invisible(TRUE)
}
