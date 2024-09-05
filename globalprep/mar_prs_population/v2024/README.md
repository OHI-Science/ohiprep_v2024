## Ocean Health Index: Population data

This folder describes the methods used to prepare population data used in the mariculture goal and as a proxy for the intertidal habitat destruction pressure layer. 

Find more information on dataprep [here](https://ohi-science.github.io/ohiprep_v2024/globalprep/mar_prs_population/v2024/mar_prs_pop_dataprep.html)

## Layers Created
* hd_intertidal
* mar_coastalpopn_inland25mi

## Changes from v2021 in v2024:

* The major changes from v2021 are 
  * The population data is no longer reprojected and resampled, but the eez_plus25mi_inland raster is  
    * This is to maintain the structure and values from the population raster, because they were becoming skewed by reprojection and resampling from previous assessments (especially around     projection border regions)
  * Because the population raster is not being modified, it was safer to use the population count data for zonal statistics rather than population density as there is no need to calculate cell counts from cell areas, especially with an GCS such as WGS 1984.]
  * All functions switched from raster:: package to terra::package 
    * This involved modifying custom functions to accommodate the terra package functionality 
    



The folders in this file include the metadata, R scripts, and data for each assessement year (i.e., the year the assessment was conducted).  The most current year represents the best available data and methods, and previous years are maintained for archival purposes.

Our [data managment SOP](https://rawgit.com/OHI-Science/ohiprep/master/src/dataOrganization_SOP.html) describes how we manage OHI global data, including a description of the file structure.

Please see our [citation policy](http://ohi-science.org/citation-policy/) if you use OHI data or methods.

Thank you!
