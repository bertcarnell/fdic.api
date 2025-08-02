context("test-fdic_summary_class")

source("tests/testthat/api_key_secret.R")

test_that("fdic_summary works", {
  if (curl::has_internet()) 
  {
    x <- fdic_summary$new(api_key_secret)
    field_temp <- x$get_available_fields()
    expect_equal(length(field_temp), 203)
    descrip_temp <- x$get_available_field_description("UNIT")
    expect_equal(descrip_temp$type, "integer")
    expect_equal(descrip_temp$title, "Unit Banks")
    expect_true(grepl("^Unit banks are", descrip_temp$description))
    
    x <- fdic_summary$new(api_key_secret)
    x$setFilters("STNAME:Ohio")
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 278)
    expect_true(temp$totals$count > 0)
    expect_true(temp$meta$total > 0)
    
    x <- fdic_summary$new(api_key_secret)
    x$setFields(c("STNAME","YEAR","INTINC","EINTEXP","NIM","NONII","NONIX",
                  "ELNATR","ITAXR","IGLSEC","ITAX","EXTRA","NETINC"))
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 14)
    expect_true(nrow(temp$data) > 7500)
    expect_equal(temp$totals$count, nrow(temp$data))
    expect_equal(temp$meta$total, nrow(temp$data))
    
    x <- fdic_summary$new(api_key_secret)
    x$setSort_by("YEAR")
    x$setSort_order("DESC")
    x$setLimit(100)
    temp <- x$query_fdic()
    expect_true(ncol(temp$data) > 240)
    expect_equal(nrow(temp$data), 100)
    expect_true(temp$totals$count > 5000)
    expect_true(temp$meta$total > 5000)
    
    x <- fdic_summary$new(api_key_secret)
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
