test_that("synthetic_gps has the documented shape", {
  expect_s3_class(synthetic_gps, "data.frame")
  expect_named(synthetic_gps, c("X", "Y"))
  expect_type(synthetic_gps$X, "double")
  expect_type(synthetic_gps$Y, "double")
  expect_equal(nrow(synthetic_gps), 10070)
})

test_that("target_area is a window in the expected form", {
  expect_named(target_area, c("xmin", "xmax", "ymin", "ymax"))
  expect_true(target_area[["xmin"]] < target_area[["xmax"]])
  expect_true(target_area[["ymin"]] < target_area[["ymax"]])
})

test_that("every point falls inside target_area", {
  expect_true(all(synthetic_gps$X >= target_area[["xmin"]] &
                  synthetic_gps$X <= target_area[["xmax"]]))
  expect_true(all(synthetic_gps$Y >= target_area[["ymin"]] &
                  synthetic_gps$Y <= target_area[["ymax"]]))
})
