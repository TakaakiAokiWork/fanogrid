# The sample the vignette uses, read once for the whole test run.
# Its underlying density is piecewise constant on a 250 m lattice and its points arrive in clusters tuned to a Fano factor of 2, so both the grid size and the Fano factor have a known target.
example_window <- c(xmin = -21403, xmax = -11488, ymin = -34895, ymax = -24936)
example_points <- read.csv(
  system.file("extdata", "synthetic_gps.csv.xz", package = "fanogrid")
)
