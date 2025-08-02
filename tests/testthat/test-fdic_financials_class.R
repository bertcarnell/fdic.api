context("test-fdic_financials_class")

source("tests/testthat/api_key_secret.R")

test_that("fdic_financials works", {
  if (curl::has_internet()) 
  {
    x <- fdic_financials$new(api_key_secret)
    field_temp <- x$get_available_fields()
    expect_true(length(field_temp) > 2300)
    descrip_temp <- x$get_available_field_description("CERT")
    expect_equal(descrip_temp$type, "number")

    x$setFilters("COUNTY:Franklin and YEAR:2022")
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 38)
    expect_true(temp$totals$count > 0)
    expect_true(temp$meta$total > 0)
  } else
  {
    expect_true(TRUE)
  }
})
