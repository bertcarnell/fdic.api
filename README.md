# fdic.api
An R package to communicate with the FDIC web API

[![R-CMD-CHECK](https://github.com/bertcarnell/fdic.api/actions/workflows/r-cmd-check.yml/badge.svg)](https://github.com/bertcarnell/fdic.api/actions/workflows/r-cmd-check.yml)
[![Coverage status](https://codecov.io/gh/bertcarnell/fdic.api/branch/master/graph/badge.svg)](https://codecov.io/github/bertcarnell/fdic.api?branch=master)

## Installation

You can install the development version of `fdic.api` from github
with:

``` r
if (!require(devtools)) install.packages("devtools")
devtools::install_github("bertcarnell/fdic.api")
```

## API endpoints

See [here](https://banks.data.fdic.gov/docs/) for FDIC API Documentation

Implemented Endpoints

- Institutions
- Locations
- History
- Financials
- Summary
- Failures
- SOD (Summary of Deposits)
- Demographics

## Quick Start

### Obtain an API Key for the FDIC site

```r
api_key <- "ABCDEFGHIJKLMNOP"
```

### Explore the API

``` r
fdic_loc_con <- fdic_locations$new(api_key)
fdic_loc_con$get_available_fields()
fdic_loc_con$get_available_field_description("CBSA")
```

### Set API parameters

``` r
fdic_loc_con$setLimit(100)
fdic_loc_con$setFilters("STNAME:Texas")
```

### Get Results

``` r
results <- fdic_loc_con$query_fdic()
head(results)
```

## Running Tests in Development

In order to run the tests using `testthat` you must either

- use an environment variable containing the API key: `FDIC_API_KEY`
- create a file called `setup.R` with the API key:
    - `api_key_secret <- "ABCDEFGHIJKLM"`
    
