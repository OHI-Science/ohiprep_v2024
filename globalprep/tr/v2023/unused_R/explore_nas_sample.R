# looking at some UNWTO tourism-related datasets to see which has the most data
library(tidyverse)

base_path <- "put anything preceding the folder and/or file name here"

file_path_1 <- paste0(base_path, "unwto-inbound-accommodation-data.xlsx")
file_path_2 <- paste0(base_path, "unwto-inbound-arrivals-by-main-purpose-data.xlsx") # not used
file_path_3 <- paste0(base_path, "unwto-inbound-arrivals-data.xlsx") 
file_path_4 <- paste0(base_path, "unwto-inbound-expenditure-data.xlsx") 
file_path_5 <- paste0(base_path, "unwto-tourism-industries-data.xlsx") # not used

test_num_1 <- readxl::read_xlsx(file_path_1, skip = 2) %>%
  filter(!is.na(`Basic data and indicators`) | `...7` == "Guests" | `...7` == "Overnights") %>%
  mutate(`S.` = as.numeric(`S.`)) %>%
  select(-`...5`, -`...6`, -`...8`, -`...38`, -`Notes`, -`Units`, -`Basic data and indicators`)

test_129 <- test_num_1 %>% # the number at the end is the S. number
  filter(`S.` == 1.29)
missing_129 <- sum(apply(test_129, c(1, 2), function(x) sum(x == "..")))

test_130 <- test_num_1 %>%
  filter(`S.` == 1.30)
missing_130 <- sum(apply(test_130, c(1, 2), function(x) sum(x == "..")))

test_131 <- test_num_1 %>%
  filter(`S.` == 1.31)
missing_131 <- sum(apply(test_131, c(1, 2), function(x) sum(x == "..")))

test_132 <- test_num_1 %>%
  filter(`S.` == 1.32)
missing_132 <- sum(apply(test_132, c(1, 2), function(x) sum(x == "..")))

test_num_2 <- readxl::read_xlsx(file_path_3, skip = 2) %>%
  filter(!is.na(`Basic data and indicators`) | `...6` == "Total arrivals") %>%
  mutate(`S.` = as.numeric(`S.`)) %>%
  select(-`...5`, -`...7`, -`...8`, -`...39`, -`Notes`, -`Units`, -`Basic data and indicators`)

test_11 <- test_num_2 %>%
  filter(`S.` == 1.1)
missing_11 <- sum(apply(test_11, c(1, 2), function(x) sum(!is.na(x) & x == "..")))

test_num_3 <- readxl::read_xlsx(file_path_3, skip = 2) %>%
  filter(!is.na(`Basic data and indicators`) | `...7` == "Overnights visitors (tourists)") %>%
  mutate(`S.` = as.numeric(`S.`)) %>%
  select(-`...5`, -`...6`, -`...8`, -`...39`, -`Notes`, -`Units`, -`Basic data and indicators`, -`Series`)

test_12 <- test_num_3 %>%
  filter(`S.` == 1.2)
missing_12 <- sum(apply(test_12, c(1, 2), function(x) sum(!is.na(x) & x == "..")))

test_num_4 <- readxl::read_xlsx(file_path_3, skip = 2) %>%
  filter(!is.na(`Basic data and indicators`) | `...7` == "Same-day visitors (excursionists)") %>%
  mutate(`S.` = as.numeric(`S.`)) %>%
  select(-`...5`, -`...6`, -`...8`, -`...39`, -`Notes`, -`Units`, -`Basic data and indicators`, -`Series`)

test_13 <- test_num_4 %>%
  filter(`S.` == 1.3)
missing_13 <- sum(apply(test_13, c(1, 2), function(x) sum(!is.na(x) & x == "..")))

test_num_5 <- readxl::read_xlsx(file_path_3, skip = 2) %>%
  filter(!is.na(`Basic data and indicators`) | `...8` == "of which, cruise passengers") %>%
  mutate(`S.` = as.numeric(`S.`)) %>%
  select(-`...5`, -`...6`, -`...7`, -`...39`, -`Notes`, -`Units`, -`Basic data and indicators`, -`Series`)

test_14 <- test_num_5 %>%
  filter(`S.` == 1.4)
missing_14 <- sum(apply(test_14, c(1, 2), function(x) sum(!is.na(x) & x == "..")))


test_num_6 <- readxl::read_xlsx(file_path_4, skip = 2) %>%
  filter(!is.na(`Basic data and indicators`) | `...5` == "Tourism expenditure in the country") %>%
  mutate(`S.` = as.numeric(`S.`)) %>%
  select(-`...6`, -`...7`, -`...8`, -`...39`, -`Notes`, -`Units`, -`Basic data and indicators`, -`Series`)

test_133 <- test_num_6 %>%
  filter(`S.` == 1.33)
missing_133 <- sum(apply(test_133, c(1, 2), function(x) sum(!is.na(x) & x == "..")))

test_num_7 <- readxl::read_xlsx(file_path_4, skip = 2) %>%
  filter(!is.na(`Basic data and indicators`) | `...6` == "Travel") %>%
  mutate(`S.` = as.numeric(`S.`)) %>%
  select(-`...5`, -`...7`, -`...8`, -`...39`, -`Notes`, -`Units`, -`Basic data and indicators`, -`Series`)

test_134 <- test_num_7 %>%
  filter(`S.` == 1.34)
missing_134 <- sum(apply(test_134, c(1, 2), function(x) sum(!is.na(x) & x == "..")))


test_num_8 <- readxl::read_xlsx(file_path_4, skip = 2) %>%
  filter(!is.na(`Basic data and indicators`) | `...6` == "Passenger transport") %>%
  mutate(`S.` = as.numeric(`S.`)) %>%
  select(-`...5`, -`...7`, -`...8`, -`...39`, -`Notes`, -`Units`, -`Basic data and indicators`, -`Series`)

test_135 <- test_num_8 %>%
  filter(`S.` == 1.35)
missing_135 <- sum(apply(test_135, c(1, 2), function(x) sum(!is.na(x) & x == "..")))


# exploring how many countries have NAs in UNWTO tourism data (this example is employment)
file_path_employment <- paste0(base_path, "unwto-employment-data.xlsx")
employment_data <- readxl::read_xlsx(file_path_employment, skip = 2)

years <- as.character(1995:2021)
employment_data_prepped <- employment_data[1:446,] %>%
  select(`C.`, `Basic data and indicators`, all_of(years))

combined_rows <- employment_data_prepped %>%
  group_by(`C.`) %>%
  summarise_all(function(x) ifelse(all(is.na(x)), NA, na.omit(x)[1])) %>%
  ungroup() %>%
  select(-`C.`)

combined_rows_long <- combined_rows %>%
  pivot_longer(cols = `1995`:`2021`, names_to = "year", values_to = "thousands_employed_in_tourism") %>%
  mutate(thousands_employed_in_tourism = as.numeric(na_if(thousands_employed_in_tourism, "..")))

check_2020_nas <- combined_rows_long %>% 
  filter(year == 2020) %>% 
  mutate(countries = tolower(`Basic data and indicators`)) %>% 
  select(-`Basic data and indicators`)
sum(is.na(check_2020_nas$thousands_employed_in_tourism))

find_countries_w_no_data <- combined_rows_long %>%
  mutate(countries = tolower(`Basic data and indicators`)) %>%
  select(-`Basic data and indicators`) %>%
  group_by(countries) %>%
  filter(!all(is.na(thousands_employed_in_tourism))) %>%
  ungroup()