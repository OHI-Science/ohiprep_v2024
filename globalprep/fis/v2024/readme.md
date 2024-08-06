## Ocean Health Index: Fisheries Sub-goal (FIS)

See full details for how the SAUP catch data was prepped [here](http://ohi-science.github.io/ohiprep_v2023/globalprep/fis/v2023/STEP2a_saup_catch_prep.html).

See full details for how BBmsy was calculated [here](http://ohi-science.github.io/ohiprep_v2023/globalprep/fis/v2023/STEP3_calculate_bbmsy.html).

See full details for how RAM data was prepped
[here RAM dataprep](http://ohi-science.github.io/ohiprep_v2023/globalprep/fis/v2023/STEP4a_RAM_data_prep.html)
[here RAM_CMSY](http://ohi-science.github.io/ohiprep_v2023/globalprep/fis/v2023/STEP5_RAM_CMSY_combine.html)


If using these data, please see our [citation policy](https://oceanhealthindex.org/global-scores/data-download/).

### Layers Created

* B/Bmsy estimates (fis_b_bmsy)
* Fishery catch data (fis_meancatch)

### Additional information
A description of files:

* STEP1_download_saup_match_fao_data.Rmd: This script downloads the SAUP production data from their API, and matches their regions to the appropriate FAO fishing regions.

* STEP2a_saup_catch_prep.Rmd: Preps the spatialized catch data (at half degree cells) for use in goal weighting and stock status calculations. Auxiliary prep file, **STEP2b_species_resilience_lookup_table.Rmd**: Uses FishBase to find the Resilience for each of the species in the SAUP database. The Resilience information is needed for running catch-MSY to estimate B/Bmsy. Outputs:
  
   - `git-annex/globalprep/fis/v2022/int/stock_catch_by_rgn.csv`
   - `int/taxon_key_v2022.csv`
   - `output/stock_catch.csv`
   - `output/mean_catch.csv`
   - `output/FP_fis_catch.csv`
   - `output/taxon_resilience_lookup.csv`
   - `output/mean_catch_minus_feed.csv`
   - `output/stock_catch_no_res.csv`
   

* STEP3_calculate_bbmsy.Rmd: Calculates B/Bmsy estimates for all stocks using catch-MSY (CMSY) developed by Martell and Froese (2012). Outputs:
  
  - `output/cmsy_bbmsy.csv`
   
    
* STEP4a_RAM_data_prep.Rmd: Prepares the RAM B/Bmsy data by gapfilling RAM data and identifying which FAO/OHI regions each RAM stock is present. Auxiliary prep file, **STEP4b_fao_ohi_rgns.Rmd**: adds FAO and OHI region IDs to newly added stocks with no spatial information (creates `int/RAM_fao_ohi_rgns.csv`). Outputs:

  - `int/ram_stock_bmsy_gf.csv`
  - `int/RAM_fao_ohi_rgns.csv`
  - `int/ram_bmsy.csv`


* STEP5_RAM_CMSY_combine.Rmd: Combines the B/Bmsy values from the RAM and CMSY data, with preference given to RAM data.
 
   - `int/cmsy_b_bmsy_mean5yrs.csv`
   - `output/fis_bbmsy_gf.csv`
   - `output/fis_bbmsy.csv`


A description of data check files:

* data_check.Rmd: Checks data discrepancies after completing data preparation scripts. All the files in `datacheck` folder are created in this script.


* check_scores.R: Checks discrepancies in scores after adding FIS layers to ohi-global