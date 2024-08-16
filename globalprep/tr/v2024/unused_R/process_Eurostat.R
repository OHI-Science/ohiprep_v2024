file_path_euro <- file.path(dir_M, "git-annex", "globalprep", "_raw_data", "Eurostat", paste0("d", version_year), "tour_lfs1r2_linear.csv")

# GET THE DATA WE NEED
euro_data <- read_csv(file_path_euro) %>%
  select(nace_r2, worktime, wstatus, country = geo, year = TIME_PERIOD, tourism_jobs_ct = OBS_VALUE) %>%
  filter(nace_r2 != "TOTAL" & worktime == "TOTAL" & wstatus != "NRP") %>%
  group_by(country, year) %>%
  summarize(jobs_sum = sum(tourism_jobs_ct, na.rm = TRUE)) %>%
  mutate(tourism_jobs_ct_transformed = jobs_sum * 1000) %>%
  select(-jobs_sum) %>%
  ungroup()

# CONVERT EURO CODES TO NAMES
file_path_euro_codes <- file.path(dir_M, "git-annex", "globalprep", "_raw_data", "Eurostat", paste0("d", version_year), "Country_Codes_and_Names.xlsx.xls")
euro_codes <- readxl::read_xlsx(file_path_euro_codes) %>%
  select(country = CODE, country_name = `COUNTRY NAME`)

euro_data_w_names <- euro_data %>%
  left_join(euro_codes, by = "country") %>%
  mutate(
    country_name = case_when(
      country %in% c("ME") ~ "Montenegro",
      country %in% c("MK") ~ "North Macedonia",
      country %in% c("RS") ~ "Serbia", # add additional code equivalents if necessary
      TRUE ~ country_name))

country_code_check <- euro_data_w_names %>%
  filter(is.na(country_name))
print(unique(country_code_check$country)) # add country names for any codes here. EA20 and EU27_2020 are normal and don't need equivalents.

# if all is good, remove the code column and rename the name column "country"
euro_clean <- euro_data_w_names %>%
  select(-country) %>%
  rename(country = country_name)

# CLEAN COUNTRY NAMES
# clean some names to match OHI region names (add more here if discovered below)
euro_clean_fix <- euro_clean %>%
  mutate(
    country = case_when(
      country %in% c("Germany (including former GDR from 1991)") ~ "Germany",
      TRUE ~ country))

# get EUROSTAT data to have OHI names
euro_clean_names <- name_2_rgn(df_in = euro_clean_fix, 
                               fld_name = 'country',
                               flds_unique = c('year')) %>%
  select(-country, -rgn_name)
# v2023
# These data were removed for not having any match in the lookup tables:
# 
# Germany (including former GDR from 1991) (added above)
#                                        1 
#                          North Macedonia (landlocked)
#                                        1