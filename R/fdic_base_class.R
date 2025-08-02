# Copyright 2019 Robert Carnell

#' @title FDIC API Query Base Class
#' 
#' @description A base class, from which specific queries are derived.  This class
#' can be used directly for a user-derived query
#' 
#' @section Params:
#' \describe{
#'   \item{\code{path}}{The path off of the base FDIC API URL that directs the type of query}
#'   \item{\code{query}}{A list of query elements passed to the web API}
#' }
#' 
#' @section Usage:
#' \describe{
#'   \item{\code{fdic_base$fdic_api(path, query)}}{Query using the FDIC API}
#' }
#' 
#' @importFrom R6 R6Class
#' @importFrom yaml read_yaml
#' @importFrom httr modify_url GET http_type content
#' @importFrom jsonlite  fromJSON
#' @importFrom assertthat assert_that
#' @importFrom curl has_internet
#' @docType class
#' @keywords fdic financial bank
#' @references \url{https://banks.data.fdic.gov/docs/}
#' @export
#' 
#' @examples
#' /dontrun {
#'   x <- fdic_base$new(api_key_secret)
#'   resp <- x$fdic_api("/api/institutions", 
#'     list(filters = "STALP:OH AND ACTIVE:1",
#'       fields = "ZIP,OFFDOM,CITY,COUNTY,STNAME,STALP,NAME,ACTIVE,CERT,CBSA,ASSET",
#'       sort_by = "ZIP",
#'       sort_order = "DESC",
#'       limit = 10,
#'       offset = 0,
#'       format = "json",
#'       download = "false",
#'       filename = "data_file"))
#' }
fdic_base <- R6::R6Class("fdic_base",
  public = list(
    #' @description
    #' Initialization Method
    #' @param apikey API key from api.fdic.gov
    #' @returns an object of type fdic_base 
    initialize = function(api_key) {
      suppressWarnings(private$yamlbase <- self$parse_yaml(private$yamlbasefile))
      private$api_key <- api_key
    },
    #' @description
    #' Parse the swagger YAML file
    #' @param filename the filename of the swagger document
    #' @returns YAML file text
    parse_yaml = function(filename) {
      tempurl <- httr::modify_url(url = private$fdicurl, path = paste0("banks/docs/", filename))
      # incomplete final line is an expected warning
      suppressWarnings(yaml_result <- yaml::read_yaml(tempurl))
      return(yaml_result)
    },
    #' @description
    #' get the available return fields from the swagger document
    #' @returns a vector of field names
    get_available_fields = function()
    {
      if (length(private$yamlderived) > 0)
        return(names(private$yamlderived$properties$data$properties))
      else
        stop("fields are not initialized")
    },
    #' @description
    #' Get metadata about a field
    #' @param field the field name
    #' @returns field information
    get_available_field_description = function(field)
    {
      if (length(private$yamlderived) > 0)
      {
        if (exists(field, where = private$yamlderived$properties$data$properties))
        {
          return(private$yamlderived$properties$data$properties[[field]])
        } else {
          stop(paste0(field, " not found"))
        }
      } else
      {
        stop("fields are not initialized")
      }
    },
    #' @description
    #' the FDIC API
    #' @param path the url
    #' @param query the query string
    #' @returns the JSON results
    fdic_api = function(path, query) 
    {
      query <- c(api_key = private$api_key, query)
      myurl <- httr::modify_url(private$fdicurl, path = path, query = query)
      resp <- httr::GET(myurl)

      if (httr::http_type(resp) != "application/json") {
        stop("API did not return json", call. = FALSE)
      }

      ret <- jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = TRUE)
      return(list(query = myurl, meta = ret$meta, totals = ret$totals, data = ret$data$data))
    },
    #' @description
    #' Set the filter for the API
    #' @param filters the text filter specification
    #' @returns NULL
    setFilters = function(filters) {private$filters = filters},
    #' @description
    #' set the fields to be returned
    #' @param fields a vector of fields to return
    #' @returns NULL
    setFields = function(fields){
      assertthat::assert_that(all(fields %in% self$get_available_fields()))
      private$fields <- fields
    },
    #' @description
    #' Set the field to sort by
    #' @param sort_by the field to sort by
    #' @returns NULL
    setSort_by = function(sort_by) {private$sort_by = sort_by},
    #' @description
    #' set the sort order
    #' @param sort_order the sort order - \code{ASC} or \code{DESC}
    #' @returns NULL
    setSort_order = function(sort_order) {
      if (length(sort_order) == 1 && sort_order %in% c("ASC", "DESC"))
      {
        private$sort_order = sort_order
      } else
      {
        stop("sort_order must be ASC or DESC")
      }
    },
    #' @description
    #' set the row limit of the result
    #' @param limit the row limit
    #' @returns NULL
    setLimit = function(limit) {
      if (length(limit) == 1 && limit > 0 && limit <= 10000)
      {
        private$limit = limit
      } else
      {
        stop("limit must be between 1 and 10000")
      }
    },
    #' @description
    #' set the offset
    #' @param offset the offset
    #' @returns NULL
    setOffset = function(offset) {private$offset = offset}
  ),
  private = list(
    yamlbasefile = "swagger.yaml",
    yamlbase = character(),
    yamlderived = character(),
    fdicurl = "https://api.fdic.gov",
    filters = "",
    fields = "",
    sort_by = "",
    sort_order = "DESC",
    limit = 10000,
    offset = 0,
    format = "json",
    download = "false",
    filename = "data_file",
    api_key = ""
  )
)
