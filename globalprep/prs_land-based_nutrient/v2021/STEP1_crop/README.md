# Crop Nutrient
For this OHI layer we map nutrient leaching stressor. Fertilizer use data is extracted from FAOSTAT and we allocate that spatially using MapSPAM crop area raster layers, taken from the Food Systems project at NCEAS (Halpern et al. 2021; "The cumulative environmental footprint of global food production"). Ten percent of fertilizer use was assumed to have leached in the raster cell it was applied.

## Scripts

1. step0_bouwman_datasets.Rmd
 - Reads in the raw data from Bouwman et al. 2009 and preps it to match iso3c codes used in our analysis.

2. step1_fubc_2002_wrangling.Rmd
 - The FAO 2002 FUBC series provides crop specific FUBC rates, measured in kilograms per hectare, of N, P2O5, and K2O. These rates will be used to gapfill any that are not included in the 2017 rates (part 2), even though they are more specific at national levels. To gapfill missing national rates for FUBC 2002, we used the mean fertilizer rate using the smallest regional mean or adopting the next largest regional mean if the smaller region had no data 

3. step2a_fubc_2017_wrangling.Rmd
 - FUBC rates for 2014/15 were extracted from Heffer et al. (2017, FUBC rates provided by request) and harmonised with our study’s crop categories. 

4. step2b_fubc_2017_grassland.Rmd
 - We allocated national fertilizer use to grasslands using 2014/15 FUBC percentages, similar to what we did in step 2a.

5. step2c_crop_matching_tbl.Rmd
 - Make a table which outlines codes for the different types of crops represented in the FAOSTAT database and the Bouwman datasets.

6. step3_fao_production_wrangling.Rmd
 - The Fertilizers by Nutrient dataset contains information on the totals in nutrients for Production, Trade and Agriculture Use of inorganic (chemical or mineral) fertilizers, over the time series 1961-present. The data are provided for the three primary plant nutrients: nitrogen (N), phosphorus (expressed as P2O5) and potassium (expressed as K2O). Both straight and compound fertilizers are included. Prep these data for years 2005-2019.

7. step4_fubc_merge.Rmd
 - Merge the FAOSTAT data with the Bouwman and FUBC datasets

8. step5_crop_nutrient_mapping.Rmd
 - Map yearly nutrient leaching from crops using static crop farming location rasters taken from the Glboal Food Project : https://github.com/OHI-Science/food_systems/

9. step6_grazing_grassland_distribution.Rmd
 - Distribute grassland fertilizer across grazers at the country-level

10. step7_grazing_animal_grassland_nutrient_mapping.Rmd
 - Map nutrient leaching for grassland fertilizer applications.

## Folders

data
 - Contains raw data taken from Bouwman, A. F., A. H. W. Beusen, and G. Billen (2009) and from the Global Food Systems project at NCEAS (Halpern et al. 2021)

raw 
 - Contains data taken from the /data folder and prepped to be ready to used for crop nutrient mapping

int
 - Contains intermediate files that are used in the crop mapping.
 
## Outputs 
 - Raster maps for each crop category and each grassland fertilizer category for N and P leaching, volatilization, withdrawal, and denitrification. Saved to mazu. 

## Contributors
[Gage Clawson](clawson@nceas.ucsb.edu)
@gclawson1
[Paul-Eric Rayner](rayner@nceas.ucsb.edu)      
@prayner96  