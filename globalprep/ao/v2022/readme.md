## Ocean Health Index: Artisanal opportunities goal

Information about calculation of [need component](http://ohi-science.github.io/ohiprep_v2022/globalprep/ao/v2022/ao_need_data_prep.html).

Information about [opportunity component](http://ohi-science.github.io/ohiprep_v2022/globalprep/ao/v2022/ao_access_data_prep.html).

Information about [stock status component](http://ohi-science.github.io/ohiprep_v2022/globalprep/ao/v2022/ao_stock_status_saup.html).

Information about [stock status (catch) component](http://ohi-science.github.io/ohiprep_v2022/globalprep/ao/v2022/ao_catch_prep_saup.html).

http://ohi-science.github.io/ohiprep_v2022/globalprep/prs_uv/v2022/uv_dataprep.html

### Layers Created

* ao_need
* ao_access
* ao_stock_status/ao_stock_catch

### Additional information
A description of files (1 and 2 need to be done in order, the rest it does not matter):

1. ao_catch_prep.Rmd: Preps the spatialized catch data (at half degree cells) for use in stock status calculations. Outputs:
  
   - `git-annex/globalprep/ao/v2022/int/ao_stock_catch_by_rgn.csv`
   - `intermediate/watson_taxon_key_v2022_a0.csv`
   - `intermediate/mean_catch.csv`


2. ao_stock_status.Rmd: Filters the prepped RAM data from the FIS subgoal to the non-industrial catch prepped in ao_catch_prep. Outputs:
  
  - `output/ao_nind_scores.csv`
   
    
3. ao_access_data_prep.Rmd: Generates the "access" layer for the artisanal opportunities goal. This prep uses the UN sustainable development goal 14.b.1. Outputs: 
 - `sdg_14_b_1_ao.csv`
 

4. ao_need_data_prep.Rmd: This script generates the "need" layer for the artisanal opportunities goal. Outputs:
 - `gdppcppp_ohi.csv`
 - `wb_gdppcppp_rescaled.csv`



If using these data, please see our [citation policy](http://ohi-science.org/citation-policy/).



  
