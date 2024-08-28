### ohiprep/src/R/fao_fxn.R
### Function(s) to help clean and manipulate FAO data.
###
### Provenance:
###   Apr2015: created by Casey O'Hara (oharac)


# fao_clean_data <- function(m, sub_0_0 = 0.1) {
# ### Swaps out FAO-specific codes for analysis:
# ### * FAO_commodities (Natural Products goal)
# ###
# ### Note separate calls to mutate() may not be necessary, but ensures proper sequence of flag-replacing, just in case...
# ###
#   
#   m1 <- m %>%
#     mutate(  
#       value = str_replace(value, fixed('F '), ''),
#       value = str_replace(value, fixed(' F'), ''),
#         ### FAO denotes with F when they have estimated the value using best available data,
#         ###   sometimes comes at start (commodities), sometimes at end (mariculture)...?
#       value = ifelse(value == '...', NA, value),
#         ### FAO's code for NA
#       value = str_replace(value, fixed('0 0'), sub_0_0),  
#         ### FAO denotes something as '0 0' when it is > 0 but < 1/2 of a unit. 
#         ### Replace with lowdata_value.
#       value = str_replace(value, fixed(  '-'), '0'),  
#         ### FAO's code for true 0
#       value = ifelse(value =='', NA, value)) %>%
#     mutate(
#       value = as.numeric(as.character(value)),
#       year  = as.integer(as.character(year)))       # search in R_inferno.pdf for "shame on you"
#   
#   return(m1)
# }

fao_clean_data_new <- function(m, sub_N = 0.1) {
  ### Swaps out FAO-specific codes for analysis:
  ### * FAO_commodities (Natural Products goal)
  ###
  ### Note separate calls to mutate() may not be necessary, but ensures proper sequence of flag-replacing, just in case...
  ###
  
  m1 <- m %>%
    mutate(  
      # Remove "E" from values (E = Estimate) ----
      value = str_replace(value, fixed('E '), ''), 
      value = str_replace(value, fixed(' E'), ''),
      ### FAO denotes with E when they have estimated the value using best available data,
      ###   sometimes comes at start (commodities), sometimes at end (mariculture)...?
      # Remove "X" from values (X = value from "int  organization) (added in v2024)
      value = str_replace(value, fixed('X '), ''), 
      value = str_replace(value, fixed(' X'), ''),
      # Replace '...' (... = missing value) with NA ----
      #value = ifelse(value == '...', NA, value), # FAO's code for NA
      # value = ifelse(str_detect(value, pattern = "..."), NA, value),
      # value = case_when(str_detect(value, pattern = "...") ~ NA,
      #                   TRUE ~ value),
      value = case_when(str_detect(value, "0  ...") ~ NA,
                        TRUE ~ value),
      #value = str_replace(value, fixed(' N'), sub_N),
      # Replace N (N = not significant, < 0.5) with substitution
      value = case_when(str_detect(value, "0  N") ~ as.character(sub_N), # if 0 N, replace with sub_N
                        str_detect(value, " N") ~ str_remove(value, " N"), # if number precedes N, remove N
                        TRUE ~ value),
      ### FAO denotes something as 'N' when it is > 0 but < 1/2 of a unit. 
      ### Replace with lowdata_value.
      # Replace '-' with 0 ----
      value = str_replace(value, fixed('-'), '0'),  
      ### FAO's code for true 0
      # Replace missing values with NA ----
      value = ifelse(value == '', NA, value)) %>%
    # Coerce data types ----
    mutate(
      value = as.numeric(as.character(value)),
      year = as.integer(as.character(year)))       # search in R_inferno.pdf for "shame on you"
  
  return(m1)
}