context("test-fdic_summary_class")

test_that("fdic_summary works", {
  if (curl::has_internet()) 
  {
    x <- fdic_summary$new()
    field_temp <- x$get_available_fields()
    expect_equal(length(field_temp), 202)
    descrip_temp <- x$get_available_field_description("UNIT")
    expect_equal(descrip_temp$type, "integer")
    expect_equal(descrip_temp$title, "(CB) Unit Banks")
    expect_true(grepl("^Unit banks are", descrip_temp$description))
    
    x <- fdic_summary$new()
    x$setFilters("STNAME:Ohio")
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 283) # Note that the fields don't match the return
    expect_true(temp$totals$count > 0)
    expect_true(temp$meta$total > 0)
    
    x <- fdic_summary$new()
    x$setFields(c("STNAME","YEAR","INTINC","EINTEXP","NIM","NONII","NONIX",
                  "ELNATR","ITAXR","IGLSEC","ITAX","EXTRA","NETINC"))
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 13)
    expect_equal(nrow(temp$data), 7032)
    expect_equal(temp$totals$count, 7032)
    expect_equal(temp$meta$total, 7032)
    
    x <- fdic_summary$new()
    x$setSort_by("YEAR")
    x$setSort_order("DESC")
    x$setLimit(100)
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 294) # Note that the fields don't match the return
    expect_equal(nrow(temp$data), 100)
    expect_true(temp$totals$count > 5000)
    expect_true(temp$meta$total > 5000)
    
    x <- fdic_summary$new()
    x$setFilters("YEAR:[\"1990\" TO \"2010\"] AND STNAME:(\"West Virginia\",\"Delaware\")")
    x$setAgg_by("YEAR")
    x$setAgg_limit(15) # only return 15 years
    x$setAgg_sum_fields("NONII") # sum non interest income
    x$setAgg_term_fields("STNAME")
    temp <- x$query_fdic()
    expect_equal(nrow(temp$data), 15)
    expect_equal(ncol(temp$data), 5)
  } else
  {
    expect_true(TRUE)
  }
})
