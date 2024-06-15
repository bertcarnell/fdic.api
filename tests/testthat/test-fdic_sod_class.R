context("test-fdic_sod_class")

test_that("fdic_sod works", {
  if (curl::has_internet()) 
  {
    x <- fdic_sod$new()
    field_temp <- x$get_available_fields()
    expect_equal(length(field_temp), 80)
    descrip_temp <- x$get_available_field_description("DEPSUMBR")
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
