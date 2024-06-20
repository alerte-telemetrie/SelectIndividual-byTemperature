test_data <- test_data("data_test_SelectIndividual-byTemperature.rds")

test_that("happy path", {
  actual <- rFunction(data = test_data, sdk = "unit test", year = 1998)
  expect_equal(unique(lubridate::year(mt_time(actual))), 1998)
})

test_that("year not included", {
  actual <- rFunction(data = test_data, sdk = "unit test", year = 1900)
  expect_null(actual)
})
