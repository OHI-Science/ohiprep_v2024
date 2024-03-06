# Land based agriculture nutrient pollution (manure and crops)

For this OHI layer we map nutrient leaching stressor from manure and crops. Fertilizer use data is extracted from FAOSTAT and we allocate that spatially using MapSPAM crop area raster layers, taken from the Food Systems project at NCEAS (Halpern et al. 2021 in review; "The cumulative environmental footprint of global food production"). Further, manure application from agriculture animals is extract FAOstat and we allocate that using animal farm area raster layers, taken from the Food Systems project at NCEAS (Halpern et al. 2021 in review; "The cumulative environmental footprint of global food production"). Once these maps are created, we aggregate the nutrients to the pourpoints, and run them through the plume diffusion model so that the nutrients are spread into the ocean. 

Code in crop and manure folders adapted from, some files taken from: 
Halpern et al. 2021 github: https://github.com/OHI-Science/food_systems

## Folders

1. STEP1_crop
   - This folder contains all scripts to map nutrient pollution from crop agriculture. We create files for leaching, volatilization, denitrification, and withdrawal for N and P nutrients. See README within the folder for further instructions. 
   
2. STEP2_manure
   - Similarly, this folder contains all scripts to map nutrient pollution from animal manure. We create files for leaching, volatilization, denitrification, and withdrawal for N and P nutrients. See README within the folder for further instructions. 

3. STEP3_compile_prep_layers
   - This folder contains scripts which combine the the manure and crop nutrient layers for leaching and volatilization. To do this, we first exclude any leaching nutrients that are more than 1km away from surface waters or coasts, and we exclude any volatized nutrients that are not directly applied on surface waters. 

4. STEP4_pourpoints
   - This folder contains scripts which aggregate the nutrients from manure and crops to watersheds, and eventually to the pourpoint into the ocean from each watershed. We also adjust the ocean mask which is used in the plume model. 

5. STEP5_plumes 
   - This folder contains scripts and instructions for how to run the plume model on each nutrient layer. This is a very complicated process, so looking at past issues, the [wastewater project](https://github.com/OHI-Science/wastewater) at NCEAS is highly recommended. The output from this process are rasters which show the crop and manure leaching and volatized N nutrients plumed into the ocean from each pourpoint. 1 global tif file (~90k coastal pourpoints) will likely take ~24 hours to run completely. 



## Contributors
[Gage Clawson](clawson@nceas.ucsb.edu)
@gclawson1