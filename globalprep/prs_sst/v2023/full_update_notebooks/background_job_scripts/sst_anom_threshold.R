# Set up environment for background job

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
library(tictoc)
library(furrr)
library(purrr)
library(future)

# OHI spatial files, directories, etc
source(here("workflow/R/common.R"))

# Update scenario year, set up programatic scenario year updating
scen_year_number <- 2023
scen_year <- as.character(scen_year_number)
prev_scen_year <- as.character(scen_year_number - 1)

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

# Specify years for SD and mean calculation
yrs <- 1982:2011

# Rainbow color scheme and load in OHI regions
cols <- rev(colorRampPalette(brewer.pal(11, 'Spectral'))(255)) 
land <- regions %>% subset(rgn_type %in% c("land", "land-disputed", "land-noeez"))

################################################################################

# This script requires that the data is already downloaded, refer to the rmd for download directions

################################################################################

# Create data frame for name references in loop

# Load netcdf for SST data
weekly_sst <- rast(list.files(dir_data, 
                              pattern = "WeeklySST.nc", 
                              full.names = TRUE), 
                   subds = "WeeklySST")

# Rename each layer, terra autonames so we take the names from layer dates
names(weekly_sst) <- time(weekly_sst)

# Assign names to an object
names_weekly <- names(weekly_sst)

# Convert the names into a data frame
sst_df <- data.frame(name = names_weekly) %>%
  # Convert the name to a date
  mutate(date = as.Date(name)) %>%
  # Extract the year, month, day, and week
  mutate(
    year = year(date),
    month = month(date),
    day = day(date),
    week = week(date)
  )

################################################################################

## ~15 min per layer, 53 layers, 5 cores (2023)
## ~8 min per layer, 53 layers, 4 cores (2023) more cores not always better

# This loop takes the weekly SST data and creates 53 single layer raster files, 
# one for each week of the year, and saves them to Mazu. Each weekly raster 
# file's cell values correspond to the standard deviation of SST values for all 
# years in the reference period (1982 - 2011 for that week. This gives us a 
# measure of variability in SST for that time of the year that will allow us to 
# identify SST values that are "anomalous" for that time of the year.

# Loop through 53 weeks
for(i in 1:53){
  
  # Start timer with tic()
  start_time <- Sys.time()
  
  # Print time message
  print(paste("anom_threshold for week", i, "started at", start_time))
  
  # Initialize r
  r <- NULL
  
  # Loop through all the years in the yrs variable
  for (j in yrs){
    
    # Find the index of the weekly data for the year j and week i
    w <- which(substr(names_weekly, 1, 4) == j)[i]
    
    # If there is no data for this year and week, skip to the next iteration of the loop
    if(is.na(w)) next
    
    # Fill r with weekly rasters
    if (is.null(r)) {
      r <- weekly_sst[[w]]
    } else {
      r <- c(r, weekly_sst[[w]])
    }
    
  } # End of inner for-loop
  
  # Create standard deviation raster from week raster stack
  terra::app(r,
             fun = "sd",
             na.rm = TRUE,
             filename = file.path(dir_rasters, "weekly_sd_30yr_rasters", sprintf("sst_sd_week_%s.tif", i)),
             overwrite=TRUE,
             cores = 3) # Adjust the cores
  
  # End timer and calculate elapsed time
  end_time <- Sys.time()
  elapsed_time <- end_time - start_time
  
  # Print time message
  print(paste("anom_threshold for week", i, "started at", start_time, "and took", elapsed_time, "minutes to complete"))
  
  # Garbage collection to free up memory
  gc()
  
} # End of outer for-loop


