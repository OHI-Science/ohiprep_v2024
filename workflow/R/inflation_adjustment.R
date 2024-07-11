#' Inflation Adjustment Function for Economies sub-goal 
#' @author Anna Ramji, Dustin Duncan, Sophia Lecuona
#' uses inflation adjustment function (priceR::adjust_for_inflation)
#'
#' @param df data frame with the following columns: rgn_id, rgn_name, year, usd, unit, sector, usd_yr
#' @param conversion_date USD year you want the adjusted values to be in
#' @param country country of unit value (e.g., "US")
#' @param current_year assessment year  
#'
#' @return updated data frame with adj_usd column populated with inflation-adjusted values in USD of specified year (conversion_date)
#' @export  # writes csv with sector name incorporated to the 'int' folder 
#'
#' @examples
#' inflation_adjustment(cf_df, 2017, "US", 2024)
inflation_adjustment <- function(df, conversion_date, country, current_year){
  
  # specify output directory (to le, vYEAR, int)
  v_year <- paste0("v", current_year)
  output_dir <- here("globalprep", "le", v_year, "int")
  
  ## Using priceR for each unique combination of year, rgn_id, and sector --> aggregate function maybe 
  
  # pull out values (in USD)
  prices <- df$usd
  
  # USD year associated with values (e.x., 2015 if that value is in (USD 2015))
  from_dates <- df$usd_yr
  
  # USD year you want the adjusted values to be in
  to_dates <- as.numeric(conversion_date)
  
  # country of unit value (US if USD)
  country <- as.character(country)
  
  # run priceR::adjust_for_inflation
  converted_usd_vec <- priceR::adjust_for_inflation(price = prices, from_date = from_dates, country = country, to_date = to_dates)
  
  # save output vector as new column in df
  df$adj_usd = converted_usd_vec
  
  # extract sector name for output file name
  sector <- df$sector[1]
  
  # write intermediate file to `int` folder in le/vYEAR/int with appropriate sector name
  write_csv(df, here::here(output_dir, paste0("eco_", sector, "_usd_adj.csv")))
  
  # return updated data frame 
  return(df)
  
}

