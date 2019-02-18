# Copyright 2019 Robert Carnell

#' Documentation function
#' 
#' @section Usage:
#' \describe{
#'   \item{\code{fdic_base$get_available_fields()}}{Get the fields available for queries}
#'   \item{\code{fdic_base$get_available_field_description(field)}}{Get the description of a field}
#'   \item{\code{fdic_base$setFilters(filters)}}{}
#'   \item{\code{fdic_base$setFields(fields)}}{}
#'   \item{\code{fdic_base$setSort_by(sort_by)}}{}
#'   \item{\code{fdic_base$setSort_order(sort_order)}}{}
#'   \item{\code{fdic_base$setLimit(limit)}}{}
#'   \item{\code{fdic_base$setOffset(offset)}}{}
#' }
#' 
#' @section Aggregate_Usage:
#' \describe{
#'   \item{\code{fdic_locations$setAgg_by(agg_by)}}{}
#'   \item{\code{fdic_locations$setAgg_term_fields(agg_term_fields)}}{}
#'   \item{\code{fdic_locations$setAgg_sum_fields(agg_sum_fields)}}{}
#'   \item{\code{fdic_locations$setAgg_limit(agg_limit)}}{}
#' }
#' 
#' @section Params:
#' \describe{
#'   \item{\code{field}}{one of the available query fields returned by \code{get_available_fields}}
#'   \item{\code{filters}}{the filter for the bank search.}
#'   \item{\code{fields}}{Comma delimited list of fields to search}
#'   \item{\code{sort_by}}{Field name by which to sort returned data}
#'   \item{\code{sort_order}}{Indicator if ascending (ASC) or descending (DESC)}
#'   \item{\code{limit}}{The number of records to return. Default is 10 and maximum is 10,000.}
#'   \item{\code{offset}}{The offset of page to return}
#' }
#' 
#' @section Aggregate_Params:
#' \describe{
#'   \item{\code{agg_by}}{The field(s) by which data will be aggregated. Valid values are 'YEAR' or 'YEAR,STNAME'.}
#'   \item{\code{agg_term_fields}}{The field(s) for which aggregations will be counted for each unique term.}
#'   \item{\code{agg_sum_fields}}{The field(s) for which aggregations will be summed or aggregated.}
#'   \item{\code{agg_limit}}{The limit on how many aggregated results will be displayed}
#' }
.fdic_doc_function <- function()
{
  stop("This function is not meant to be called")
}