
# read data ---------------------------------------------------------------


pl <- read.csv("data/simfin_comparables_2017_2020_Q.csv")[, -1]
pl <- read.csv("data/simfin_customers_2017_2020_Q.csv")[, -1]


# summarize ---------------------------------------------------------------


non_group_cols <-
  c(
    "period",
    "year",
    "tid",
    "uid",
    "parent_tid",
    "display_level",
    "check_possible",
    "acc_value"
  )

pl_acc_names <- 
  c(
    "Revenue",
    "Cost of Revenue", 
    "Gross Profit", 
    "Operating Expenses", 
    "Operating Income (Loss)", 
    "Selling, General & Administrative", 
    "Non-Operating Income (Loss)", 
    "Net Income"
  )

pl %<>% 
  dplyr::filter(type_statement == "pl") %>% 
  dplyr::filter(acc_name %in% pl_acc_names) %>% 
  dplyr::group_by_at(dplyr::vars(-tidyselect::all_of(non_group_cols))) %>%
  dplyr::summarize_at(dplyr::vars("acc_value"), ~ sum(., na.rm = TRUE)) %>% 
  dplyr::ungroup()


# calculate growth --------------------------------------------------------


pl %<>% 
  dplyr::group_by_at(
    dplyr::vars("company_name", "company_sector", "acc_name")
    ) %>% 
  dplyr::mutate(
    "q_growth" = (acc_value - lag(acc_value)) / lag(acc_value),
    "a_growth" = (acc_value - lag(acc_value, 4)) / lag(acc_value, 4)
    )


# plot --------------------------------------------------------------------


companies_that_have_2020_data <- 
  pl %>% 
  dplyr::ungroup() %>% 
  dplyr::filter(ref_date == "2020-03-31") %>% 
  dplyr::pull("company_name")

## quarterly growth
pl %>% 
  dplyr::filter(company_name %in% companies_that_have_2020_data) %>% 
  dplyr::mutate(ref_date = as.Date(ref_date)) %>% 
  dplyr::filter(ref_date <= as.Date("2020-03-31")) %>% 
  ggplot2::ggplot() +
  ggplot2::geom_line(
    ggplot2::aes(
      x = ref_date, 
      y = q_growth, 
      group = company_name, 
      color = company_name
      )) +
  ggplot2::facet_wrap(. ~ acc_name, scales = "free")
