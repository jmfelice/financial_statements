
url <- paste0("https://www.sec.gov/Archives/edgar/daily-index/2020/QTR2/")

daily_filings <- httr::GET(url)
jsonlite::fromJSON(daily_filings)
content(daily_filings)
