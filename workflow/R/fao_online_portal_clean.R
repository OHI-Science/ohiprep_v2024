#function for cleaning the fao data in the format available from the Statistical Query Panel (2023)

#' fao_online_portal_clean
#'
#' @param fao FAO dataset downloaded from Statistical Query Panel
#' @param initial_data_year initial year available in the dataset
#' @param last_data_year latest year available in the dataset
#' @param sub_N value to substitute for rows that have the flaf of N
#'
#' @return returns a cleaned version of the fao data
fao_online_portal_clean <- function(fao,initial_data_year, last_data_year, sub_N = 0.1) {

fao <- fao %>% 
  mutate(row_id = row_number())

#N is a flag used by FAO to indicate not significant (negligible)
#we replace this with 0.1, both for tonnes and value in thousands

#pivot all of the year/value columns 
fao_values <- fao %>% 
  dplyr::select(-c(paste(initial_data_year:last_data_year, "Flag"))) %>% 
  pivot_longer(cols = paste0(initial_data_year:last_data_year),
               names_to = "year",
               values_to = "value")

#pivot all of the flag columns   
fao_flags <- fao %>%
  select(-paste0(initial_data_year:last_data_year)) %>% 
  pivot_longer(cols = paste(initial_data_year:last_data_year, "Flag"),
               names_to = "flag_year",
               values_to = "flag") %>% 
  mutate(year = str_remove(flag_year, " Flag")) %>% 
  select(year, flag, row_id) 

#combine flag and row id 
fao_new <- fao_values %>%
  left_join(fao_flags, by = c("row_id", "year"))

#replace 
fao_new <- fao_new%>% 
  mutate(value = case_when((str_detect(flag, "N") & value == 0) ~ sub_N,
                           TRUE ~value)) %>% #replace values that are 0 and have the flag N with sub_N
  select(-c(row_id, flag))


return(fao_new)
}