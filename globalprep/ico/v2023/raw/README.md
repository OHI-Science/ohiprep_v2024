## IUCN Data

Data for generation the following layers comes from the IUNC. Additional information on how raw data layers are prepared using this data can be found in the ico_data_prep file.   

**List of iconic species:**

**Species native country information:**

* __Reference__: 
    * IUCN 2020. IUCN Red List of Threatened Species. Version 2020-1 <www.iucnredlist.org>
        * __Accessed__: 6 May 2020 
* __Native data resolution__: Country level (by country name)
* __Time range__: 1965-2020 (discrete past assessments by species) 
* __Format__:  JSON

## Raw data files:
The following raw data files are generated using the above IUCN data:  

 * spp_list_from_api: the full IUCN species list accessed from the IUCN API
 * ico_spp_countries: a list of countries in which each species identified as globally or regionally iconic (in the ico_list_raw file) is found 