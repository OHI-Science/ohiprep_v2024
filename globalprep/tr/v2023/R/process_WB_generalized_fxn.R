# v2023: THIS ENDED UP NOT BEING USED OTHER THAN IN EXPLORATION, BUT WAS LEFT HERE IN CASE CODE BECOMES RELEVANT IN THE FUTURE
# the WDI function that we use functions similarly to this

process_wb_data <- function(file_path, value_name, df_name) {
  # read in the csv needing processing
  df <- read_csv(file_path, skip = 4)
  
  # select needed columns
  df_clean <- df %>%
    select(country = `Country Name`, `1960`:`2022`)
  
  # get in long format
  df_clean_long <- df_clean %>%
    pivot_longer(cols = -country,
                 names_to = "year",
                 values_to = "values") %>%
    mutate(country = str_to_title(country))
  
  # run name_2_rgn to get correct names
  df_clean_names <- name_2_rgn(df_in = df_clean_long,
                               fld_name = "country",
                               flds_unique = "year")
  
  # fix any duplicates
  df_dupe_fix <- df_clean_names %>%
    group_by(rgn_id, year) %>%
    summarize({{ value_name }} := ifelse(all(is.na(values)), NA, sum(values, na.rm = TRUE)))
  
  assign(df_name, df_dupe_fix, envir = .GlobalEnv) # add to environment
}