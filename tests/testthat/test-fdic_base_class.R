context("test-fdic_base_class")

test_that("fdic_api works", {
  if (curl::has_internet()) 
  {
     x <- fdic_base$new()
     resp <- x$fdic_api("/api/institutions", 
       list(filters = "STALP:OH AND ACTIVE:1",
         fields = "ZIP,OFFDOM,CITY,COUNTY,STNAME,STALP,NAME,ACTIVE,CERT,CBSA,ASSET,NETINC,DEP,DEPDOM,ROE,ROA,DATEUPDT,OFFICES",
         sort_by = "OFFICES",
         sort_order = "DESC",
         limit = 10,
         offset = 0,
         format = "json",
         download = "false",
         filename = "data_file"))
     expect_equal(nrow(resp$data), 10)
     expect_equal(ncol(resp$data), 18)
  } else
  {
    expect_true(TRUE)
  }
})

test_that("fdic_base errors", {
  if (curl::has_internet())
  {
    x <- fdic_base$new()
    expect_error(x$get_available_fields())
    expect_error(x$get_available_field_description())
    resp <- x$fdic_api("/api/institutions", 
                       list(filters = "STALP:OH AND ACTIVE:1",
                            fields = "ZIP,OFFDOM,CITY,COUNTY,STNAME,STALP,NAME,ACTIVE,CERT,CBSA,ASSET,NETINC,DEP,DEPDOM,ROE,ROA,DATEUPDT,OFFICES",
                            sort_by = "OFFICES",
                            sort_order = "DESC",
                            limit = 10,
                            offset = 0,
                            format = "json",
                            download = "false",
                            filename = "data_file"))
    expect_error(x$get_available_field_description("TEST_ME"))
    expect_error(x$setLimit(1E10))
    expect_error(x$setSort_order("UPANDDOWN"))
    expect_error(x$fdic_api("", list(filters = "", fields = "", sort_by = "", 
                                     sort_order = "", limit = 10, offset = 0, 
                                     format = "", download = "",
                                     filename = "")))
    
  } else
  {
    expect_true(TRUE)
  }
})
  