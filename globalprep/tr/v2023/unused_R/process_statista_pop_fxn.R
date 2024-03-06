# this function processes population data for saba, sint eustatius, and bonaire -- may be applicable to other population datasets from statista
process_statista_pop_data <- function(file_path, rgn_name, df_name) {
  # read in the csv needing processing
  df <- read_xlsx(file_path, sheet = "Data", skip = 3) %>%
    drop_na()
  
  # fix names
  names(df) <- c("year", "population")
  
  # add column with country name
  df_clean <- df %>%
    mutate(rgn_name = rgn_name) %>%
    left_join(rgns_eez, by = "rgn_name") %>%
    select(rgn_id, rgn_name, year, population)
  
  # prep to fill in 2008-2010 with 2011 (may need to alter this for some data)
  pop_missing_years <- data.frame(
    year = c(2008, 2009, 2010),
    population = NA,
    rgn_id = as.numeric(unique(df_clean$rgn_id)),
    rgn_name = rgn_name
  )
  
  # fill in the years with 2011
  df_year_fill_clean <- df_clean %>%
    rbind(pop_missing_years, .) %>%
    mutate(population_method = ifelse(is.na(population), "Statista - nearby year", "Statista")) %>%
    mutate(population_gapfilled = "gapfilled") %>%
    fill(population, .direction = "up")

    
  
  assign(df_name, df_year_fill_clean, envir = .GlobalEnv) # add to environment
}