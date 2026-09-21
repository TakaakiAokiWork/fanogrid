# The expected values come from the implementation this package was ported from, estimate_gridsize_fano.R in the study repository, run on the same points.
# The grids agreed exactly and the Fano factors to 5e-11.
# fanogrid() is run once here and reused, because the first round works on a 122 by 122 grid and is the slow part.

fit <- fanogrid(example_points, example_window, max_iter = 5, tol = 0)

test_that("select_grid reproduces the Poisson selector", {
  g <- select_grid(example_points, example_window, fano = 1)
  expect_equal(g$nx, 122)
  expect_equal(g$ny, 122)
  expect_equal(g$delta, 81.450620054, tolerance = 1e-8)
})

test_that("a larger Fano factor selects a coarser grid", {
  poisson <- select_grid(example_points, example_window, fano = 1)
  clustered <- select_grid(example_points, example_window, fano = 2)
  expect_gt(clustered$delta, poisson$delta)
})

test_that("estimate_fano matches the reference implementation", {
  expect_equal(estimate_fano(example_points, example_window, nx = 43, ny = 43),
               2.0832234668, tolerance = 1e-8)
})

test_that("the edge correction can be changed", {
  for (correction in c("isotropic", "translate", "border")) {
    f <- estimate_fano(example_points, example_window, nx = 43, ny = 43,
                       correction = correction)
    expect_true(is.finite(f))
  }
})

test_that("fanogrid matches the reference trace", {
  expect_named(fit, c("delta", "fano", "n_iter", "trace"))
  expect_named(fit$trace, c("iter", "nx", "ny", "delta", "fano"))
  expect_equal(fit$trace$nx[1:2], c(122, 43))
  expect_equal(fit$trace$delta[1:2], c(81.450620054, 231.092456896),
               tolerance = 1e-8)
  expect_equal(fit$trace$fano[1:2], c(2.0168272476, 2.0832234668),
               tolerance = 1e-8)
})

test_that("tol = 0 runs every round and the grid stops moving", {
  expect_equal(fit$n_iter, 5L)
  expect_equal(length(unique(fit$trace$nx[-1])), 1L)
  expect_equal(length(unique(fit$trace$fano[-1])), 1L)
})

test_that("fanogrid reports the last row of its trace", {
  last <- fit$trace[nrow(fit$trace), ]
  expect_equal(fit$delta, last$delta)
  expect_equal(fit$fano, last$fano)
  expect_equal(fit$n_iter, nrow(fit$trace))
})
