context("test-fdic_institutions_class")

test_that("fdic_instiutions works", {
  if (curl::has_internet()) 
  {
    x <- fdic_institutions$new()
    field_temp <- x$get_available_fields()
    expect_true(length(field_temp) > 130)
    descrip_temp <- x$get_available_field_description("CBSA")
    expect_equal(descrip_temp$type, "string")
    expect_equal(descrip_temp$title, "Name of the Core Based Statistical Area")
    expect_true(grepl("^The name associated", descrip_temp$description))
    
    x <- fdic_institutions$new()
    x$setFilters("STALP:OH AND ACTIVE:1")
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 133)
    expect_true(temp$totals$count > 0)
    expect_true(temp$meta$total > 0)
    
    x <- fdic_institutions$new()
    x$setFilters("STALP:OH AND ACTIVE:1")
    x$setFields(c("ZIP","OFFDOM","CITY","COUNTY","STNAME","STALP","NAME","ACTIVE",
                  "CERT","CBSA","ASSET","NETINC","DEP","DEPDOM","ROE","ROA",
                  "DATEUPDT","OFFICES"))
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 18)
    expect_true(temp$totals$count > 0)
    expect_true(temp$meta$total > 0)
    
    x <- fdic_institutions$new()
    x$setFilters("STALP:OH AND ACTIVE:1")
    x$setFields(c("ZIP","OFFDOM","CITY","COUNTY","STNAME","STALP","NAME","ACTIVE",
                  "CERT","CBSA","ASSET","NETINC","DEP","DEPDOM","ROE","ROA",
                  "DATEUPDT","OFFICES"))
    x$setSort_by("OFFICES")
    temp <- x$query_fdic()
    expect_equal(ncol(temp$data), 18)
    expect_true(temp$totals$count > 0)
    expect_true(temp$meta$total > 0)

    x <- fdic_institutions$new()
    x$setFilters("STALP:OH AND ACTIVE:1")
    x$setFields(c("ZIP","OFFDOM","CITY","COUNTY","STNAME","STALP","NAME","ACTIVE",
                  "CERT","CBSA","ASSET","NETINC","DEP","DEPDOM","ROE","ROA",
                  "DATEUPDT","OFFICES"))
    x$setSort_by("OFFICES")
    x$setLimit(3)
    x$setSort_order("ASC")
    temp <- x$query_fdic()
    expect_equal(nrow(temp$data), 3)
    expect_equal(ncol(temp$data), 18)
    expect_true(temp$totals$count > 0)
    expect_true(temp$meta$total > 0)
  } else
  {
    expect_true(TRUE)
  }
})
