# Ocean Health Index: Sea Surface Temperature Pressure

See full data prep details [here](http://ohi-science.github.io/ohiprep_v2022/globalprep/prs_sst/v2023/sst_layer_prep.html).

If using these data, please see our [citation policy](http://ohi-science.org/citation-policy/).

## PRS_SST Data Layer

### **Step 1:** **To full update or not to full update**

-   Investigate status of SST and SSTA Data. CoRTAD, the origin of the data, updates their data set every year with an addtional year of data. This does not mean that the user needs to update all the rasters involved in the calculation for prs_sst, it only means that the newest year of data needs to be incorporated into the current raster files. However, if the historical data is changed, then all rasters must be recalculated.\
    \
    Link to data: [CoRTAD version 6](https://www.ncei.noaa.gov/products/coral-reef-temperature-anomaly-database)\
    \
    Has the historical data been updated since the last update year found in:\
    <sftp://mazu.nceas.ucsb.edu/home/shares/ohi/git-annex/globalprep/prs_sst/prs_sst_calculated_rasters>\
    \
    The current last update year was 2023.

### **Step 2 (a):** **Not full update**

-   If the historical CoRTAD data stayed the same, create a new scenario year folder like normally done for new data layers:\
    <sftp://mazu.nceas.ucsb.edu/home/shares/ohi/git-annex/globalprep/prs_sst> /vscenarioyear

-   Use the sst_layer_prep to update the layer rasters with the most recent year of data and complete the data prep!

### **Step 2 (b):** **Full update**

-   If the historical CoRTAD has been updated, create a new update year in this folder path:\
    <sftp://mazu.nceas.ucsb.edu/home/shares/ohi/git-annex/globalprep/prs_sst/prs_sst_calculated_rasters> /vscenatioyear_update

-   Create a new scenario year folder like normally done for new data layers:\
    <sftp://mazu.nceas.ucsb.edu/home/shares/ohi/git-annex/globalprep/prs_sst> /vscenarioyear

-   Use the "full_update_notebooks" folder to update all the rasters for the prs_sst data layer. Once complete, come back and use the sst_layer_prep to finish the data layer.

## 2023 Update:

By: Carlo Broderick

In 2023, there was a significant update to this data layer.

Previously, to update this data layer required recalculating \~100+ rasters starting with a the SST and SSTA dataset of around 60gb in size. This process took multiple over night computation sessions and was originally done with the raster package. In 2023, Carlo Broderick updated this data layer in three main ways: transitioned to terra package, changed the raster calcultion workflow, and integrated the use of background jobs into the recalculation process.

**Terra Package:**

-   This updated simple transitioned the code from the use of the raster package to the use of the terra package for raster geocomputation. For this most part, this update did not change the structure or the outcomes of the calculation process; however, as raster is retiered and terra is becoming the new standard package for R raster management, there may be room for improvement. The current terra functionality can be clunky and some work arounds were needed to have its functionality paralell the previous process.

**Raster Calculation Workflow Update:**

-   This update is the most significant. Historically we would redo all raster calculations each year by adding the new year of data to the calculations. This process started by recalculating the SST SD for each week in the data set with the newest year included. The update made in 2023 changed this workflow to only calculate the SD for the weekly SST for the first 30 years of the data set. This SD calculation will continue to be used for years to come and save them the time of recalculating the SD every year. This change was made not only because it saved computational power, but because it also made more sense to have a static SD to use as a threshold for identifying SST anomalies. Once the SD is calculated, all the other rasters can also be saved and used over again the next year so the only new rasters that need to be created are the ones associated with this most recent year's data. This makes the computation required to complete this data prep at least 2 orders of magnitude smaller than before.

-   The underlying data set does not change from year to year, so the SD calculation can be used as long as the historical data does not change. If the historical data does change, the entire set of rasters need to be recalculated.

**Background Jobs:**

-   If all rasters need to be updated because of an underlying change in the SST and SSTA data then users will be guided towards using the "full_update_notebooks" these notebooks are a step by step process to recalculate all the rasters needed for this data prep. Some of these calculations can take longer than a working day to complete. The length of these calculations required and update to the compute management process. The use of background jobs was implemented to allow users to continue working on the server and using their console while these processes ran in the background. To use background jobs, users must create a self contained r script that can execute by itself. These scripts have already been created and can be found in the "full_update_notebooks" folder. Each script corresponds to a rmd. Either can be used; however, the scripts allow for the use of background jobs and lower the time and compute burden on the updater.
