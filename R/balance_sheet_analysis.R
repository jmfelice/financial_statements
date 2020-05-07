
# read data ---------------------------------------------------------------


bs <- read.csv("data/simfin_comparables_2017_2020_Q.csv")[, -1]
bs <- read.csv("data/simfin_customers_2017_2020_Q.csv")[, -1]


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

bs_acc_names <- 
  c(
    "Cash, Cash Equivalents & Short Term Investments", 
    "Accounts Receivable, Net", 
    "Inventories", 
    "Prepaid Expenses", 
    "Total Current Assets", 
    "Property, Plant & Equipment, Net", 
    "Goodwill", 
    "Total Noncurrent Assets", 
    "Total Assets", 
    "Accounts Payable", 
    "Total Current Liabilities", 
    "Total Noncurrent Liabilities", 
    "Total Liabilities", 
    "Total Equity"
  )

bs %<>% 
  dplyr::filter(type_statement == "bs") %>% 
  dplyr::filter(acc_name %in% bs_acc_names) %>% 
  dplyr::group_by_at(dplyr::vars(-tidyselect::all_of(non_group_cols))) %>%
  dplyr::summarize_at(dplyr::vars("acc_value"), ~ sum(., na.rm = TRUE)) %>% 
  dplyr::ungroup()


# calculate growth --------------------------------------------------------


## commonsize data - vertical
bs %<>% 
  dplyr::group_by_at(
    dplyr::vars("company_name", "company_sector", "ref_date")
  ) %>% 
  dplyr::mutate(
    "v_common" = acc_value / acc_value[acc_name == "Total Assets"]
  )

## rolling growth
bs %<>% 
  dplyr::group_by_at(
    dplyr::vars("company_name", "company_sector", "acc_name")
  ) %>% 
  dplyr::mutate(
    "q_growth" = (acc_value - lag(acc_value)) / lag(acc_value),
    "a_growth" = (acc_value - lag(acc_value, 4)) / lag(acc_value, 4), 
    "g_common" = (v_common - lag(v_common)) / lag(v_common)
    )


# plot --------------------------------------------------------------------


companies_that_have_2020_data <- 
  bs %>% 
  dplyr::ungroup() %>% 
  dplyr::filter(ref_date == "2020-03-31") %>% 
  dplyr::pull("company_name")

## filter out future periods
bs %<>%
  dplyr::mutate(ref_date = as.Date(ref_date)) %>% 
  dplyr::filter(ref_date <= as.Date("2020-03-31"))

## quarterly growth
bs %>% 
  dplyr::filter(company_name %in% companies_that_have_2020_data) %>% 
  ggplot2::ggplot() +
  ggplot2::geom_line(
    ggplot2::aes(
      x = ref_date, 
      y = g_common, 
      group = company_name, 
      color = company_name
      )
    ) +
  ggplot2::facet_wrap(. ~ acc_name, scales = "free")
