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
#' api_key_secret <- Sys.getenv("FDIC_API_KEY")
#' if (curl::has_internet() & api_key_secret != "") {
#'   x <- fdic_summary$new(api_key_secret)
#'   x$get_available_fields()
#'   x$get_available_field_description("INTINC")
#' }
fdic_summary <- R6::R6Class("fdic_summary",
  inherit = fdic_base,
  public = list(
    #' @description
    #' Initialization Method
    #' @param api_key API key
    #' @returns an object of type fdic_sod
    initialize = function(api_key) {
      super$initialize(api_key)
      private$yamlderived <- super$parse_yaml(private$yaml_file)
    },
    #' @description
    #' Query FDIC API
    #' @returns an object containing metadata and a data.frame 
    query_fdic = function() {
      super$fdic_api(private$query_path, 
        list(
          filters = private$filters,
          fields = paste(private$fields, collapse = ","),
          sort_by = private$sort_by,
          limit = private$limit,
          offset = private$offset,
          agg_by = private$agg_by,
          agg_term_fields = private$agg_term_fields,
          agg_sum_fields = private$agg_sum_fields,
          agg_limit = private$agg_limit,
          max_value = private$max_value,
          max_value_by = private$max_value_by,
          format = private$format,
          download = private$download,
          filename = private$filename
        )
      )
    },
    #' @description
    #' Field by which the data will be aggregated
    #' @param agg_by field to aggregate by
    #' @returns NULL
    setAgg_by = function(agg_by) {private$agg_by = agg_by},
    #' @description
    #' Fields for which aggregations will be counted
    #' @param agg_term_fields field to aggregate by
    #' @returns NULL
    setAgg_term_fields = function(agg_term_fields) {private$agg_term_fields = agg_term_fields},
    #' @description
    #' Fields for which aggregations will be summed
    #' @param agg_sum_fields field to aggregate by
    #' @returns NULL
    setAgg_sum_fields = function(agg_sum_fields) {private$agg_sum_fields = agg_sum_fields},
    #' @description
    #' limit on how many aggregated fields will be displayed
    #' @param agg_limit aggregation limits
    #' @returns NULL
    setAgg_limit = function(agg_limit) {private$agg_limit = agg_limit},
    #' @description
    #' the field by which the max value is desired
    #' @param max_value the max value field.
    #' @returns NULL
    setMax_value = function(max_value) {private$max_value = max_value},
    #' @description
    #' the field that will be used to determine the unique records
    #' @param max_value_by the max value field.
    #' @returns NULL
    setMax_value_by = function(max_value_by) {private$max_value_by = max_value_by}
  ),
  private = list(
    yaml_file = "summary_properties.yaml",
    query_path = "/banks/summary",
    agg_by = NULL,
    agg_term_fields = NULL,
    agg_sum_fields = NULL,
    agg_limit = NULL,
    max_value = NULL,
    max_value_by = NULL
  )
)
