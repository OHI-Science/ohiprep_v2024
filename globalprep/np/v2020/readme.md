## Ocean Health Index: Natural products (NP)


If using these data, please see our [citation policy](http://ohi-science.org/citation-policy/).

[alternatively, if you want a specific citation for this resource, you can add that here....]


### Layers Created

* Relative harvest value (np_harvest_product_weight)
* Natural product scores for ornamentals (np_ornamentals_scores)
* Ornamentals risk (np_risk_ornamentals)
* Ornamentals exposure (np_exposure_ornamentals)
* Natural product scores for fish oil and fish meal (np_fofm_scores)
* Seaweed harvest in tonnes (np_seaweed_harvest_tonnes)
* Seaweed sustainability data (np_seaweed_sust)


### Files: 
* np_ornamentals_prep.Rmd - script for preparing the ornamentals data, as well as the intermediate data used in the weighting prep. Files of importance that are created (and associated gapfilling datasets): 
    * int/np_harvest_tonnes_usd.csv
    * output/np_ornamentals_harvest_tonnes_rel.csv
    * output/np_risk_ornamentals.csv
    * output/np_exposure_orenamentals.csv
* np_seaweeds_prep.Rmd - script for preparing the seaweeds data. Files of importance that are created (and associated gapfilling datasets): 
    * int/np_seaweeds_tonnes_weighting.csv
    * output/np_seaweed_harvest_tonnes.csv 
    * output/np_seaweed_sust.csv
* np_fishfeed_pred.Rmd - script for preparing the FOFM data. Files of importance that are created (and associated gapfilling datasets): 
    * int/mean_catch_FOFM.csv 
    * output/np_fofm_scores.csv
* np_weighting_prep - script for preparing weighting scheme for ohi global. Files of importance that are created (and associated gapfilling datasets): 
    * output/np_product_weights.csv


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

FAO metadata for Mariculte data are found [here](http://www.fao.org/fishery/statistics/global-aquaculture-production/en)

RAM data can be found here: [RAM Legacy Stock Assessment Database](http://ramlegacy.org) v4.491

Fisheries data can be found here: [IMAS portal](http://data.imas.utas.edu.au/portal/search?uuid=ff1274e1-c0ab-411b-a8a2-5a12eb27f2c0)