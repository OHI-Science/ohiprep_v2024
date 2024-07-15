# function for cleaning the fao data in the format available from the Statistical Query Panel (2024)
#' fao_query_data_tidy
#' assumes data has had janitor::clean_names applied to it 
#' @author Anna Ramji (adapted from arobinson 2023 fao_online_portal_clean.R)
#' @param fao FAO dataset downloaded from Statistical Query Panel
#' @param initial_data_year initial year available in the dataset
#' @param last_data_year latest year available in the dataset
#' @param sub_N value to substitute for rows that have the flag of N
#'
#' @return returns a cleaned version of the fao data
fao_query_data_tidy <- function(fao, initial_data_year, last_data_year, sub_N = 0.1) {
  
  fao <- fao %>% 
    # ensuring column names are lower_snake_case
    janitor::clean_names() %>% 
    # adding row_id for joining subsetted pivoted data
    mutate(row_id = row_number()) 
  
  
  # N is a flag used by FAO to indicate not significant (negligible)
  # we replace this with 0.1, both for tonnes and value in thousands
  
  # pivot all of the year/value columns 
  fao_values <- fao %>% 
    # alternatively, could say -c(starts_with("_flag"))
    dplyr::select(-c(paste0("x", initial_data_year:last_data_year, "_flag"))) %>% 
    pivot_longer(cols = paste0("x", initial_data_year:last_data_year),
                 names_to = "year",
                 values_to = "value") %>% 
    # clean up year column (currently in the form of xYYYY)
    mutate(year = str_remove_all(year, pattern = "x"))
  
  
  # pivot all of the flag columns  
  fao_flags <- fao %>% 
    select(-c(paste0("x", initial_data_year:last_data_year))) %>% 
    pivot_longer(cols = ends_with("_flag"),
                 names_to = "flag_year",
                 values_to = "flag") %>% 
    # make year column using the year label from the flags for joining
    mutate(year = str_remove(flag_year, "_flag")) %>% 
    # clean up year column (currently in the form of xYYYY)
    mutate(year = str_remove_all(year, pattern = "x")) %>% 
  select(year, flag, row_id) 
  
  # combine flag and row id 
  fao_new <- fao_values %>%
    left_join(fao_flags, by = c("row_id", "year"))
  
  # replace 
  fao_new <- fao_new %>% 
    mutate(value = case_when(
      (str_detect(flag, "N") & value == 0) ~ sub_N,
      TRUE ~ value)) %>% # replace values that are 0 and have the flag N with sub_N
    select(-c(row_id, flag))
  
  
  return(fao_new)
  
}