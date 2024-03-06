


process_TTDI_emp <- function(df) {
  
  names(df)[1:9] <- as.character(df[1, 1:9])
  
  ttdi_emp <- df %>%
    filter(Title %in% c("T&T industry Share of Employment, % of total employment",
                        "T&T industry Employment, 1,000 jobs"),
           Attribute == "Value") %>% 
    select(Title, Edition, Albania:Zambia) %>% 
    # currently Zambia is the last country column - this may need to change in the future if countries are added (e.g. Zimbabwe)
    pivot_longer(cols = Albania:Zambia, names_to = "country",
                 values_to = "value") %>% 
    mutate(value = as.numeric(value)) %>% 
    pivot_wider(names_from = Title, values_from = value) %>% 
    rename("jobs_pct" = "T&T industry Share of Employment, % of total employment",
           "jobs_ct" = "T&T industry Employment, 1,000 jobs",
           "year" = "Edition") %>% 
    mutate(jobs_ct = round(jobs_ct * 1000))
  
  return(ttdi_emp)

}
