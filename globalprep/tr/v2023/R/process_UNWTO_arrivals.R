library(countrycode)

# process UNWTO arrivals in tourism data
file_path_unwto <- file.path(dir_M, "git-annex", "globalprep", "_raw_data", "UNWTO", paste0("d", version_year), "unwto-inbound-arrivals-data.xlsx")
unwto_arrivals <- readxl::read_xlsx(file_path_unwto, skip = 2) # read in the raw data

unwto_clean <- unwto_arrivals %>% 
  select(country = `Basic data and indicators`, total = `...6`, subdivision_1 = `...7`, subdivision_2 = `...8`, `1995`:`2021`) %>% # select relevant columns
  fill(country, .direction = "down") %>% # add country name to all data associated with that country
  pivot_longer(cols = c("total", "subdivision_1", "subdivision_2"),
               values_to = "metric",
               values_drop_na = TRUE) %>% # make the metrics into one column
  select(-name) %>% # get rid of the name column since it's just the titles of the metrics which are already there
  select(country, metric, everything()) %>% # reorder things
  replace_with_na_all(condition = ~.x == "..") %>% # swap .. with NAs
  pivot_longer(cols = 3:ncol(.), names_to = "year",
               values_to = "tourism_arrivals_ct") %>% # make the years not columns anymore
  pivot_wider(names_from = metric, values_from = tourism_arrivals_ct) %>%
  mutate(overnights = as.numeric(`Overnights visitors (tourists)`), 
         same_day = as.numeric(`Same-day visitors (excursionists)`), 
         total = as.numeric(`Total arrivals`),
         tourism_arrivals_ct = as.numeric(NA)) %>% # rename metrics so easier to work with, make numeric, and add a new column to fill with the new calculated values later
  select(country, year, overnights, same_day, total, tourism_arrivals_ct) %>% # select columns needed for analysis (cruise passengers seem to be included in same-day)
  group_by(country, year) %>% # group by county and year
  mutate(
    tourism_arrivals_ct = case_when(
      !is.na(overnights) ~ overnights,
      is.na(overnights) & !is.na(same_day) & !is.na(total) ~ total - same_day,
      TRUE ~ tourism_arrivals_ct
    ),
    total = case_when(
      !is.na(total) ~ total,
      is.na(total) & !is.na(same_day) & !is.na(overnights) ~ overnights + same_day,
      TRUE ~ total
    )
  ) %>% # v2023: NAs are 601 out of 6021
  mutate(arrivals_method = ifelse(is.na(overnights) & !is.na(same_day) & !is.na(total), "UNWTO - subtraction", NA)) %>%
  mutate(arrivals_gapfilled = ifelse(arrivals_method == "UNWTO - subtraction", "gapfilled", NA)) %>% # prepare a "gapfilled" column to indicate "gapfilled" or NA
  ungroup() %>% # ungroup since not needed anymore
  select(country, year, tourism_arrivals_ct, total, arrivals_method, arrivals_gapfilled) %>% # select only needed columns
  mutate(country = str_to_title(country), # make countries look nice
         tourism_arrivals_ct = round(as.numeric(tourism_arrivals_ct) * 1000),
         total = round(as.numeric(total)*1000)) # since the units were in thousands

# Macquerie, Andaman and Nicobar, Azores, Madeira, Prince Edwards Islands, Oecussi Ambeno, Canary Islands all duplicated with their governing regions. Aside from the uninhabited ones, I think it actually makes sense to give them the same score as their vassal states, given that places like Azores and Canary Islands probably make up a decent chunk of Portugal and Spain tourism...
# get UNWTO data to have OHI region names
unwto_match_iso3c <- unwto_clean %>%
  mutate(iso3c = countrycode::countrycode(sourcevar = country, origin = "country.name", destination = "iso3c")) %>%
  left_join(rgns_eez, by = c("iso3c" = "eez_iso3")) %>%
  dplyr::select(rgn_id, year, arrivals_method, arrivals_gapfilled, tourism_arrivals_ct, total) %>%
  filter(!is.na(rgn_id))

unwto_clean_names_bonaire <- name_2_rgn(df_in = unwto_clean %>% filter(country == "Bonaire"), # do this just for Bonaire since it is the only region not matching above
                                fld_name = 'country',
                                # flds_unique = c('year'),
                                keep_fld_name = TRUE) %>%
  dplyr::select(rgn_id, year, arrivals_method, arrivals_gapfilled, tourism_arrivals_ct, total)#### losing lots of regions here for some reason... most concerndely USA


unwto_clean_names <- rbind(unwto_clean_names_bonaire, unwto_match_iso3c) %>% # rbind back together. I would've used the name_2_rgns fxn for everything, but it was excluding a lot of regiosn for some reason...
  left_join(rgns_eez) %>%
  dplyr::select(rgn_id, rgn_name, year, arrivals_method, arrivals_gapfilled, tourism_arrivals_ct, total)

# fix duplicates if there are any
unwto_dupe_fix <- unwto_clean_names %>%
  group_by(rgn_id, year, arrivals_method, arrivals_gapfilled) %>%
  summarize(sum_fix = ifelse(all(is.na(tourism_arrivals_ct)), NA, sum(tourism_arrivals_ct, na.rm = TRUE)),
            sum_fix_2 = ifelse(all(is.na(total)), NA, sum(total, na.rm = TRUE))) %>%
  mutate(arrivals_method = ifelse(is.na(arrivals_method) & !is.na(sum_fix), "UNWTO", arrivals_method)) %>%
  rename(tourism_arrivals_ct = sum_fix,
         total = sum_fix_2)

# check out things so far
summary(unwto_dupe_fix) # v2023: 828 NAs in arrivals (before filtering the years down and gapfilling), 1708 in `total`

# gapfill arrivals
# downfill then upfill missing values using a linear model of the average increase per years across all years of data for 1995-2019
# for 2020 and 2021, use the global average proportion increase or decrease and add to the previous years value

test <- unwto_dupe_fix %>%
  filter(year %in% c(2020, 2021)) %>%
  filter(!is.na(tourism_arrivals_ct) & !is.na(total)) %>%
  pivot_wider(names_from = year, values_from = c(tourism_arrivals_ct, total)) %>%
  mutate(tourism_ct_diff = (tourism_arrivals_ct_2021 - tourism_arrivals_ct_2020)/tourism_arrivals_ct_2020) %>%
  mutate(total_diff = (total_2021 - total_2020)/total_2020)

gf_2021_tourism <- mean(test$tourism_ct_diff, na.rm = TRUE) # global average increase for 2021 tourist

gf_2021_total <- mean(test$total_diff, na.rm = TRUE) # global average increase for 2021 total

# 
# plot(test$total_diff, test$tourism_ct_diff) # looks pretty linear, so thats good, we can use the same method of gapfilling
# mean(test$total_diff, na.rm = TRUE) # 0.08301438 average increase
# mean(test$tourism_ct_diff, na.rm = TRUE) # 0.2832816 average increase
# ## ok, lets use these values to gapfill 2021 if it is NA and 2020 exists. So increase by X proportion (0.08 or 0.28)

test <- unwto_dupe_fix %>%
  filter(year %in% c(2019, 2020)) %>%
  filter(!is.na(tourism_arrivals_ct) & !is.na(total)) %>%
  pivot_wider(names_from = year, values_from = c(tourism_arrivals_ct, total)) %>%
  mutate(tourism_ct_diff = (tourism_arrivals_ct_2020 - tourism_arrivals_ct_2019)/tourism_arrivals_ct_2019) %>%
  mutate(total_diff = (total_2020 - total_2019)/total_2019)
 
gf_2020_tourism <- mean(test$tourism_ct_diff, na.rm = TRUE) # global average decerease for 2020 tourst
gf_2020_total <- mean(test$total_diff, na.rm = TRUE) # global average decrease for 2020 total

# 
# plot(test$total_diff, test$tourism_ct_diff) # looks pretty linear, so thats good, we can use the same method of gapfilling
# mean(test$total_diff, na.rm = TRUE) # -0.7015468 average decrease
# mean(test$tourism_ct_diff, na.rm = TRUE) # -0.7030777 average decrease
# ## ok, lets use these values to gapfill 2020 if it is NA and 2019 exists. So decrease by X proportion ~70%


unwto_upfill <-  unwto_dupe_fix %>%
  filter(year < 2020) %>%
  group_by(rgn_id) %>%
  arrange(rgn_id, year) %>%
  tidyr::fill(tourism_arrivals_ct, .direction = "up") %>%
  tidyr::fill(total, .direction = "up") %>% # fill in any values that are empty from early years with values from the nearest year. Doing this because doesn't make sense to add earlier years based on a trend 
  mutate(arrivals_method = ifelse(is.na(arrivals_method) & !is.na(tourism_arrivals_ct), "nearby year", arrivals_method)) %>%
  mutate(arrivals_gapfilled = ifelse(arrivals_method == "nearby year", "gapfilled", arrivals_gapfilled))

## calculate regional average increase or decrease in number of total arrivals
lm_coef_data_total <- unwto_dupe_fix %>%
  filter(!(year %in% c(2020, 2021))) %>%
  group_by(rgn_id) %>%
  filter(!is.na(total)) %>%
  summarize(lm_coef_total = if (n() > 1) lm(total ~ year)$coefficients[2] else 0, .groups = 'drop') # give it an addition of 0 if it is stagnant

## calculate regional average increase or decrease in number of tourism arrivals
lm_coef_data_tourism <- unwto_dupe_fix %>%
  filter(!(year %in% c(2020, 2021))) %>%
  group_by(rgn_id) %>%
  filter(!is.na(tourism_arrivals_ct)) %>%
  summarize(lm_coef_tourism = lm(tourism_arrivals_ct ~ year)$coefficients[2])


# Initialize a flag to check if there are still NAs
na_flag <- TRUE

# filter out any regions with all nas for each year, as these can't be gapfilled
all_nas_tourism <- unwto_upfill %>%
  group_by(rgn_id) %>%
  filter(all(is.na(tourism_arrivals_ct))) %>%
  dplyr::select(rgn_id, year, tourism_arrivals_ct, arrivals_method, arrivals_gapfilled)

unwto_gapfill_lm_2019_tourism <- unwto_upfill %>%
  left_join(lm_coef_data_tourism) %>% 
   ungroup() %>%
  filter(!(rgn_id %in% c(all_nas_tourism$rgn_id))) %>%
  dplyr::select(rgn_id, year, tourism_arrivals_ct, arrivals_method, arrivals_gapfilled, lm_coef_tourism)


## now lets fill in any values down with the linear model average increase per year for tourists
while(na_flag) {
  
  unwto_gapfill_lm_2019_tourism <- unwto_gapfill_lm_2019_tourism %>%
    group_by(rgn_id) %>%
    arrange(year) %>%
    mutate(
      tourism_arrivals_ct = case_when(
        is.na(tourism_arrivals_ct) & !is.na(lag(tourism_arrivals_ct)) ~ lag(tourism_arrivals_ct) + lm_coef_tourism,
        TRUE ~ tourism_arrivals_ct
      )
    ) %>%
    mutate(arrivals_method = ifelse(is.na(arrivals_method) & !is.na(tourism_arrivals_ct), "linear model", arrivals_method)) %>%
    mutate(arrivals_gapfilled = ifelse(arrivals_method == "linear model", "gapfilled", arrivals_gapfilled)) %>%
    ungroup()
  
  # Check if there are still NAs left in either column
  na_flag <- any(is.na(unwto_gapfill_lm_2019_tourism$tourism_arrivals_ct))
}

unwto_gapfill_lm_2019_tourism_all <- unwto_gapfill_lm_2019_tourism %>%
  dplyr::select(-lm_coef_tourism) %>%
  rbind(all_nas_tourism)

### Now do the same thing for total column
# Initialize a flag to check if there are still NAs
na_flag <- TRUE

all_nas_total <- unwto_upfill %>%
  group_by(rgn_id) %>%
  filter(all(is.na(total))) %>%
  dplyr::select(rgn_id, year, total)

unwto_gapfill_lm_2019_total <- unwto_upfill %>%
  filter(year < 2020) %>%
  group_by(rgn_id) %>%
  arrange(rgn_id, year) %>%
  tidyr::fill(total, .direction = "up") %>% # fill in any values that are empty from early years with values from the nearest year
  left_join(lm_coef_data_total) %>%
  ungroup() %>%
  filter(!(rgn_id %in% c(all_nas_total$rgn_id))) %>%
  dplyr::select(rgn_id, year, total, lm_coef_total)


## now lets fill in any values down with the linear model average increase per year for tourists
while(na_flag) {
  
  unwto_gapfill_lm_2019_total <- unwto_gapfill_lm_2019_total %>%
    group_by(rgn_id) %>%
    arrange(year) %>%
    mutate(
      total = case_when(
        is.na(total) & !is.na(lag(total)) ~ lag(total) + lm_coef_total,
        TRUE ~ total
      )
    ) %>%
    ungroup()
  
  # Check if there are still NAs left in either column
  na_flag <- any(is.na(unwto_gapfill_lm_2019_total$total))
}

unwto_gapfill_lm_2019_total_all <- unwto_gapfill_lm_2019_total %>%
  dplyr::select(-lm_coef_total) %>%
  mutate(total = ifelse(rgn_id == 67 & total < 0, unwto_gapfill_lm_2019_total %>%
                          filter(rgn_id == 67, year == 2009 ) %>% pull(total) , total)) %>% # fix libya, as it was being given negative values with the gapfill. Just give it its latest year (downfill)
  rbind(all_nas_total)


unwto_2020_2021 <- unwto_dupe_fix %>%
  filter(year > 2019) # lets fix 2020 and 2021 now

unwto_all_gf <- unwto_gapfill_lm_2019_tourism_all %>%
    left_join(unwto_gapfill_lm_2019_total_all) %>%
  rbind(unwto_2020_2021) %>%
  group_by(rgn_id) %>%
  arrange(rgn_id, year) %>%
  # apply global average proportional increase or decrease for 2020 and 2021, because of covid pandemic messing up trends...
  mutate(tourism_arrivals_ct = ifelse(year == 2020 & is.na(tourism_arrivals_ct), lag(tourism_arrivals_ct, n = 1) + lag(tourism_arrivals_ct, n = 1)*gf_2020_tourism, tourism_arrivals_ct),
         total = ifelse(year == 2020 & is.na(total), lag(total, n = 1) + lag(total, n = 1)*gf_2020_total, total)) %>%

  mutate(tourism_arrivals_ct = ifelse(year == 2021 & is.na(tourism_arrivals_ct), lag(tourism_arrivals_ct, n = 1) + lag(tourism_arrivals_ct, n = 1)*gf_2021_tourism, tourism_arrivals_ct),
         total = ifelse(year == 2021 & is.na(total), lag(total, n = 1) + lag(total, n = 1)*gf_2021_total, total)) %>%
  mutate(arrivals_method = ifelse(is.na(arrivals_method) & !is.na(tourism_arrivals_ct), "2020 and 2021 gapfill method", arrivals_method)) %>%
  mutate(arrivals_gapfilled = ifelse(arrivals_method == "2020 and 2021 gapfill method", "gapfilled", arrivals_gapfilled)) %>%
  filter(year >= 2008) %>% # get only the year we need and beyond
  drop_na(tourism_arrivals_ct)  # remove any remaining NAs (any remaining have all NAs for that region)
 # drop_na(total) # keep these NAs, we will just give these regions a perfect score...



## old way
# unwto_dupe_fix_downup_gf <- unwto_dupe_fix %>%
#   fill(tourism_arrivals_ct, .direction = "downup") %>%
#   fill(total, .direction = "downup") %>%
#   mutate(arrivals_method = ifelse(is.na(arrivals_method) & !is.na(tourism_arrivals_ct), "nearby year", arrivals_method)) %>%
#   mutate(arrivals_gapfilled = ifelse(arrivals_method == "nearby year", "gapfilled", arrivals_gapfilled)) %>%
#   filter(year >= 2008) %>% # get only the year we need and beyond
#   drop_na(tourism_arrivals_ct) # remove any remaining NAs (any remaining have all NAs for that region)
# 
# # check out things so far
# summary(unwto_dupe_fix_downup_gf) # NAs should be 0 now
