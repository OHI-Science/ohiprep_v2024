# use a pre-built function that accesses an API to World Bank data to get populations
populations <- WDI(
  country = "all",
  indicator = "SP.POP.TOTL", 
  start = 2008, end = 2021) %>% # UPDATE end to latest year of arrivals data
  select(country, population = SP.POP.TOTL, year)


# get populations by OHI region
pop_clean_names <- name_2_rgn(df_in = populations,
                              fld_name = 'country') %>%
  select(-country)
# if channels islands gets arrivals data, would need to split that before name_2_rgn

# fix duplicates
pop_dupe_fix <- pop_clean_names %>%
  group_by(rgn_id, rgn_name, year) %>%
  summarize(sum_fix = ifelse(all(is.na(population)), NA, sum(population, na.rm = TRUE))) %>%
  mutate(population_method = ifelse(!is.na(sum_fix), "WDI-WB", NA)) %>%
  rename(population = sum_fix)

# add in another dataset to help gapfill some populations of regions we have arrivals and coastline data for but no population
ourworldindata_file_path <- file.path(dir_M, "git-annex", "globalprep", "_raw_data", "OurWorldinData", paste0("d", version_year), "population.csv") # may want to download latest version if available; if not, copy from previous year
gf_pops <- read_csv(ourworldindata_file_path) %>% 
  rename(country = Entity, year = Year, population = `Population (historical estimates)`) %>%
  select(-Code)

gf_pop_clean_names <- name_2_rgn(df_in = gf_pops,
                                 fld_name = 'country') %>%
  select(-country)
# ignoring countries that were removed in this df since it's just for gapfilling; may be relevant in future years to fix these

# fix duplicates
gf_pop_dupe_fix <- gf_pop_clean_names %>%
  group_by(rgn_id, rgn_name, year) %>%
  summarize(sum_fix = ifelse(all(is.na(population)), NA, sum(population, na.rm = TRUE))) %>%
  rename(population = sum_fix)

# get all countries we have arrivals for from unwto_dupe_fix
all_arrivals_countries <- unwto_dupe_fix_downup_gf %>%
  left_join(rgns_eez, by = "rgn_id") %>% # to get names back for ease of use
  select(rgn_id, rgn_name) %>%
  distinct()

pop_missing_countries <- setdiff(all_arrivals_countries$rgn_id, pop_dupe_fix$rgn_id)

pop_years <- unique(pop_dupe_fix$year)

pop_countries_to_add <- all_arrivals_countries %>%
  filter(rgn_id %in% pop_missing_countries) %>%
  uncount(length(pop_years)) %>%
  group_by(rgn_id, rgn_name) %>% 
  mutate(year = pop_years,
         population = NA)

# combine the two datasets
combined_pops <- pop_dupe_fix %>%
  rbind(pop_countries_to_add) %>%
  left_join(gf_pop_dupe_fix, by = c("rgn_id", "rgn_name", "year"), relationship =
              "many-to-many") %>%
  group_by(rgn_id, rgn_name, year, population_method) %>%
  summarize(population_gf = ifelse(is.na(population.x), population.y, population.x)) %>%
  mutate(population_method = ifelse(is.na(population_method) & !is.na(population_gf), "OurWorldinData", population_method)) %>%
  mutate(population_gapfilled = ifelse(population_method == "OurWorldinData", "gapfilled", NA)) %>% # prepare a "gapfilled" column to indicate "gapfilled" or NA
  rename(population = population_gf) %>%
  ungroup()

# this has left sint eustatius, saba, and bonaire
# statista is the main source found that separates these 3 populations from each other
# as of v2023, only goes back to 2011, so 2011 is used to gapfill 2008-2010 for these countries
# other option in the future could be weighting the 3 populations to divide up the combined value for them in another dataset
# since they didn't seem to have a consistent weighting over time, decided to proceed with statista for v2023
statista_file_path_saba <- file.path(dir_M, "git-annex", "globalprep", "_raw_data", "Statista", paste0("d", version_year), "statistic_id706807_population-of-saba--caribbean-netherlands--2011-2023.xlsx") # may want to download latest version if available; if not, copy from previous year. link: https://www.statista.com/statistics/706807/population-of-saba-in-the-caribbean-netherlands/
statista_file_path_bonaire <- file.path(dir_M, "git-annex", "globalprep", "_raw_data", "Statista", paste0("d", version_year), "statistic_id706799_population-of-bonaire--caribbean-netherlands--2011-2023.xlsx") # may want to download latest version if available; if not, copy from previous year. link: https://www.statista.com/statistics/706799/population-of-bonaire-in-the-caribbean-netherlands/
statista_file_path_sint_eustatius <- file.path(dir_M, "git-annex", "globalprep", "_raw_data", "Statista", paste0("d", version_year), "statistic_id706806_population-of-sint-eustatius--caribbean-netherlands--2011-2023.xlsx") # may want to download latest version if available; if not, copy from previous year. link: https://www.statista.com/statistics/706806/population-of-sint-eustatius-in-the-caribbean-netherlands/

# process the data to be ready to add into the bigger dataset
source(here(paste0("globalprep/tr/v", version_year, "/R/process_statista_pop_fxn.R"))) # outputs what are specified below in df_name

process_statista_pop_data(file_path = statista_file_path_saba, 
                          rgn_name = "Saba",
                          df_name = "saba_gf")
process_statista_pop_data(file_path = statista_file_path_bonaire, 
                          rgn_name = "Bonaire", 
                          df_name = "bonaire_gf")
process_statista_pop_data(file_path = statista_file_path_sint_eustatius, 
                          rgn_name = "Sint Eustatius", 
                          df_name = "sint_eustatius_gf")

# combine the statistsa data into one df
sab_bon_eus_fill <- rbind(saba_gf, bonaire_gf, sint_eustatius_gf) %>%
  filter(year <= 2021) %>% # UPDATE to latest year of arrivals data
  mutate(year = as.integer(year)) # match year type

# fill the bigger dataset with these values
combined_pops_filled <- combined_pops %>%
  rbind(sab_bon_eus_fill) %>%
  drop_na(population) %>% # remove the unfilled saba, bonaire, sint eustatius
  select(-rgn_name) %>% # don't need anymore since done looking into things
  mutate(year = as.character(year)) # match year type again for down the line
