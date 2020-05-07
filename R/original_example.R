library(httr)
library(jsonlite)


ticker <- "AAPL"

url <-
  paste0(
    "https://simfin.com/api/v1/info/find-id/ticker/",
    ticker,
    "?api-key=",
    api_key
    )

get_data  <- httr::GET(url)
data      <- fromJSON(content(get_data, "text"),flatten = TRUE)
simfinID  <- data[,c("simId")]
statement <- "pl"
ptype     <- "TTM"
fyear     <- ""

url <-
  paste0(
    "https://simfin.com/api/v1/companies/id/",
    simfinID,
    "/statements/standardised",
    "?api-key=",
    api_key,
    "&stype=",
    statement,
    "&ptype=",
    ptype,
    "&fyear=",
    fyear
    )

get_data <- GET(url)
data     <- fromJSON(content(get_data, "text"),flatten = TRUE)
data

