# Load packages
library(raster)
library(RColorBrewer)
library(tidyverse)
library(rgdal)
library(doParallel)
library(foreach)
library(sf)
library(ncdf4)
library(httr)
library(lubridate)
library(animation)
library(plotly)
library(here)
library(snow)
library(terra)

# OHI spatial files, directories, etc
source(here("workflow/R/common.R"))

# Update scenario year, set up programmatic scenario year updating
scen_year_number <- 2023
scen_year <- as.character(scen_year_number)
prev_scen_year <- as.character(scen_year_number - 1)

# suppress progress bars for terra
terraOptions(progress=0)

# Standard OHI file paths
dir_data <- paste0(dir_M, "/git-annex/globalprep/_raw_data/CoRTAD_sst/d", scen_year)
dir_int  <- paste0(dir_M, "/git-annex/globalprep/prs_sst/v", scen_year, "/int")
dir_output  <- paste0(dir_M, "/git-annex/globalprep/prs_sst/v", scen_year, "/output")

# Change this file path for full update to correct update scenario year
dir_rasters <- paste0(dir_M, 
                      "/git-annex/globalprep/prs_sst/prs_sst_calculated_rasters/v2023_update")
# Load in OHI spatial data
ohi_rasters()
regions_shape()

# Create array with 5 year reference period and 5 year OHI score years
target_years = 1985:prev_scen_year

# See if files exist or are already created
anom_files <- list.files(file.path(dir_rasters,
                                   "annual_positive_anomalies"), 
                         pattern = "annual_pos_anomalies", full.names = TRUE)

# Extracting years from file names
file_years <- sapply(anom_files, function(x) as.integer(substr(x, nchar(x)-7, nchar(x)-4)))

# Find the missing years
yrs <- setdiff(target_years, file_years)

# Rainbow color scheme and load in OHI regions
cols <- rev(colorRampPalette(brewer.pal(11, 'Spectral'))(255)) 
land <- regions %>% subset(rgn_type %in% c("land", "land-disputed", "land-noeez"))


################################################################################

# Load netcdf for SST radiation data
ssta <- rast(list.files(dir_data, 
                        pattern = "SSTA.nc", 
                        full.names = TRUE), 
             subds = "SSTA")


# Rename each layer, terra autonames so we take the names from layer dates
names(ssta) <- time(ssta)

# Assign names to an object
names_weekly <- names(ssta)

# Convert the names into a data frame
ssta_df <- data.frame(name = names_weekly) %>%
  # Convert the name to a date
  mutate(date = as.Date(name)) %>%
  # Extract the year, month, day, and week
  mutate(
    year = year(date),
    month = month(date),
    day = day(date),
    week = week(date))


################################################################################

# 50 minutes per year

# Plan for a multicore future
cores <- 3
registerDoParallel(cores)

# Loop runs each week in a year past the weekly SD rasters to identify and sum anomalies
foreach(j = yrs, .packages = c("terra", "dplyr")) %dopar% {
  
  # Start timer
  start_time <- Sys.time()
  
  # Print a time stamp
  print(paste("calculating anomaly for", j, "-- started at", start_time))
  
  # Filter 'ssta_df' for the current year 'j' and select the 'week' column. 
  # The result is stored in 'wks'.
  wks <- ssta_df %>% 
    filter(year == j) %>% 
    select(week)
  
  # initialize s
  s <- list()
  
  for(i in wks$week) {
    
    # Load a raster layer 'sd_sst' from a TIFF file specific to the current week 'i'.
    sd_sst <- terra::rast(file.path(dir_rasters, 
                                    "weekly_sd_30yr_rasters", 
                                    sprintf("sst_sd_week_%s.tif", i)))
    
    # Find the index 'w' of the current week 'i' in the 'names_ssta' vector for the current year 'j'.
    w <- which(substr(names_weekly, 1, 4) == j)[i]
    
    # Get the 'w'-th raster layer from the 'ssta' stack.
    w_ssta <- ssta[[w]]
    
    # Find anomalies using custom function
    anomaly_raster <- terra::lapp(c(w_ssta, sd_sst),
                                  fun = function(x, y){ifelse(is.na(x) | is.na(y), 0,
                                                              ifelse(x > y, 1, 0))})
    
    # Fill s with anomaly rasters
    s[[i]] <- anomaly_raster
    
    # Print a message when it is at the 28th i loop
    if (i == 30) {
      print(paste("Halfway done with year", j))
    }
    
  } # End of inner loop
  
  # Stack the raster layers in 's' to create a multi-layered raster
  s_stack <- rast(s)
  
  # Use the 'sum_anom' function defined earlier to calculate the sum of the raster stack 's'.
  yr <- terra::app(s_stack, fun = sum)
  
  # Write the raster layer 'yr' to a TIFF file named "annual_pos_anomalies_sd_<year>.tif".
  writeRaster(yr, filename = file.path(dir_rasters,
                                       "annual_positive_anomalies",
                                       sprintf("annual_pos_anomalies_sd_%s.tif", j)),
              overwrite=TRUE)
  
  # End timer and calculate elapsed time
  end_time <- Sys.time()
  elapsed_time <- end_time - start_time
  
  # Print time message
  print(paste("Anom for year", j, "started at", start_time, "and took", elapsed_time, "minutes to complete"))
  
} # End of outer loop
