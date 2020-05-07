# company listing ---------------------------------------------------------


## all publicly traded companies
## will not work with VPN
all_companies  <- TTR::stockSymbols()

## generate all simFin companies
simfin_company_listing <- simfinR::simfinR_get_available_companies(api_key)

## comparable companies
comp_companies <- find_cadence_comparable_companies(all_companies)
comp_companies <- 
  simfin_company_listing %>% 
  dplyr::filter(ticker %in% comp_companies$Symbol)


# pull financial data -----------------------------------------------------


## generate financial data for comparable companies between 2017 and 2020
## on a quarterly basis
fin_data <-
  simfinR::simfinR_get_fin_statements(
    comp_companies$simId,
    api_key,
    periods = paste0("Q", 1:4),
    years = 2017:2020
  )


# save data ---------------------------------------------------------------


utils::write.csv(fin_data, "data/simfin_comparables_2017_2020_Q.csv")