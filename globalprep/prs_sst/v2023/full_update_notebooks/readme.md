# Full Update

This readme details the process for updating the entire sst_data layer. This is not needed every year. The majority of calculations and raster files have already been done for you and the only work that needs to be done is calculating the new year's data.

Each year CoRTAD adds a new new year of data to their data set, this new year of data does not require that we update all the raster files that prs_sst scores are based on. Only if the historical CoRTAD SST data is updated should all the raster files and calculations be redone.

To know if historical CoRTAD data has been updated, you can check to see if there is a new version on their website: <https://www.ncei.noaa.gov/products/coral-reef-temperature-anomaly-database>

# Full Update Workflow

**Step 1:\
**Validate that the historical data has indeed been updated and that new rasters must be created.

**Step 2:\
**Create a new "calculated_rasters" folder, the last update was done in v2023.\
<sftp://mazu.nceas.ucsb.edu/home/shares/ohi/git-annex/globalprep/prs_sst/prs_sst_calculated_rasters>\
This folder should contain all the same subfolders (but empty) as the v2023 version.

**Step 3:**\
Run through the Full Update Notebooks (guidance below)

**Step 4:**\
Return to the main scenario year folder and work through the sst_layer_prep.rmd notebook

# Full Update Notebooks

### When to use these notebooks

The three files in this folder should only be used if the Coral Reef Temperature Anomaly Database (CoRTAD) historical data has been updated. Each year CoRTAD adds a new new year of data to their data set, this new year of data does not require that we update all the raster files that prs_sst scores are based on. Only if the historical CoRTAD SST data is updated should all the raster files and calculations be redone.

To know if historical CoRTAD data has been updated, you can check to see if there is a new version on their website: <https://www.ncei.noaa.gov/products/coral-reef-temperature-anomaly-database>

In 2023 we used version 6. If the data has not been changed you can return to the main folder and execute the sst_layer_prep_rmd and breath a sigh of relief. If the data has been updated, please continue reading below.

### How to use these notebooks

So, the CoRTAD data has been updated. Not to worry! Use the three notebooks in this folder to update all the raster files that the prs_sst data layer requires. The notebooks are in order denoted by their first letter: a, b, and c.

### Notebooks

-   (a)\_sst_sd.rmd -- \
    This notebook takes the weekly sst values from 1982 to present and calculates the standard deviation for each cell accross all years for each week of the year. This process creates 53 with on layer and values representing the standard deviation for that cell for that week of the year.

-   (b)\_annual_sst_anom.rmd -- \
    This notebook takes the 53 sd rasters created in the previous notebook and runs them over the SSTA (Sea Surface Temperature Anomaly) raster for each week of the year for each year. We classify a sea surface temperature that is 1 standard deviation above the mean as a "positive sea surface temperature anomaly," and that is what we are here to calculate! The SSTA raster contain weekly sea surface temperatures with the climatic mean subtracted from them, so if a cell value for a specific week is above the sd value for that same cell in that same week, we identify that as an anomaly. This notebook then adds up all the anomalies in each cell for the entire year and spits out one raster for each year in the data set that represents the cumulative number of positive sea surface temperature anomalies for that cell for that year. The maximum value for any cell would be 53, and would signify that all 53 weeks of that year had sea surface temperatures above the sd for that cell for that year.

-   (c)\_5yr_surplus_anom.rmd -- \
    This notebook takes all the previously created annual positive anomaly rasters and groups them into 5 year sums. We use the reference period of 1985 - 1989 and use it to find positive anomalies above the reference period anomalies for each other 5 year period starting from 1986-1990 and going to the most recent 5 year period. This process created a number of rasters equal to 3 minus the number of years in the data set because we do not use 1982-1984 in this calculation due to non-representative weather anomalies during that period. Each raster has a single layer and each cell represents the excess positive anomalies that occurred in that cell over that 5 year period when compared to the 1985 - 1989 reference period.

### Completing the notebooks

After you complete the three notebooks above, you may return to the main prs_sst scenario year folder an use the sst_layer_prep.rmd to complete the prs_sst dataprep. There you will calculate a new 99.99th percentile value for excess posative anomalies and use it to rescale all values to between 0 and 1. Then you will overlay filters and masks to remove uneeded areas and associate the raster values with the OHI reagions. Then you will take the average value in each OHI reagion and use that to generate OHI SST pressure values!

### Background Jobs

Bad news, the processes in the above notebooks can take multiple hours to run, good news, using Terra, code optimization and r scripts they are much faster than they used to be and they can also be run as "background jobs." Running a process as a background job allows you to continue working on other things (like other data preps) while the long process is running. To make a process a background job, the process has to be self contained in a R script. Once you have an R script you can navigate to the "Background Jobs" tab (usually to the right of the terminal) and start a new background job. The output of the process will be put into the "Background Jobs Tab" just like a terminal. Importantly, the best way to use background jobs is to have everything read in and saved out to disk to allow for the process to run by itself.
