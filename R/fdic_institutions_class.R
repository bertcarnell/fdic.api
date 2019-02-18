# Copyright 2019 Robert Carnell

#' @title FDIC API Query for Institutions
#' 
#' @description A class to create Institutions queries to the FDIC API.  Derived
#' from class \code{fdic_base}.
#' 
#' @details 
#' Example filters
#' \itemize{
#'   \item{Filter by State name: STNAME:"West Virginia"}
#'   \item{Filter for any one of multiple State names: STNAME:("West Virginia","Delaware")}
#'   \item{Filter by last updated within an inclusive date range: DATEUPDT:["2010-01-01" TO "2010-12-31"]}
#'   \item{Filter for deposits over 50,000,000 (50000 thousands of dollars): DEP:[50000 TO *]}
#'   \item{Filter for active banks in Indiana: STALP:IA AND ACTIVE:1}
#' }
#' Example fields: \code{ZIP,OFFDOM,CITY,COUNTY,STNAME,STALP,NAME,ACTIVE,CERT,CBSA,ASSET,NETINC,DEP,DEPDOM,ROE,ROA,DATEUPDT,OFFICES}
#' Example sort_by: \code{OFFICES}
#' 
#' @inheritSection .fdic_doc_function Params
#' 
#' @inheritSection .fdic_doc_function Usage
#' 
#' @importFrom R6 R6Class
#' @importFrom yaml read_yaml
#' @importFrom httr modify_url GET
#' @importFrom jsonlite  fromJSON
#' @importFrom assertthat assert_that
#' @importFrom curl has_internet
#' @docType class
#' @keywords fdic financial bank
#' @references \url{https://banks.data.fdic.gov/docs/}
#' @export
#' 
#' @examples
#' if (curl::has_internet()) {
#'   x <- fdic_institutions$new()
#'   x$get_available_fields()
#'   x$get_available_field_description("CBSA")
#'   
#'   x <- fdic_institutions$new()
#'   x$setFilters("STALP:OH AND ACTIVE:1")
#'   x$setFields(c("ZIP","OFFDOM","CITY","COUNTY","STNAME","STALP","NAME","ACTIVE",
#'                 "CERT","CBSA","ASSET","NETINC","DEP","DEPDOM","ROE","ROA",
#'                 "DATEUPDT","OFFICES"))
#'   x$setSort_by("OFFICES")
#'   x$setLimit(100)
#'   res <- x$query_fdic()
#'   dim(res$data)
#' }
fdic_institutions <- R6::R6Class("fdic_institutions",
  inherit = fdic_base,
  public = list(
    initialize = function() {
      super$initialize()
      private$yamlderived <- super$parse_yaml(private$yaml_file)
    },
    query_fdic = function() {
      super$fdic_api(private$query_path, 
        list(
          filters = private$filters,
          fields = paste(private$fields, collapse = ","),
          sort_by = private$sort_by,
          limit = private$limit,
          offset = private$offset,
          format = private$format,
          download = private$download,
          filename = private$filename
        )
      )
    }
  ),
  private = list(
    yaml_file = "institution_properties.yaml",
    query_path = "/api/institutions"
  )
)
