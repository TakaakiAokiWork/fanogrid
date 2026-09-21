test_that("points without X and Y are rejected", {
  expect_error(select_grid(data.frame(a = 1:3, b = 1:3), example_window))
})

test_that("a window with reversed corners is rejected", {
  expect_error(select_grid(example_points,
                           c(xmin = 0, xmax = -1, ymin = 0, ymax = 1)))
})

test_that("points outside the window are rejected", {
  shrunk <- example_window
  shrunk[["xmin"]] <- shrunk[["xmin"]] + 3000
  expect_error(estimate_fano(example_points, shrunk, nx = 43, ny = 43))
})

test_that("a non-integer number of divisions is rejected", {
  expect_error(estimate_fano(example_points, example_window,
                             nx = 43.5, ny = 43.5))
})

test_that("a grid at the edge of the scan range warns", {
  expect_warning(select_grid(example_points, example_window, fano = 1,
                             n_min = 300L, n_max = 400L, n_grid = 20L))
})
