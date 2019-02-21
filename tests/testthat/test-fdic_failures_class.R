context("test-fdic_failures_class")

test_that("fdic_failures works", {
  if (curl::has_internet()) 
  {
    x <- fdic_failures$new()
    field_temp <- x$get_available_fields()
    expect_equal(length(field_temp), 14)
    descrip_temp <- x$get_available_field_description("COST")
    expect_equal(descrip_temp$type, "number")
    expect_equal(descrip_temp$title, "Estimated Loss")
    expect_true(grepl("^The estimated loss", descrip_temp$description))
    
    x <- fdic_failures$new()
    x$setFilters("FAILYR:[2014 TO 2015]")
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 95) # Note that the fields don't match the return
    expect_true(temp$totals$count > 0)
    expect_true(temp$meta$total > 0)
    
    x <- fdic_failures$new()
    x$setFields(c("NAME","CERT","FIN","CITYST","FAILDATE","SAVR","RESTYPE",
                  "RESTYPE1","QBFDEP","QBFASSET","COST"))
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 11)
    expect_equal(nrow(temp$data), 4096)
    expect_equal(temp$totals$count, 4096)
    expect_equal(temp$meta$total, 4096)
    
    x <- fdic_failures$new()
    x$setSort_by("NAME")
    x$setSort_order("DESC")
    x$setLimit(100)
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 95) # Note that the fields don't match the return
    expect_equal(nrow(temp$data), 100)
    expect_true(temp$totals$count > 4000)
    expect_true(temp$meta$total > 4000)
    
    x <- fdic_failures$new()
    x$setAgg_by("CITYST")
    x$setAgg_limit(15) # only return 15 years
    x$setAgg_sum_fields("COST") # sum non interest income
    x$setAgg_term_fields("FAILYR")
    temp <- x$query_fdic()
    expect_equal(nrow(temp$data), 15)
    expect_equal(ncol(temp$data), 15)

    x <- fdic_failures$new()
    x$setFields(c("COST","FAILYR","CERT"))
    x$setTotal_fields("COST")
    x$setSubtotal_by("FAILYR")
    temp <- x$query_fdic()
    expect_equal(ncol(temp$totals$subtotal_by_FAILYR), 3)
    expect_equal(nrow(temp$totals$subtotal_by_FAILYR), 10)
    expect_equal(ncol(temp$data), 3)
    expect_true(nrow(temp$data) > 4000)
  } else
  {
    expect_true(TRUE)
  }
})
