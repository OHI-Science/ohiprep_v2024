# process OECD number employed in tourism data

# READ IN
# read in the OECD data
file_path_oecd <- file.path(dir_M, "git-annex", "globalprep", "_raw_data", "OECD", paste0("d", version_year), "TOURISM_ENTR_EMPL_31072023210756847.csv")

oecd_data <- read_csv(file_path_oecd) %>%
  select(country = Country, year = Year, tourism_jobs_ct = Value)
# already clean after selecting, so proceed with this

# clean some names to match OHI region names (add more here if discovered below)
oecd_clean_fix <- oecd_data %>%
  mutate(
    country = case_when(
      country %in% c("Korea") ~ "South Korea",
      TRUE ~ country))

# get OECD data to have OHI region names
oecd_clean_names <- name_2_rgn(df_in = oecd_clean_fix, 
                                fld_name = 'country',
                                flds_unique = c('year')) %>%
  select(-country, -rgn_name)

# v2023
# These data were removed for not having any match in the lookup tables:
#   
#   Korea (OECD member is South Korea, added above)
# 1 