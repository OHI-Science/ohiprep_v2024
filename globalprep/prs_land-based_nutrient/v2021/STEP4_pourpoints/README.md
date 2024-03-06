# Prep shapefiles for plume run 
 

## Files

1. STEP1_pourpoints_prep.Rmd
 - Create shapefiles of N nutrient aggregate to each pourpoint. 
 
2. STEP2_ocean_mask_prep.Rmd
 - Creates a 1km inland ocean mask to feed into the plume model.
 
3. STEP3_fix_pourpoints.Rmd
 - Fixes pourpoints which were being masked out by the ocean mask in the plume model. 
 

/archive contains scripts which will mosaic together separate runs from the same year, or filter out already plumed files from the final effluent shapefile, so that you can start the plume model from where you left off (if you stopped it in the middle).



## Contributors
[Gage Clawson](clawson@nceas.ucsb.edu)
@gclawson1