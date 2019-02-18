# Copyright 2019 Rob Carnell

#' Get the Deposits at each Branch
#'
#' @param fdic_cert_num The FDIC Cert number of the bank
#' @param year The year of the desired data \code{(>= 1994)}
#'
#' @return a data.frame of the results
#' @export
#' 
#' @importFrom assertthat assert_that
#' @importFrom rvest html_form set_values submit_form html_session
#' @importFrom xml2 read_html xml_find_all xml_children xml_text xml_attr xml_has_attr
#' @importFrom magrittr %>% extract extract2
#'
#' @examples
#' if (curl::has_internet()) {
#'   get_branch_deposits(628, 2018)
#' }
get_branch_deposits <- function(fdic_cert_num, year)
{
  assertthat::assert_that(year >= 1994, msg = "1994 is the earliest year available")
  mysession <- .get_fdic_summary_of_deposits()
  myform <- rvest::html_form(mysession)
  assertthat::assert_that(length(myform) == 2, 
                          msg = "Unexpected FDIC web results")
  # the first form is a search form
  myform <- myform[[2]]
  assertthat::assert_that(myform$name == "sodInstBranchForm", 
                          msg = "Unexpected FDIC web results")
  myform <- rvest::set_values(myform, 
                              sInfoAsOf = year,
                              radioSearch = "INST",
                              iINSTName = "",
                              iBHCName = "",
                              selectNo = "Cert",
                              iNumber = fdic_cert_num, 
                              iBHCID = "",
                              sState = "all",
                              sMSA = "", 
                              sZipcode = "")
  
  # fix form types that had a NULL type
  myform$fields$sInfoAsOf$type <- "text"
  myform$fields$selectNo$type <- "text"
  myform$fields$sState$type <- "text"
  myform$fields$sMSA$type <- "text"
  myform$fields$btnFind$type <- "submit"
  
  myresult <- suppressMessages(rvest::submit_form(mysession, myform))
  myhtml <- xml2::read_html(myresult)
  
  fdic_data <- .parse_fdic_deposit_results(myhtml)
  return(fdic_data)
}

.get_fdic_summary_of_deposits <- function()
{
  rvest::html_session("https://www5.fdic.gov/sod/sodInstBranch.asp?barItem=1")
}

.parse_fdic_deposit_results <- function(myhtml)
{
  header_search_str <- "headers"
  tab1 <- myhtml %>% xml2::xml_find_all("//body/table")
  assertthat::assert_that(length(tab1) >= 3, 
                          msg = "Not enough tables present in the html results")
  tab <- tab1 %>% magrittr::extract(3) %>% xml2::xml_children()
  assertthat::assert_that(length(tab) > 0, 
                          msg = "html tables not parsed correctly")
  temp_list <- vector("list", length(tab))
  counter <- 1
  for (i in 1:length(tab))
  {
    temp <- tab %>% magrittr::extract(i) %>% xml2::xml_children()
    if (length(temp) > 1)
    {
      if (xml2::xml_has_attr(temp[1], header_search_str))
      {
        # if temp is a state, keep the state
        if (xml2::xml_attr(temp[1], header_search_str) == "hdr_state")
        {
          temp_state <- xml2::xml_text(temp[1], trim = TRUE)
        }
        # if temp is a county, keep the county
        if (xml2::xml_attr(temp[1], header_search_str) == "hdr_county")
        {
          temp_county <- xml2::xml_text(temp[1], trim = TRUE)
        }
        # if it is an address, grab the elements
        if (xml2::xml_attr(temp[1], header_search_str) == "hdr_address")
        {
          # a consolidated branch is marked with a "C"
          if (grepl("^C ", xml2::xml_text(temp[1], trim = TRUE)))
          {
            next
          }
          assertthat::assert_that(length(temp) >= 7, 
                                  msg = "Address row does not have enough entries")
          temp_list[[counter]] <- list(
            state = temp_state,
            county = temp_county,
            address = xml2::xml_text(temp[1], trim = TRUE),
            city = xml2::xml_text(temp[2], trim = TRUE),
            zip = xml2::xml_text(temp[3], trim = TRUE),
            brsertyp = xml2::xml_text(temp[4], trim = TRUE),
            brnum = xml2::xml_text(temp[5], trim = TRUE),
            uninumbr = xml2::xml_text(temp[6], trim = TRUE),
            deposit = gsub(",", "", xml2::xml_text(temp[7], trim = TRUE))
          )
          counter <- counter + 1
        }
      }
    }
  }
  fdic_data <- as.data.frame(t(sapply(temp_list[1:(counter - 1)], 
                                      function(x) unlist(x))), 
                             stringsAsFactors = FALSE)
  class(fdic_data$zip) <- "integer"
  class(fdic_data$brsertyp) <- "integer"
  class(fdic_data$brnum) <- "integer"
  class(fdic_data$uninumbr) <- "integer"
  class(fdic_data$deposit) <- "numeric"
  
  return(fdic_data)  
}
