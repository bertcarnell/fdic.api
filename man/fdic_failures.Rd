% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fdic_failures_class.R
\docType{class}
\name{fdic_failures}
\alias{fdic_failures}
\title{FDIC API Query for Failure Information}
\format{An object of class \code{R6ClassGenerator} of length 24.}
\usage{
fdic_failures
}
\description{
A class to create Failure queries to the FDIC API.  Derived
from class \code{fdic_base}.
}
\details{
Example filters
\itemize{
  \item{Filter by Location:  CITYST:"MEMPHIS, TN"}
  \item{Filter by institution fail year range: FAILYR:["2015" TO "2016"]}
}
Example fields: \code{NAME,CERT,FIN,CITYST,FAILDATE,SAVR,RESTYPE,RESTYPE1,QBFDEP,QBFASSET,COST}
Example sort_by: \code{FAILDATE}
}
\section{Total_Params}{

\describe{
  \item{\code{total_fields}}{Fields to sum up (in a totals response object). Only numeric columns are valid.}
  \item{\code{subtotal_by}}{The field by which data will be subtotaled (in totals response object). Only categorical values should be used.}
}
}

\section{Total_Usage}{

\describe{
  \item{\code{fdic_failures$setTotal_fields(total_fields)}}{}
  \item{\code{fdic_failures$setSubtotal_by(subtotal_by)}}{}
}
}

\section{Params}{

\describe{
  \item{\code{field}}{one of the available query fields returned by \code{get_available_fields}}
  \item{\code{filters}}{the filter for the bank search.}
  \item{\code{fields}}{Comma delimited list of fields to search}
  \item{\code{sort_by}}{Field name by which to sort returned data}
  \item{\code{sort_order}}{Indicator if ascending (ASC) or descending (DESC)}
  \item{\code{limit}}{The number of records to return. Default is 10 and maximum is 10,000.}
  \item{\code{offset}}{The offset of page to return}
}
}

\section{Aggregate_Params}{

\describe{
  \item{\code{agg_by}}{The field(s) by which data will be aggregated. Valid values are 'YEAR' or 'YEAR,STNAME'.}
  \item{\code{agg_term_fields}}{The field(s) for which aggregations will be counted for each unique term.}
  \item{\code{agg_sum_fields}}{The field(s) for which aggregations will be summed or aggregated.}
  \item{\code{agg_limit}}{The limit on how many aggregated results will be displayed}
}
}

\section{Usage}{

\describe{
  \item{\code{fdic_base$get_available_fields()}}{Get the fields available for queries}
  \item{\code{fdic_base$get_available_field_description(field)}}{Get the description of a field}
  \item{\code{fdic_base$setFilters(filters)}}{}
  \item{\code{fdic_base$setFields(fields)}}{}
  \item{\code{fdic_base$setSort_by(sort_by)}}{}
  \item{\code{fdic_base$setSort_order(sort_order)}}{}
  \item{\code{fdic_base$setLimit(limit)}}{}
  \item{\code{fdic_base$setOffset(offset)}}{}
}
}

\section{Aggregate_Usage}{

\describe{
  \item{\code{fdic_locations$setAgg_by(agg_by)}}{}
  \item{\code{fdic_locations$setAgg_term_fields(agg_term_fields)}}{}
  \item{\code{fdic_locations$setAgg_sum_fields(agg_sum_fields)}}{}
  \item{\code{fdic_locations$setAgg_limit(agg_limit)}}{}
}
}

\examples{
if (curl::has_internet()) {
  x <- fdic_failures$new()
  x$get_available_fields()
  x$get_available_field_description("FAILDATE")
}
}
\references{
\url{https://banks.data.fdic.gov/docs/}
}
\keyword{bank}
\keyword{fdic}
\keyword{financial}
