![image](https://github.com/OHI-Science/ohiprep_v2023/assets/6896068/e2e62dc5-d552-474c-bd18-13ad57b225ab)![image](https://github.com/OHI-Science/ohiprep_v2023/assets/6896068/04c34968-b4b9-4e0b-80e0-ae21cec03ed0)## Ocean Health Index: Lasting Special Places (LSP)

See full data prep details [here](http://ohi-science.github.io/ohiprep_v2022/globalprep/lsp/v2022/lsp_data_prep.html).

If using these data, please see our [citation policy](http://ohi-science.org/citation-policy/).

### Layers Created

-   Coastal protected marine areas (fishing preservation) (fp_mpa_coast)
-   EEZ protected marine areas (fishing preservation) (fp_mpa_eez)
-   Coastal protected marine areas (habitat preservation) (hd_mpa_coast)
-   EEZ protected marine areas (habitat preservation) (hd_mpa_eez)
-   Inland coastal protected areas (lsp_prot_area_inland1km)
-   Offshore coastal protected areas (lsp_prot_area_offshore3nm)
-   Inland area (rgn_area_inland1km)
-   Offshore area (rgn_area_offshore3nm)

### Prep Files

-   `1_prep_wdpa_rast.Rmd` converts the raw WDPA data into raster
-   `lsp_data_prep.Rmd` prepares the raster so it's ready for processing into the ohi-global toolbox. Any gapfilling and resilience calculation is completed here as well.

### Data Check Files

-   `check_updates.Rmd` is a script for additional data checking of score changes from last year's assessment

## Methods

## Downloading Data

Accessing and downloading the data was difficult in 2023 due to a downloading bug, luckly there are multiple ways to download the data from the webpage. The below directions sound easy; but it is easy to be navigated to a page where the download functionality is broken.

Directions to download data:

1: Link to specific website: <https://www.protectedplanet.net/en/thematic-areas/wdpa?tab=WDPA>

2: Select the download button in the top right hand corner.

3: Download and unzip the file

4: There will be additional zip files within the zip file you download. Once unzipped, these are the three files you will use throughout the LSP dataprep.

### Filter and re-project WDPA polygons

The WDPA-MPA dataset comes as a shapefile or geodatabase in WGS84 coordinate reference system.

-   For OHI we have chosen to count only protected areas with defined legal protection, so we apply a filter on the STATUS attribute that selects only STATUS == "Designated".
    -   According to the WDPA Manual: STATUS as "Designated" means: "Is recognized or dedicated through legal means. Implies specific binding commitment to conservation in the long term. Applicable to government and non-government sources."
    -   Other values for STATUS include "Proposed", "Adopted", "Inscribed", or "Not Reported" and "Established".
        -   "Adopted" and "Inscribed" are World Heritage or Barcelona Convention sites; while these may seem important, they are generally protected by other means (as overlapping "Designated" polygons) in addition to these values.
-   In 2015, the USA started including polygons that represent marine management plans, in addition to more strictly defined protected areas. This info is contained in the "MANG_PLAN" field.
    -   These programmatic management plans variously protect species, habitats, and (??) and can be MPA or non-MPA.
    -   For OHI we have chosen to count only MPA programmatic management plans, omitting Non-MPA programmatic management plans.
-   For ease of tallying areas, we convert the polygons to a Mollweide equal-area projection before rasterizing.

Once the polygons have been prepped, we rasterize the results to 500 m resolution.

This process is all done in the script: `1_prep_wdpa_rast.Rmd`. After that is complete, move on to computing zonal statistics.

## Note: Updating Scores

As with all datapreps, the .csv files in the output folder are grabbed by the functions in the calculate_scores.Rmd to update the OHI scores for the year. This data layer creates 6 different .csv files with 8 different associated layers that are used for score calculation. 

This is a list of the .csv files created and their associated layer:
-   mpa_eez_resilience.csv - fp_mpa_eez, hd_mpa_eez
-   mpa_3nm_resilience.csv - fp_mpa_coast, hd_mpa_coast
-   lsp_prot_area_inland1km.csv - lsp_prot_area_inland1km
-   lsp_prot_area_offshore3nm.csv - lsp_prot_area_offshore3nm
-   rgn_area_inland1km.csv - rgn_area_inland1km
-   rgn_area_offshore3nm.csv - rgn_area_offshore3nm

To be sure, this is a tricky OHI score update. Be sure all the layer years are updated in the scenario_data_years.csv. The "rgn_area_inland1km.csv - rgn_area_inland1km" and the "rgn_area_offshore3nm.csv - rgn_area_offshore3nm", as you can imagine, are the same each year and remains static and unupdated. They are not present as layers in the scenario_data_years.csv file. There are also multiple places to update in the layers_eez_base.csv, luckely all of them have the same file path with the "lsp" folder so you can use this to search the .csv file.


