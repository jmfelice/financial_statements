#' Find Cadence Inc. Comparable Company List
#'
#' @param public_company_list data.frame that shows the public companies
#'  and associated stock symbols, as well as industries and sectoes.  This 
#'  table can be obtained from the TTR package.  Use: TTR::stockSymbols().
#'
#' @return data.frame that shows only the companies comparable to Cadence Inc. 
#'  in size and industry.
#'  
#' @export
#'
find_cadence_comparable_companies <- function(public_company_list) {
  
  ## define comparable industries
  industries <-
    c(
      "Containers/Packaging",
      "Industrial Machinery/Components",
      "Metal Fabrications",
      "Auto Parts:O.E.M.",
      "Industrial Specialties",
      "Containers/Packaging",
      "Industrial Specialties"
    ) 
  
  public_company_list %>% 
    
    ## look at only the companies in the above industries
    dplyr::filter_at(dplyr::vars("Industry"), ~ . %in% industries) %>% 
    
    ## select only companies with millions in market cap, not billions
    dplyr::filter_at(
      dplyr::vars("MarketCap"), 
      ~ stringr::str_detect(., "M")
      ) %>%
    
    ## create numeric market cap
    dplyr::mutate_at(
      dplyr::vars("MarketCap"), 
      ~ as.numeric(stringr::str_remove_all(., "[$]|M"))
    ) %>%
    
    ## choose only similarly sized companies
    dplyr::filter_at(
      dplyr::vars("MarketCap"), 
      ~ (dplyr::between(., 100, 750))
      )
  
}