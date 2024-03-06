# read in area of coastline data
inland_filepath <- file.path("globalprep", "lsp", paste0("v", version_year), "int", "area_protected_1km.csv")
inland_data <- read_csv(inland_filepath)
offshore_filepath <- file.path("globalprep", "lsp", paste0("v", version_year), "int", "area_protected_3nm.csv")
offshore_data <- read_csv(offshore_filepath)

# get combined value of inland and offshore for each ohi region
inland_offshore <- inland_data %>%
  left_join(offshore_data, by = join_by(rgn_id, year, rgn_name)) %>%
  select(rgn_id, year, a_tot_km2.x, a_tot_km2.y) %>%
  group_by(rgn_id, year) %>%
  mutate(total_inland_offshore_area = a_tot_km2.x + a_tot_km2.y,
         year = as.character(year)) %>%
  select(rgn_id, year, total_inland_offshore_area)
