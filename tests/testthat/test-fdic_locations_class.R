context("test-fdic_locations_class")

test_that("fdic_locations works", {
  if (curl::has_internet()) 
  {
    x <- fdic_locations$new()
    field_temp <- x$get_available_fields()
    expect_equal(length(field_temp), 35)
    descrip_temp <- x$get_available_field_description("CBSA")
    expect_equal(descrip_temp$type, "string")
    expect_equal(descrip_temp$title, "Core Based Statistical Area Name")
    expect_true(grepl("^Name of the Core", descrip_temp$description))
    
    x <- fdic_locations$new()
    x$setFilters("COUNTY:Franklin")
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 38)
    expect_true(temp$totals$count > 0)
    expect_true(temp$meta$total > 0)
    
    x <- fdic_locations$new()
    x$setFields(c("NAME","UNINUM","SERVTYPE","RUNDATE","CITY","STNAME","ZIP","COUNTY"))
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 9)
    expect_equal(nrow(temp$data), 10000)
    expect_true(temp$totals$count > 10000)
    expect_true(temp$meta$total > 10000)
    
    x <- fdic_locations$new()
    x$setSort_by("NAME")
    x$setSort_order("DESC")
    x$setLimit(100)
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 38)
    expect_equal(nrow(temp$data), 100)
    expect_true(temp$totals$count > 10000)
    expect_true(temp$meta$total > 10000)
  } else
  {
    expect_true(TRUE)
  }
})
