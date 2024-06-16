# Copyright 2024 Robert Carnell

#' @title FDIC API Query for the summary of deposits (SOD)
#' 
#' @description A class to create Locations queries to the FDIC API.  Derived
#' from class \code{fdic_base}.
#' 
#' @details 
#' Example filters
#' \itemize{
#'   \item{Filter by State name: STNAME:"West Virginia"}
#'   \item{Filter for any one of multiple State names: STNAME:("West Virginia","Delaware")}
#'   \item{Filter by last updated within an inclusive date range: RUNDATE:["2015-01-01" TO "2015-01-06"]}
#'   \item{Filter for office number between 0 and 10: OFFNUM:[0 TO 10]}
#'   \item{Filter for branches in Oregon with type 11: STNAME:Oregon AND SERVTYPE:11}
#' }
#' Example fields: \code{NAME,UNINUM,SERVTYPE,RUNDATE,CITY,STNAME,ZIP,COUNTY}
#' Example sort_by: \code{NAME}
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
#'   x <- fdic_sod$new()
#'   x$get_available_fields()
#' }
fdic_sod <- R6::R6Class("fdic_sod",
  inherit = fdic_base,
  public = list(
    #' @description
    #' Initialization Method
    #' @returns an object of type fdic_sod
    initialize = function() {
      super$initialize()
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
                       format = private$format,
                       download = private$download,
                       filename = private$filename
                     )
      )
    }
  ),
  private = list(
    yaml_file = "sod_properties.yaml",
    query_path = "/api/locations"
  )
)
