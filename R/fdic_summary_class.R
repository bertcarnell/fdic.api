# Copyright 2019 Robert Carnell

#' @title FDIC API Query for Summary Information
#' 
#' @description A class to create Summary queries to the FDIC API.  Derived
#' from class \code{fdic_base}.
#' 
#' @details 
#' Example filters
#' \itemize{
#'   \item{Filter by Community Banks (CB) vs. Savings Institutions (SI)}
#'   \item{Filter by State name: STNAME:"Virginia"}
#'   \item{Filter for any one of multiple State names: STNAME:("West Virginia","Delaware")}
#'   \item{Filter data by the year range: YEAR:["2015" TO "2017"]}
#'   \item{Filter for data in Alabama in 2005: STNAME:"Alabama" AND YEAR:2005}
#' }
#' Example fields: \code{STNAME,YEAR,INTINC,EINTEXP,NIM,NONII,NONIX,ELNATR,ITAXR,IGLSEC,ITAX,EXTRA,NETINC }
#' Example sort_by: \code{YEAR}
#' 
#' @inheritSection .fdic_doc_function Params
#' @inheritSection .fdic_doc_function Aggregate_Params
#' 
#' @inheritSection .fdic_doc_function Usage
#' @inheritSection .fdic_doc_function Aggregate_Usage
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
#'   x <- fdic_summary$new()
#'   x$get_available_fields()
#'   x$get_available_field_description("INTINC")
#' }
fdic_summary <- R6::R6Class("fdic_summary",
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
          agg_by = private$agg_by,
          agg_term_fields = private$agg_term_fields,
          agg_sum_fields = private$agg_sum_fields,
          agg_limit = private$agg_limit,
          offset = private$offset,
          format = private$format,
          download = private$download,
          filename = private$filename
        )
      )
    },
    setAgg_by = function(agg_by) {private$agg_by = agg_by},
    setAgg_term_fields = function(agg_term_fields) {private$agg_term_fields = agg_term_fields},
    setAgg_sum_fields = function(agg_sum_fields) {private$agg_sum_fields = agg_sum_fields},
    setAgg_limit = function(agg_limit) {private$agg_limit = agg_limit}
  ),
  private = list(
    yaml_file = "summary_properties.yaml",
    query_path = "/api/summary",
    agg_by = NULL,
    agg_term_fields = NULL,
    agg_sum_fields = NULL,
    agg_limit = NULL
  )
)
