# Prep nutrient rasters for plume
Here we combine all nutrient rasters and exclude any nutrient that will not reach the coast. 

## Scripts

1. STEP1_combine_all_nutrients.Rmd
 - Exactly what it sounds like. Combining all crops/manure leaching per year and all crops/manure volt per year. 
 
2. STEP2a_prep_surface_water_rasts.Rmd
 - Grabs appropriate exclusion rasters from other projects. 
 - **NOTE:** Does not need to be repeated every year. These rasters do not change. 
 
3. STEP2b_exclude_surface_water.Rmd
 - Multiplies our nutrient rasters by appropriate exclusion rasters to get estimates of N that will reach the ocean/coast. 