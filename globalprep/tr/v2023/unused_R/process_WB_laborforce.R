# v2023: THIS ENDED UP NOT BEING USED, BUT WAS LEFT HERE IN CASE CODE BECOMES RELEVANT IN THE FUTURE

# Process World Bank labor force data
file_path_wb <- file.path(dir_M, "git-annex", "globalprep", "_raw_data", "WorldBank", paste0("d", version_year), "API_SL", "API_SL.TLF.TOTL.IN_DS2_en_csv_v2_5608539.csv")
wb_labor_force <- read_csv(file_path_wb, skip = 4)

wb_clean <- wb_labor_force %>%
  select(country = `Country Name`, `1960`:`2022`)

wb_clean_long <- wb_clean %>%  
  pivot_longer(cols = -country, names_to = "year",
               values_to = "total_labor_force") %>% 
  mutate(country = str_to_title(country))

# clean some names to match OHI region names (add more here if discovered below)
# the ones below are not relevant anymore since name_2_rgn was updated with synonyms
# wb_clean_fix <- wb_clean_long %>%
#   mutate(
#     country = case_when(
#       country %in% c("Antigua And Barbuda") ~ "Antigua and Barbuda",
#       country %in% c("Bosnia And Herzegovina") ~ "Bosnia and Herzegovina",
#       country %in% c("Cote D'ivoire") ~ "Ivory Coast",
#       country %in% c("Hong Kong Sar, China") ~ "Hong Kong",
#       country %in% c("Macao Sar, China") ~ "Macao",
#       country %in% c("Sao Tome And Principe") ~ "Sao Tome and Principe",
#       country %in% c("Sint Maarten (Dutch Part)") ~ "Sint Maarten",
#       country %in% c("St. Kitts And Nevis") ~ "Saint Kitts and Nevis",
#       country %in% c("St. Vincent And The Grenadines") ~ "Saint Vincent and the Grenadines",
#       country %in% c("Trinidad And Tobago") ~ "Trinidad and Tobago",
#       country %in% c("Turks And Caicos Islands") ~ "Turks and Caicos Islands",
#       country %in% c("Venezuela, Rb") ~ "Venezuela",
#       country %in% c("Virgin Islands (U.s.)") ~ "Virgin Islands",
#       TRUE ~ country))

# get UNWTO data to have OHI region names
wb_clean_names <- name_2_rgn(df_in = wb_clean_long, # change to wb_clean_fix if you need to adjust any names
                                fld_name = 'country',
                                flds_unique = c('year'))

# v2023 (prior to updating name_2_rgn)
# These data were removed for not having any match in the lookup tables:
#   
#   Africa Eastern And Southern (not used)
# 1 
# Africa Western And Central (not used)
# 1 
# Antigua And Barbuda (added above)
# 1 
# Arab World (not used)
# 1 
# Bosnia And Herzegovina (added above)
# 1 
# Caribbean Small States (not used)
# 1 
# Central Europe And The Baltics (not used)
# 1 
# Channel Islands (needs to be split into the OHI regions - not done here)
# 1 
# Cote D'ivoire (added above)
#                                                    1 
#                           Early-Demographic Dividend (not used)
#                                                    1 
#                                  East Asia & Pacific (not used)
#                                                    1 
#          East Asia & Pacific (Excluding High Income) (not used)
#                                                    1 
#           East Asia & Pacific (Ida & Ibrd Countries) (not used)
#                                                    1 
#                                             Eswatini (landlocked)
#                                                    1 
#                                            Euro Area (not used)
#                                                    1 
#                                Europe & Central Asia (not used)
#                                                    1 
#        Europe & Central Asia (Excluding High Income) (not used)
#                                                    1 
#         Europe & Central Asia (Ida & Ibrd Countries) (not used)
#                                                    1 
#                                       European Union (not used)
#                                                    1 
#             Fragile And Conflict Affected Situations (not used)
#                                                    1 
#               Heavily Indebted Poor Countries (Hipc) (not used)
#                                                    1 
#                                          High Income (not used)
#                                                    1 
#                                 Hong Kong Sar, China (added above)
#                                                    1 
#                                            Ibrd Only (not used)
#                                                    1 
#                                     Ida & Ibrd Total (not used)
#                                                    1 
#                                            Ida Blend (not used)
#                                                    1 
#                                             Ida Only (not used)
#                                                    1 
#                                            Ida Total (not used)
#                                                    1 
#                                          Isle Of Man (not used)
#                                                    1 
#                                              Lao Pdr (landlocked)
#                                                    1 
#                            Late-Demographic Dividend (not used)
#                                                    1 
#                            Latin America & Caribbean (not used)
#                                                    1 
#    Latin America & Caribbean (Excluding High Income) (not used)
#                                                    1 
# Latin America & The Caribbean (Ida & Ibrd Countries) (not used)
#                                                    1 
#         Least Developed Countries: Un Classification (not used)
#                                                    1 
#                                  Low & Middle Income (not used)
#                                                    1 
#                                           Low Income (not used)
#                                                    1 
#                                  Lower Middle Income (not used)
#                                                    1 
#                                     Macao Sar, China (added above)
#                                                    1 
#                           Middle East & North Africa (not used)
#                                                    1 
#   Middle East & North Africa (Excluding High Income) (not used)
#                                                    1 
#    Middle East & North Africa (Ida & Ibrd Countries) (not used)
#                                                    1 
#                                        Middle Income (not used)
#                                                    1 
#                                        North America (not used)
#                                                    1 
#                                      North Macedonia (landlocked)
#                                                    1 
#                                       Not Classified (not used)
#                                                    1 
#                                         Oecd Members (not used)
#                                                    1 
#                                   Other Small States (not used)
#                                                    1 
#                          Pacific Island Small States (not used)
#                                                    1 
#                            Post-Demographic Dividend (not used)
#                                                    1 
#                             Pre-Demographic Dividend (not used)
#                                                    1 
#                                Sao Tome And Principe (added above)
#                                                    1 
#                            Sint Maarten (Dutch Part) (added above)
#                                                    1 
#                                         Small States (not used)
#                                                    1 
#                                           South Asia (not used)
#                                                    1 
#                              South Asia (Ida & Ibrd) (not used)
#                                                    1 
#                                  St. Kitts And Nevis (added above)
#                                                    1 
#                             St. Martin (French Part) (added above)
#                                                    1 
#                       St. Vincent And The Grenadines (added above)
#                                                    1 
#                                   Sub-Saharan Africa (not used)
#                                                    1 
#           Sub-Saharan Africa (Excluding High Income) (not used)
#                                                    1 
#            Sub-Saharan Africa (Ida & Ibrd Countries) (not used)
#                                                    1 
#                                  Trinidad And Tobago (added above)
#                                                    1 
#                             Turks And Caicos Islands (added above)
#                                                    1 
#                                  Upper Middle Income (not used)
#                                                    1 
#                                        Venezuela, Rb (added above)
#                                                    1 
#                                Virgin Islands (U.s.) (added above)
#                                                    1 
#                                   West Bank And Gaza (West Bank landlocked/not used)
#                                                    1 


# DUPLICATES found. Consider using collapse2rgn to collapse duplicates (function in progress).
# 
# # A tibble: 7 × 1
# country                 
# <chr>                   
#   1 China                   
# 2 Guam                    
# 3 Hong Kong               
# 4 Macao                   
# 5 Northern Mariana Islands
# 6 Puerto Rico             
# 7 Virgin Islands  


# v2023 (after updating name_2_rgn)
# These data were removed for not having any match in the lookup tables:
#   
#   africa eastern and southern 
# 1 
# africa western and central 
# 1 
# arab world 
# 1 
# caribbean small states 
# 1 
# central europe and the baltics 
# 1 
# channel islands (needs to be split into the OHI regions - not done here)
# 1 
# early-demographic dividend 
# 1 
# east asia & pacific 
# 1 
# east asia & pacific (excluding high income) 
# 1 
# east asia & pacific (ida & ibrd countries) 
# 1 
# euro area 
# 1 
# europe & central asia 
# 1 
# europe & central asia (excluding high income) 
# 1 
# europe & central asia (ida & ibrd countries) 
# 1 
# european union 
# 1 
# fragile and conflict affected situations 
# 1 
# heavily indebted poor countries (hipc) 
# 1 
# high income 
# 1 
# ibrd only 
# 1 
# ida & ibrd total 
# 1 
# ida blend 
# 1 
# ida only 
# 1 
# ida total 
# 1 
# isle of man 
# 1 
# late-demographic dividend 
# 1 
# latin america & caribbean 
# 1 
# latin america & caribbean (excluding high income) 
# 1 
# latin america & the caribbean (ida & ibrd countries) 
# 1 
# least developed countries: un classification 
# 1 
# low & middle income 
# 1 
# low income 
# 1 
# lower middle income 
# 1 
# middle east & north africa 
# 1 
# middle east & north africa (excluding high income) 
# 1 
# middle east & north africa (ida & ibrd countries) 
# 1 
# middle income 
# 1 
# north america 
# 1 
# not classified 
# 1 
# oecd members 
# 1 
# other small states 
# 1 
# pacific island small states 
# 1 
# post-demographic dividend 
# 1 
# pre-demographic dividend 
# 1 
# small states 
# 1 
# south asia 
# 1 
# south asia (ida & ibrd) 
# 1 
# sub-saharan africa 
# 1 
# sub-saharan africa (excluding high income) 
# 1 
# sub-saharan africa (ida & ibrd countries) 
# 1 
# upper middle income 
# 1 


# DUPLICATES found. Consider using collapse2rgn to collapse duplicates (function in progress).
# 
# # A tibble: 7 × 1
# country                 
# <chr>                   
#   1 China                   
# 2 Guam                    
# 3 Hong Kong Sar, China    
# 4 Macao Sar, China        
# 5 Northern Mariana Islands
# 6 Puerto Rico             
# 7 Virgin Islands (U.s.)  

# fix duplicates
wb_dupe_fix <- wb_clean_names %>%
  group_by(rgn_id, year) %>%
  summarize(sum_fix = ifelse(all(is.na(total_labor_force)), NA, sum(total_labor_force, na.rm = TRUE))) %>%
  rename(total_labor_force = sum_fix)
