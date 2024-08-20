# note: file paths are not filled into this since code/data was not ultimately used other than in exploration for v2023
library(tidyverse)
library(ohicore)

# exploring if UNWTO guests/overnights data or WB arrivals data can gapfill UNWTO arrivals

# start with UNWTO guests/overnights
file_path_guests_overnights <- "put file path to the data here" # this file was "unwto-inbound-accommodation-data.xlsx" in v2023
guests_overnights <- readxl::read_xlsx(file_path_guests_overnights, skip = 2) 

unwto_guests_overnights_clean <- guests_overnights %>% 
  select(country = `Basic data and indicators`, total_type = `...6`, person_type = `...7`, `1995`:`2021`) %>% # select relevant columns
  fill(country, .direction = "down") %>% # add country name to all data associated with that country
  fill(total_type, .direction = "down") %>% # add total vs. hotels to all data associated with each
  pivot_longer(cols = "total_type",
               values_to = "metric",
               values_drop_na = TRUE) %>% # make the metrics into one column
  filter(!is.na(person_type)) %>%
  select(-name) %>% # get rid of the name column since it's just the titles of the metrics which are already there
  select(country, metric, person_type, everything()) %>% # reorder things
  replace_with_na_all(condition = ~.x == "..") %>% # swap .. with NAs
  pivot_longer(cols = 4:ncol(.), names_to = "year",
               values_to = "tourism_guests_ct") %>% # make the years not columns anymore
  group_by(country, metric, year) %>%
  summarize(tourism_guests_ct = sum(as.numeric(tourism_guests_ct))) %>% # get totals by country/metric/year
  group_by(country, year) %>% # group by county and year
  mutate(
    tourism_guests_ct = ifelse(
      metric == "Total" & is.na(tourism_guests_ct),
      tourism_guests_ct[metric == "Hotels and similar establishments"],
      tourism_guests_ct # fill total with values from hotels if NA because it is not autofilled
    )
  ) %>%
  ungroup() %>% # ungroup since not needed anymore
  filter(metric == "Total") %>% # get metric needed
  select(-metric) %>% # don't need metric since we are down to one
  mutate(country = str_to_title(country), # make countries look nice
         tourism_guests_ct = round(as.numeric(tourism_guests_ct) * 1000)) # since the units were in thousands

unwto_guests_overnights_clean_names <- name_2_rgn(df_in = unwto_guests_overnights_clean,
                                                  fld_name = 'country',
                                                  flds_unique = c('year')) # clean to ohi names

unwto_guests_overnights_dupe_fix <- unwto_guests_overnights_clean_names %>%
  group_by(rgn_id, year) %>%
  summarize(sum_fix = ifelse(all(is.na(tourism_guests_ct)), NA, sum(tourism_guests_ct, na.rm = TRUE))) %>%
  mutate(method = ifelse(!is.na(sum_fix), "UNWTO", NA)) %>%
  rename(tourism_guests_ct = sum_fix)

file_path_arrivals <- "path to arrivals data used in the tourism goal (after gapfilling previous/next year)"
arrivals_data <- read_csv(file_path_arrivals)

joined_data_guests_overnights <- arrivals_data %>% # combine with equivalent arrivals data
  mutate(year = as.character(year)) %>%
  left_join(unwto_guests_overnights_dupe_fix)

model_guests_overnights <- lm(tourism_arrivals_ct ~ tourism_guests_ct, data = joined_data)
summary(model_guests_overnights) # check out the r-squared

test_fill_guests_overnights <- joined_data_guests_overnights %>% 
  filter(is.na(tourism_arrivals_ct)) # check out if there are guests/overnights data points for places where arrivals are missing. v2023: there are no data points for where arrivals are missing


# try using World Bank arrivals data instead
file_path_wb_arrivals <- "file path to WB arrivals data" # file was named "API_ST.INT.ARVL_DS2_en_csv_v2_5728898.csv" in v2023

source(here(paste0("globalprep/tr/v", version_year, "/R/process_WB_generalized_fxn.R")))
process_wb_data(file_path_wb_arrivals, "arrivals", "final_wb_arrivals_df")

joined_data_wb_arrivals <- arrivals_data %>%
  mutate(year = as.character(year)) %>%
  left_join(final_wb_arrivals_df)

model_wb_arrivals <- lm(tourism_arrivals_ct ~ arrivals, data = joined_data_wb_arrivals)
summary(model_wb_arrivals)

test_fill_wb_arrivals <- joined_data_wb_arrivals %>% 
  filter(is.na(tourism_arrivals_ct)) # check out if there are WB arrivals data points for places where arrivals are missing. v2023: there are no data points for where arrivals are missing