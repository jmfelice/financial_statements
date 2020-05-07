# company listing ---------------------------------------------------------


## all publicly traded companies
## will not work with VPN
all_companies  <- TTR::stockSymbols()

## generate all simFin companies
simfin_company_listing <- simfinR::simfinR_get_available_companies(api_key)

## largest customers
largest_cust <- 
  c(
    "Covidien",
    "Osram",
    "Medtronic", 
    "Stryker", 
    "Cook", 
    # "Putnam", 
    "Intuitive", 
    "Viant",
    "Coravin", 
    "Jabil", 
    "3M", 
    "Cayenne", 
    "Biomerics", 
    "Michrom", 
    # "Merit",
    "Lacey", 
    "Norwood"
  )

customer_companies <- 
  dplyr::filter(
    all_companies, 
    stringr::str_detect(Name, paste0(largest_cust, collapse = "|"))
    )

customer_companies <- 
  simfin_company_listing %>% 
  dplyr::filter(ticker %in% customer_companies$Symbol)


# pull financial data -----------------------------------------------------


## generate financial data for comparable companies between 2017 and 2020
## on a quarterly basis
fin_data <-
  simfinR::simfinR_get_fin_statements(
    customer_companies$simId,
    api_key,
    periods = paste0("Q", 1:4),
    years = 2017:2020
  )


# save data ---------------------------------------------------------------


utils::write.csv(fin_data, "data/simfin_customers_2017_2020_Q.csv")