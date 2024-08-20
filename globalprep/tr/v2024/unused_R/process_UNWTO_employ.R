# process UNWTO number employed in tourism data
file_path_unwto <- file.path(dir_M, "git-annex", "globalprep", "_raw_data", "UNWTO", paste0("d", version_year), "unwto-employment-data.xlsx")
unwto_employment <- readxl::read_xlsx(file_path_unwto)

unwto_clean <- unwto_employment[, c(4, 6, 11:(ncol(unwto_employment) - 1))]

names(unwto_clean) <- c("country", "metric", as.character(unwto_clean[2, 3:ncol(unwto_clean)]))

unwto_clean <- unwto_clean[3:nrow(unwto_clean), ] %>% 
  fill(country, .direction = "down") %>% 
  filter(metric == "Total") %>% 
  pivot_longer(cols = 3:ncol(unwto_clean), names_to = "year",
               values_to = "tourism_jobs_ct") %>% 
  mutate(tourism_jobs_ct = na_if(tourism_jobs_ct, ".."),
         country = str_to_title(country),
         tourism_jobs_ct = round(as.numeric(tourism_jobs_ct) * 1000)) %>% 
  select(-metric)

# clean some names to match OHI region names (add more here if discovered below)
# the ones below are not relevant anymore since name_2_rgn was updated with synonyms
# unwto_clean_fix <- unwto_clean %>%
#   mutate(
#     country = case_when(
#       country %in% c("Antigua And Barbuda") ~ "Antigua and Barbuda",
#       country %in% c("Bosnia And Herzegovina") ~ "Bosnia and Herzegovina",
#       country %in% c("Congo, Democratic Republic Of The") ~ "Democratic Republic of the Congo",
#       country %in% c("Cote D´Ivoire") ~ "Ivory Coast",
#       country %in% c("Hong Kong, China") ~ "Hong Kong",
#       country %in% c("Iran, Islamic Republic Of") ~ "Iran",
#       country %in% c("Korea, Democratic People´S Republic Of") ~ "North Korea",
#       country %in% c("Korea, Republic Of") ~ "South Korea",
#       country %in% c("Macao, China") ~ "Macao",
#       country %in% c("Micronesia, Federated States Of") ~ "Micronesia",
#       country %in% c("Saint Kitts And Nevis") ~ "Saint Kitts and Nevis",
#       country %in% c("Saint Vincent And The Grenadines") ~ "Saint Vincent and the Grenadines",
#       country %in% c("Sao Tome And Principe") ~ "Sao Tome and Principe",
#       country %in% c("Serbia And Montenegro") ~ "Montenegro",
#       country %in% c("Sint Maarten (Dutch Part)") ~ "Sint Maarten",
#       country %in% c("Taiwan Province Of China") ~ "Taiwan",
#       country %in% c("Tanzania, United Republic Of") ~ "Tanzania",
#       country %in% c("Trinidad And Tobago") ~ "Trinidad and Tobago",
#       country %in% c("Turks And Caicos Islands") ~ "Turks and Caicos Islands",
#       country %in% c("United States Of America") ~ "United States",
#       country %in% c("Venezuela, Bolivarian Republic Of") ~ "Venezuela",
#       TRUE ~ country))

# get UNWTO data to have OHI region names
unwto_clean_names <- name_2_rgn(df_in = unwto_clean, # change to unwto_clean_fix if you need to adjust any names
                                fld_name = 'country',
                                flds_unique = c('year'))
# v2023 (prior to updating name_2_rgn)
# These data were removed for not having any match in the lookup tables:
# 
#                    Antigua And Barbuda (added above)        Bolivia, Plurinational State Of (landlocked)
#                                      1                                      1 
#                 Bosnia And Herzegovina (added above)     Congo, Democratic Republic Of The (added above)
#                                      1                                      1 
#                          Cote D´Ivoire (added above)              Czech Republic (Czechia) (landlocked)
#                                      1                                      1 
#                               Eswatini (landlocked)                      Hong Kong, China (added above)
#                                      1                                      1 
#              Iran, Islamic Republic Of (added above)  Korea, Democratic People´S Republic Of (added above)
#                                      1                                      1 
#                     Korea, Republic Of (added above)      Lao People´S Democratic Republic (landlocked)
#                                      1                                      1 
#                           Macao, China (added above)       Micronesia, Federated States Of (added above)
#                                      1                                      1 
#                   Moldova, Republic Of (landlocked)                       North Macedonia (landlocked)
#                                      1                                      1 
#                  Saint Kitts And Nevis (added above)      Saint Vincent And The Grenadines (added above)
#                                      1                                      1 
#                  Sao Tome And Principe (added above)                 Serbia And Montenegro (added above)
#                                      1                                      1 
#              Sint Maarten (Dutch Part) (added above)                     State Of Palestine (not included)
#                                      1                                      1 
#               Taiwan Province Of China (added above)          Tanzania, United Republic Of (added above)
#                                      1                                      1 
#                    Trinidad And Tobago (added above)              Turks And Caicos Islands (added above)
#                                      1                                      1 
#               United States Of America (added above)     Venezuela, Bolivarian Republic Of (added above)
#                                      1                                      1 
# DUPLICATES found. Consider using collapse2rgn to collapse duplicates (function in progress).
# 
# # A tibble: 10 × 1
#    country                     
#    <chr>                       
#  1 China                       
#  2 Guadeloupe                  
#  3 Guam                        
#  4 Hong Kong                   
#  5 Macao                       
#  6 Martinique                  
#  7 Montenegro                  
#  8 Northern Mariana Islands    
#  9 Puerto Rico                 
# 10 United States Virgin Islands

# v2023 (after updating name_2_rgn)

# fix duplicates
unwto_dupe_fix <- unwto_clean_names %>%
  group_by(rgn_id, year) %>%
  summarize(sum_fix = ifelse(all(is.na(tourism_jobs_ct)), NA, sum(tourism_jobs_ct, na.rm = TRUE))) %>%
  mutate(method = ifelse(!is.na(sum_fix), "UNWTO", NA)) %>%
  mutate(gapfilled = NA)