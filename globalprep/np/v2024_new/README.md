# New NP methods README (v2024)

If using these data, please see our [citation policy](http://ohi-science.org/citation-policy/).


>
⚠️
 **This folder is under construction.** Please refer to the [2024 New NP Plan: Outline and Notes](https://docs.google.com/document/d/1ubCTW7ZrvvdckvY2zpBzCLHLgoIlCLW8kDMj-KWda9U/edit?usp=sharing) created to structure v2024’s approach and inform future efforts. 

## New NP approach: Status at the end of v2024

We decided to overhaul how the NP goal is processed in v2024. Previously, there were a lot of moving parts within `ohiprep` and `ohi-global` that made it difficult to understand where each data source and layer was used and how they contributed to the overall score. In order to increase transparency and demystify the process, we consolidated the bulk of the data processing and preparation for score calculations in this directory.

Please review the NP Plan document linked above before running any of the scripts or moving on to update any scripts in this directory or `ohi-global`. Primary contact for this updated methodology: Melanie Frazier (frazier@nceas.ucsb.edu). Secondary contact: Anna Ramji (aramji@bren.ucsb.edu). 

By the end of v2024, we finished writing the new steps 1-3. Steps 4 and 5 were not completed and only contained basic YAML and setup code. Future years’ efforts should begin with reviewing the [New NP Plan document](https://docs.google.com/document/d/1ubCTW7ZrvvdckvY2zpBzCLHLgoIlCLW8kDMj-KWda9U/edit?usp=sharing), then complete steps 4 and 5. 



### Sustainability

Although the workflow was changed fairly dramatically, the analyses were mostly unchanged, with the exception that we used a different approach to incorporate sustainability into the model and no longer log-transform certain values in the ornamentals dataprep. Previously, ornamentals’ exposure and risk and seaweed sustainability were exported separately, read into `functions.R` in `ohi-global`, and used along with many other pieces and steps in and out of `ohi-global` to calculate score. In the new approach, we incorporate sustainability in our `ohiprep` processing to yield statuses for each product. For ornamentals, we use exposure and risk to calculate sustainability, which we then use to calculate relative sustainable harvest – all occurring in step 2. For seaweeds, we “calculate” (define) sustainability using Seafood Watch data to calculate relative sustainable harvest in step 3. We *do not* write out sustainability components separately to use them to calculate status in `ohi-global`’s `functions.R`. 



## Next Steps 

To continue to develop the new NP data prep process and methodology, please refer to the [2024 New NP Plan: outline and notes](https://docs.google.com/document/d/1ubCTW7ZrvvdckvY2zpBzCLHLgoIlCLW8kDMj-KWda9U/edit?usp=sharing) for a comprehensive outline of the approach and details on next steps. 

**The `functions.R` script and multiple data layer files in `ohi-global` MUST be updated in order for this new approach to work, as data layer outputs have been restructured or deleted. Please read through the [NP section of `ohi-global/eez/conf/functions.R`](https://github.com/OHI-Science/ohi-global/blob/111bc9721d43621e7624ac911e381bff36442ebd/eez/conf/functions.R#L467)**


When future fellows move on to update step 4 (fish oil/fish meal, or FOFM) data prep, it may be helpful to adapt as much of the content from the former approach’s `STEP1c_np_fishfeed_pred.Rmd` as possible. The output of that step is a “score” (please review the NP section of `functions.R`, including the [FOFM scores section](https://github.com/OHI-Science/ohi-global/blob/111bc9721d43621e7624ac911e381bff36442ebd/eez/conf/functions.R#L590). It may make more sense to name this “status”, as the status for each product (FOFM, ornamentals, and seaweeds) and their weights (based on the relative value of each product per region) are used to calculate the score. 

The score calculation will also need to be adjusted in `functions.R`, as discussed in the NP Plan document. 


Some key things to keep in mind as you consider updating this goal’s data prep process:

*	You will need to change the NP function in `ohi-global`’s `functions.R` to account for changes in how exposure and risk are handled (please look into this in-depth and consult Melanie Frazier) and the way that the data layers are now formatted.

*	You will need to update the `layers_eez_base.csv` (and all layer CSV files in the `ohi-global` [`metadata_documentation` folder](https://github.com/OHI-Science/ohi-global/tree/111bc9721d43621e7624ac911e381bff36442ebd/metadata_documentation)) with updated layers (no longer using exposure and risk separately, changing how seaweeds sustainability is handled, etc.)

*	If you decide not to adopt this new approach, the ornamentals dataprep should still be updated to fix issues with log-transforming exposure values. Please consult with Melanie Frazier for more information and refer to the [log-transforming section](https://docs.google.com/document/d/1ubCTW7ZrvvdckvY2zpBzCLHLgoIlCLW8kDMj-KWda9U/edit#heading=h.qm2oqpph6nlj) of the New NP Plan document. 



## Layers Created

*Previously:*

* Relative harvest value (np_harvest_product_weight)
* Natural product scores for ornamentals (np_ornamentals_scores)
* Ornamentals risk (np_risk_ornamentals)
* Ornamentals exposure (np_exposure_ornamentals)
* Natural product scores for fish oil and fish meal (np_fofm_scores)
* Seaweed harvest in tonnes (np_seaweed_harvest_tonnes)
* Seaweed sustainability data (np_seaweed_sust)


**Currently:**

No formal layers.


**Intended:**

* Ornamentals relative sustainable harvest (np_ornamentals_status)
* Seaweeds relative sustainable harvest (np_seaweeds_status)
* Fish oil and fish meal (FOFM) relative sustainable harvest (np_fofm_status)
* Relative harvest value (np_harvest_product_weight)


## Files:

**Steps 1 and 2 must be completed in sequential order. Steps 3 and 4 can be done in any order. Step 5 needs to be completed last. Steps 4 and 5 are incomplete.** 

Note that if a file’s details say “to be”, this may indicate (unless otherwise specified) how the file was designed to be used, but we ran out of time and did not make all of the updates to `ohi-global` and more that would be necessary to fully implement the changes in methodology and structure. 


* `step_1_np_commodities_prep.Rmd` – script for preparing data from FAO commodities sets (quantity and value), creating intermediate data used for weighting prep (step 5) and further ornamentals prep (step 2). Files of importance that are created (and associated gapfilling datasets):
	* `int/np_harvest_usd_tonnes.csv`: gapfilled `usd` and `tonnes` for all NP products based purely on FAO commodities data. 
	* `int/np_usd_per_tonne.csv`: USD per tonne per region per year per product for all three products, to be used in weighting (step 5) – ran out of time to implement this in v2024.


* `step_2_np_ornamentals_prep.Rmd` – script for calculating relative sustainable tonnes of ornamentals. Files of importance that are created (and associated gapfilling datasets): 
	* `int/np_harvest_ornamentals_tonnes.csv`: to be used in weighting (step 5).
	* `int/np_harvest_ornamentals_tonnes_usd.csv`: similar to the previous file, just includes USD as well as tonnes. Also designed to be used in weighting (step 5). 
	* `int/np_exposure_ornamentals.csv`: new exposure layer (NOT to be used separately or externally to calculate sustainability), used internally (within step 2) to calculate sustainability. 
	* `int/np_relative_sust_tonnes_ornamentals_full.csv`: saving full version (all columns) of relative sustainable tonnes of ornamentals.
	* `output/np_relative_sust_tonnes_ornamentals.csv`: to be used as ornamentals status in [`ohi-global/eez/conf/functions.R`](https://github.com/OHI-Science/ohi-global/blob/draft/eez/conf/functions.R#L548-L584). 
	


* `step_3_np_seaweeds_prep.Rmd` – seaweeds dataprep script, uses FAO Mariculture data and Seafood Watch data. MAR dataprep should be completed first. 
	* `int/np_seaweeds_tonnes_weighting.csv`: to be used in weighting (step 5)
	*`int/np_seaweed_sust.csv`: seaweed sustainability scores based on mariculture data and Seafood Watch. Not ultimately used, as there are no species-specific sustainability values for Seafood Watch seaweeds, and a value of 0.67 is used instead. This prep should be updated if Seafood Watch starts to have species-level sustainability data for seaweed species. 


* `step_4_np_fofm_prep.Rmd` – FOFM dataprep. INCOMPLETE: ran out of time to copy over old Step1c FOFM file and make appropriate changes to [`ohi-global/eez/conf/functions.R`](https://github.com/OHI-Science/ohi-global/blob/draft/eez/conf/functions.R#L548-L584), as well as all `ohi-global` files that refer to data layers and structure. FIS dataprep needs to be completed first. 
	* `int/np_fofm_tonnes_weighting.csv`: NA, did not create.
	* `int/____`: NA, did not create.
	* `output/np_fofm_status.csv`: NA, did not create. To be used as FOFM status in `ohi-global` `functions.R` linked earlier.


* `step_5_np_weighting_prep.Rmd` – Weighting dataprep. INCOMPLETE: did not finish step 4, ran out of time. Intended to contain weighting process similar to previous years’ Step 2 weighting dataprep, using “raw” tonnes data, joining them back in and multiplying by usd/tonne values calculated in new step 1.
	* `output/np_product_weights`: NA, did not create.


—-------------------------------------------------------------------------------------------------------------

### Additional information
FAO Commodities data are used to determine the Natural Products goal. FAO metadata found [here](http://ref.data.fao.org/dataset?entryId=aea93578-9b01-4448-9305-917348ca00b2&tab=metadata).

The FAO fisheries and aquaculture web page (http://www.fao.org/fishery/topic/166235/en) provides instructions on downloading and installing their FishStatJ software.  Once you've done that, then:

* From the [same web page](http://www.fao.org/fishery/topic/166235/en), under **FishStatJ available workspaces,** download the Global datasets workspace to your computer.
* Start **FishStatJ**.
* Invoke the **Tools -> Import Workspace** command.
* In the Import Workspace dialog, change the current directory to where you have downloaded the workspace(s) and select it.
* Follow the directions to import the workspace (press **Next** a couple of times then **Install Workspace**)
    * It may take a while to import the workspace. Go make a sandwich, get some coffee, drink a beer, learn a new hobby.
* Open the two data sets: *Global commodities production and trade - Quantity* and *- Value*.
    * No need to filter; the `data_prep.R` script does that.
* For each data set, select all (`ctrl-A` or `command-A`), then **Edit -> Save selection (.csv file)...**  Save as these filenames: 
        `FAO_raw_commodities_quant_[start-year]_[end-year].csv` and
        `FAO_raw_commodities_value_[start-year]_[end-year].csv`
    * **Note:** in prior years, people have reported that this may not capture all the rows in the .csv file, so make sure to double-check.
* Put the resulting files in an appropriate folder and have fun!

FAO metadata for Mariculture data are found [here](http://www.fao.org/fishery/statistics/global-aquaculture-production/en)

RAM data can be found here: [RAM Legacy Stock Assessment Database](http://ramlegacy.org) v4.491

Fisheries data can be found here: [IMAS portal](http://data.imas.utas.edu.au/portal/search?uuid=ff1274e1-c0ab-411b-a8a2-5a12eb27f2c0)

