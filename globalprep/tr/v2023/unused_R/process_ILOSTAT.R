# process the ILOSTAT DATA

# READ IN
# read in the ILOSTAT data
file_path_ilo <- file.path(dir_M, "git-annex", "globalprep", "_raw_data", "ILOSTAT", paste0("d", version_year), "EMP_TEMP_SEX_OC2_NB_A-filtered-2023-07-28.csv")

# INITIAL CLEANING
# do some initial cleaning before exploring
ilo_data <- read_csv(file_path_ilo) %>%
  filter(sex.label == "Sex: Total" & (grepl("Hospitality", classif1.label))) %>%
  select(ref_area.label, classif1.label, time, obs_value) %>%
  mutate(obs_value = as.numeric(obs_value) * 1000)

# CHECK TOTAL VALUE EQUALS ALL OTHER VALUES ADDED TOGETHER
# doublecheck adding together the different categories roughly equals the total value for a couple countries
ilo_data_check_af_total <- read_csv(file_path_ilo) %>%
  filter(ref_area.label == "Afghanistan" & sex.label == "Sex: Total" & time == "2021" & classif1.label == "Occupation (ISCO-08), 2 digit level: Total")

ilo_data_check_af <- read_csv(file_path_ilo) %>%
  filter(ref_area.label == "Afghanistan" & sex.label == "Sex: Total" & time == "2021") %>%
  drop_na(obs_value) %>%
  mutate(check = sum(obs_value) - ilo_data_check_af_total$obs_value)

ilo_data_check_af_total$obs_value - ilo_data_check_af$check[1] # difference of 6.955

ilo_data_check_bo_total <- read_csv(file_path_ilo) %>%
  filter(ref_area.label == "Bolivia" & sex.label == "Sex: Total" & time == "2021" & classif1.label == "Occupation (ISCO-08), 2 digit level: Total")

ilo_data_check_bo <- read_csv(file_path_ilo) %>%
  filter(ref_area.label == "Bolivia" & sex.label == "Sex: Total" & time == "2021") %>%
  drop_na(obs_value) %>%
  mutate(check = sum(obs_value) - ilo_data_check_bo_total$obs_value)

ilo_data_check_bo_total$obs_value - ilo_data_check_bo$check[1] # difference of 0.182
# numbers are slightly off but not by much for both countries

# CREATE CLEAN DATA
# get data into proper format
ilo_clean <- ilo_data %>%
  select(country = ref_area.label, year = time, tourism_jobs_ct = obs_value)

# clean some names to match OHI region names (add more here if discovered below)
ilo_clean_fix <- ilo_clean %>%
  mutate(
    country = case_when(
      country %in% c("Côte d'Ivoire") ~ "Ivory Coast",
      TRUE ~ country))

# get ILOSTAT data to have OHI names
ilo_clean_names <- name_2_rgn(df_in = ilo_clean_fix, 
                              fld_name = 'country',
                              flds_unique = c('year')) %>%
  select(-country, -rgn_name)

# v2023
# These data were removed for not having any match in the lookup tables:
# 
#   Côte d'Ivoire (added above)   Eswatini (landlocked)  North Macedonia landlocked)
#               1                        1                      1 