# Copyright 2019 Robert Carnell

#' @title FDIC API Query for Failure Information
#' 
#' @description A class to create Failure queries to the FDIC API.  Derived
#' from class \code{fdic_base}.
#' 
#' @details 
#' Example filters
#' \itemize{
#'   \item{Filter by Location:  CITYST:"MEMPHIS, TN"}
#'   \item{Filter by institution fail year range: FAILYR:["2015" TO "2016"]}
#' }
#' Example fields: \code{NAME,CERT,FIN,CITYST,FAILDATE,SAVR,RESTYPE,RESTYPE1,QBFDEP,QBFASSET,COST}
#' Example sort_by: \code{FAILDATE}
#' 
#' @inheritSection .fdic_doc_function Params
#' @inheritSection .fdic_doc_function Aggregate_Params
#' 
#' @section Total_Params:
#' \describe{
#'   \item{\code{total_fields}}{Fields to sum up (in a totals response object). Only numeric columns are valid.}
#'   \item{\code{subtotal_by}}{The field by which data will be subtotaled (in totals response object). Only categorical values should be used.}
#' }
#' 
#' @inheritSection .fdic_doc_function Usage
#' @inheritSection .fdic_doc_function Aggregate_Usage
#' 
#' @section Total_Usage:
#' \describe{
#'   \item{\code{fdic_failures$setTotal_fields(total_fields)}}{}
#'   \item{\code{fdic_failures$setSubtotal_by(subtotal_by)}}{}
#' }
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
#'   x <- fdic_failures$new()
#'   x$get_available_fields()
#'   x$get_available_field_description("FAILDATE")
#' }
fdic_failures <- R6::R6Class("fdic_failures",
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
          total_fields = private$total_fields,
          subtotal_by = private$subtotal_by,
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
    setAgg_limit = function(agg_limit) {private$agg_limit = agg_limit},
    setTotal_fields = function(total_fields) {private$total_fields = total_fields},
    setSubtotal_by = function(subtotal_by) {private$subtotal_by = subtotal_by}
  ),
  private = list(
    yaml_file = "failure_properties.yaml",
    query_path = "/api/failures",
    total_fields = NULL,
    subtotal_by = NULL,
    agg_by = NULL,
    agg_term_fields = NULL,
    agg_sum_fields = NULL,
    agg_limit = NULL
  )
)
