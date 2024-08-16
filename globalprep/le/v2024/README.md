# Status of Livelihoods and Economies Update

## Acronyms for sectors used in the original output layers:

| Sector                                                   | Acronym |
|----------------------------------------------------------|---------|
| Fishing (formerly commercial fishing)                    | cf      |
| Mariculture                                              | mar     |
| Tourism                                                  | tour    |
| Ports and Harbors                                        | ph      |
| Ship and Boat Building                                   | sb      |
| Aquarium Fishing                                         | aqf     |
| Transportation and Shipping                              | tran    |
| Marine Mammal Watching                                   | mmw     |
| Ocean Energy (formerly wave and tidal energy)            | wte     |
| Fish processing (not formerly included)                  | fp      |
| ? (unclear what this is, only in original revenue files) | og      |

In 2024 we cleaned and prepped the best available data for most sectors and components included in this goal. The ECO subgoal was pursued, but LIV was tabled due to a lack of data in the fishing (cf) and tourism (tour) sectors. When newly updated data wasn't available, we re-downloaded and cleaned the previous data source. If needed to refer to, ohiprep_v2024 in v2023 contains all scripts and data produced during the 2023 fellows' deep dive. All of the v2024 cleaned files are now saved in the folder `~/ohiprep_v2024/globalprep/le/v2024/int` .

### v2023 updates

Detailed methods and explanations for v2023's work are available in the livelihoods_economies_dataprep.RMD saved in `~/ohiprep_v2023/globalprep/le/v2023`. Included below is a summary of what tasks were completed in the 2023 methods update.

For all datasets, except tourism revenue, the current format has one value for each country and year included in the dataset. Tourism uses a pre-cleaned version of the revenue data, so countries have already been converted to regions. We did not do any gapfilling to fill in countries missing from the cleaned data sets, so this will likely need to be done for most of the included data.

Acronyms for sectors used in the original output layers are used for simplicity of incorporating into the finalized OHI model. A new sector fish processing FP was added in this analysis, and will need to be incorporated into the model.

### v2024 updates

This year we decided to revamp both the LIV and ECO subgoals within LE for as many sectors as we could. The main sectors we decided to tackle were tourism (tour), mariculture (mar), and commercial fishing (cf), due to higher prevalence of data.

#### Livelihoods (LIV)

We started with LIV, which included both the number and quality of jobs within a sector. The scripts used were:

-   `liv_cf_jobs_prep.Rmd`
    -   Commercial fishing number of jobs (employment)
-   `liv_cf_quality_prep.Rmd`
    -   Commercial fishing quality of jobs (wages)
-   `liv_mar_jobs_prep.Rmd`
    -   Mariculture number of jobs (employment)
-   `liv_tour_dataprep.Rmd`
    -   Tourism number and quality of jobs
-   `fp_dataprep.Rmd`
    -   Fish Processing: Proportion of Jobs per Country per Year (2019-2021)
-   `liv_labor_force_dataprep.Rmd`
    -   Proportion of Tourism Jobs per Country/Region per Year, data from World Bank
    -   saves as liv_labor_force.csv

We are currently shelving LIV because it has been difficult to find data on the number of jobs for the tourism sector, as well as find their wages to infer some reference point of quality compared to quantity. For quality within the cf sector, ILOSTAT was the best we could find at the time, but it was complied from many data sources and had only 32 unique geo areas with data. An iteration of this issue was present in almost every sector, solidifying our decision to focus on the ECO subgoal.

#### Economies (ECO)

This subgoal was more successful in obtaining data, and may produce scores for the v2024 Assessment.

-   `aqf_dataprep.Rmd`
    -   Aquarium Fishing Revenue per Country per Year (2019-2021) --DROPPED due to lack of data
-   `eco_mar_prep.Rmd`
    -   Mariculture Revenue Data (1984 - 2022)
-   `eco_cf_prep.Rmd`
    -   USD Value of Marine (Commercial) Fishing per Country/Region per Year (1976-2019)
-   `eco_tour_prep.Rmd`
    -   Tourism Revenue in USD per Country per Year (2008 - 2019)
-   `eco_usd_adj.Rmd`
    -   Adjusting Economies data by Sector for Inflation

The individual LE::ECO scripts from other sectors will all be adjusted for inflation within `eco_usd_adj.Rmd`. After, they will be combined into one data frame. Finally, the values will be aggregated by region and year across all sectors, which can then be used to calculate the final score.

Initially, there are three scripts, each with different starting units of value, shown below:

#### Adjustment Units Pre/Post-Inflation

+---------------------+-----------------------------------------------------------------------+------------------------------------+--------------------------------+
|                     | Metadata documentation                                                | Pre-Adjustment Unit                | Post-Adjustment Unit           |
+---------------------+-----------------------------------------------------------------------+------------------------------------+--------------------------------+
| cf                  | [FAO Capture Data](https://www.fao.org/fishery/en/collection/capture) | Final: USD (current year)          | USD inflation adjusted to 2017 |
|                     |                                                                       |                                    |                                |
| `eco_cf_prep.Rmd`   | [Ex-Vessel Price Data](https://github.com/SFG-UCSB/price-db-sfg)      | FAO Capture: tonnes                |                                |
|                     |                                                                       |                                    |                                |
|                     |                                                                       | Ex-Vessel Prices: USD/metric tonne |                                |
+---------------------+-----------------------------------------------------------------------+------------------------------------+--------------------------------+
| tour                |                                                                       | USD (constant 2015 US\$)           | USD inflation adjusted to 2017 |
|                     |                                                                       |                                    |                                |
| `eco_tour_prep.Rmd` |                                                                       |                                    |                                |
+---------------------+-----------------------------------------------------------------------+------------------------------------+--------------------------------+
| mar                 |                                                                       | USD (current year)                 | USD inflation adjusted to 2017 |
|                     |                                                                       |                                    |                                |
| `eco_mar_prep.Rmd`  |                                                                       |                                    |                                |
+---------------------+-----------------------------------------------------------------------+------------------------------------+--------------------------------+

## **Data sources**

#### Livelihoods (LIV)

-   `liv_cf_jobs_prep.Rmd`

    -   Commercial fishing number of jobs (employment)
    -   Labor Force & Employment Data
        -   Labor Force data from World Bank (downloaded June 28. 2024)
            -   <https://data.worldbank.org/indicator/SL.TLF.TOTL.IN>
        -   OECD (Employment in fisheries, aquaculture and processing, 2009 - 2021) (downloaded July 2, 2024) -- for cf job data
            -   [https://data-explorer.oecd.org/vis?fs[0]=Topic%2C1%7CAgriculture%20and%20fisheries%23AGR%23%7CFisheries%20and%20aquaculture%23AGR_FSA%23&pg=0&fc=Topic&bp=true&snb=6&vw=ov&df[ds]=dsDisseminateFinalDMZ&df[id]=DSD_FISH_EMP%40DF_FISH_EMPL&df[ag]=OECD.TAD.ARP&df[vs]=1.0&dq=.A....\_T.\_T&pd=2009%2C&to[TIME_PERIOD]=false&ly[cl]=TIME_PERIOD&ly[rs]=REF_AREA&ly[rw]=DOMAIN](https://data-explorer.oecd.org/vis?fs%5B0%5D=Topic%2C1%7CAgriculture%20and%20fisheries%23AGR%23%7CFisheries%20and%20aquaculture%23AGR_FSA%23&pg=0&fc=Topic&bp=true&snb=6&vw=ov&df%5Bds%5D=dsDisseminateFinalDMZ&df%5Bid%5D=DSD_FISH_EMP%40DF_FISH_EMPL&df%5Bag%5D=OECD.TAD.ARP&df%5Bvs%5D=1.0&dq=.A...._T._T&pd=2009%2C&to%5BTIME_PERIOD%5D=false&ly%5Bcl%5D=TIME_PERIOD&ly%5Brs%5D=REF_AREA&ly%5Brw%5D=DOMAIN){.uri}
        -   FAO Yearbook (downloaded July 2, 2024) -- for cf job gapfilling if needed
            -   <https://openknowledge.fao.org/server/api/core/bitstreams/2be6c2fa-07b1-429d-91c5-80d3d1af46a6/content>
        -   ILOSTAT (downloaded July 2, 2024) -- for cf wage data
            -   <https://rshiny.ilo.org/dataexplorer46/?lang=en&id=EAR_4MTH_SEX_ECO_CUR_NB_A>
            -   select Rev 3.1.B: Fishing

-   `liv_cf_quality_prep.Rmd`

    -   Commercial fishing quality of jobs (wages)
    -   Labor Force & Employment Data
        -   Labor Force data from World Bank (downloaded June 28. 2024)

            -   <https://data.worldbank.org/indicator/SL.TLF.TOTL.IN>

        -   OECD (Employment in fisheries, aquaculture and processing, 2009 - 2021) (downloaded July 2, 2024) -- for cf job data

            -   [https://data-explorer.oecd.org/vis?fs[0]=Topic%2C1%7CAgriculture%20and%20fisheries%23AGR%23%7CFisheries%20and%20aquaculture%23AGR_FSA%23&pg=0&fc=Topic&bp=true&snb=6&vw=ov&df[ds]=dsDisseminateFinalDMZ&df[id]=DSD_FISH_EMP%40DF_FISH_EMPL&df[ag]=OECD.TAD.ARP&df[vs]=1.0&dq=.A....\_T.\_T&pd=2009%2C&to[TIME_PERIOD]=false&ly[cl]=TIME_PERIOD&ly[rs]=REF_AREA&ly[rw]=DOMAIN](https://data-explorer.oecd.org/vis?fs%5B0%5D=Topic%2C1%7CAgriculture%20and%20fisheries%23AGR%23%7CFisheries%20and%20aquaculture%23AGR_FSA%23&pg=0&fc=Topic&bp=true&snb=6&vw=ov&df%5Bds%5D=dsDisseminateFinalDMZ&df%5Bid%5D=DSD_FISH_EMP%40DF_FISH_EMPL&df%5Bag%5D=OECD.TAD.ARP&df%5Bvs%5D=1.0&dq=.A...._T._T&pd=2009%2C&to%5BTIME_PERIOD%5D=false&ly%5Bcl%5D=TIME_PERIOD&ly%5Brs%5D=REF_AREA&ly%5Brw%5D=DOMAIN){.uri}

        -   FAO Yearbook (downloaded July 2, 2024) -- for cf job gapfilling if needed

            -   <https://openknowledge.fao.org/server/api/core/bitstreams/2be6c2fa-07b1-429d-91c5-80d3d1af46a6/content>

        -   OECD and FAO joint collection data (1995 - 2022) from Fabiana Cerasa (OECD) and Orsolya Mikecz (FAO)

            -   `/home/shares/ohi/git-annex/globalprep/_raw_data/OECD_FAO_joint_collection/d2024`

            -   Data was provided by email for Marine fishing (among other sectors) and aggregated by geo area and year for all sexes.

-   `liv_mar_jobs_prep.Rmd`

    -   Mariculture number of jobs (employment)
        -   Partially obtained from [FAO Fisheries and Aquaculture Statistical Yearbook](https://openknowledge.fao.org/server/api/core/bitstreams/2be6c2fa-07b1-429d-91c5-80d3d1af46a6/content)
        -   Also brought in OECD data from their online [OECD Data Explorer](https://data-explorer.oecd.org/vis?df%5Bds%5D=DisseminateFinalDMZ&df%5Bid%5D=DSD_SOE%40DF_SOE&df%5Bag%5D=OECD.ENV.EPI&dq=.A....&pd=1995%2C2024&to%5BTIME_PERIOD%5D=false&vw=tb)

-   `liv_tour_dataprep.Rmd`

    -   Tourism number and quality of jobs
        -   Labor Force data from World Bank (downloaded June 28, 2024)

            \- <https://data.worldbank.org/indicator/SL.TLF.TOTL.IN>

            -   Jobs data from UN Tourism / UNWTO (downloaded June 26th, 2024)

                -   Key Tourism Statistics <https://www.unwto.org/tourism-statistics/key-tourism-statistics>
                -   According to the website, the latest update of the dataset took place in 31 January 2024.

            -   Quality/Wage data from ILOSTAT (downloaded July 2, 2024) -- for tour/cf wage data

                -   <https://rshiny.ilo.org/dataexplorer46/?lang=en&id=EAR_4MTH_SEX_ECO_CUR_NB_A>

-   `fp_dataprep.Rmd`

    -   Fish Processing: Proportion of Jobs per Country per Year (2019-2021)

        -   **Data:** [OECD Employment in Fisheries, Aquaculture, and Processing Dataset](https://data-explorer.oecd.org/vis?fs%5B0%5D=Topic%2C1%7CAgriculture%20and%20fisheries%23AGR%23%7CFisheries%20and%20aquaculture%23AGR_FSA%23&pg=0&fc=Topic&bp=true&snb=6&df%5Bds%5D=dsDisseminateFinalDMZ&df%5Bid%5D=DSD_FISH_EMP%40DF_FISH_EMPL&df%5Bag%5D=OECD.TAD.ARP&df%5Bvs%5D=1.0&dq=.A...PROC._T._T&pd=2009%2C2021&to%5BTIME_PERIOD%5D=false&ly%5Bcl%5D=TIME_PERIOD&ly%5Brs%5D=REF_AREA&vw=tb)

        Filtered to select: - Time Period 2009-2021 (2009-most recent year of data as of July 5th, 2024). - "Working domain" --\> "Processing" - "Sex" --\> "Total" - "Working status" --\> "Total"

        -   **Data:** Labor Force Data

            -   Labor Force data from World Bank (downloaded June 28. 2024)

                -   <https://data.worldbank.org/indicator/SL.TLF.TOTL.IN>

-   `liv_labor_force_dataprep.Rmd`

    -   Proportion of Tourism Jobs per Country/Region per Year, data from World Bank
    -   saves as liv_labor_force.csv
        -   Labor Force data from World Bank (downloaded June 28. 2024)

            -   <https://data.worldbank.org/indicator/SL.TLF.TOTL.IN>

#### Economies (ECO)

-   `aqf_dataprep.Rmd`

\- The original data source for aquarium fishing revenue had been updated since this goal was originally calculated: [FAO global trade value data.](https://www.fao.org/fishery/en/collection/global_commodity_prod) - Revenue data was prepared as is described in the methods: export data from the FAO Global Commodities database for 'Ornamental fish' for all available years, ornamental freshwater fish were excluded. The global commodities database is a component of the Global Aquatic Trade Statistic Collection published by FAO. - \*\*v2024:\*\* downloaded using on July 3rd, 2024 using the FAO status query interface/dashboard (data exploration & download portal, seems to be relatively new): - [Global aquatic trade - By partner country Value (2019 - 2021)](https://www.fao.org/fishery/statistics-query/en/trade_partners/trade_partners_value) - under "Trade Flow" in the Dimensions filtering section, select "Exports" (alternatively, you could skip this and filter to "Export" in R) - scroll to the bottom of the page, click the "download" button/icon, then select "csv", "Flag enabled" (we clean this later), then "Yes" for "Include null values" - select "Preferences", then: - for "Show unavailable values" select "NA" - for "Thousands separator" select "No space" - (all years -- 2019, 2020, and 2021 are selected by default, no countries or commodities etc. are selected for any filtering) - © FAO 2024. Global Aquatic Trade Statistics. In: Fisheries and Aquaculture. Rome. [Cited Wednesday, July 3rd 2024]. \<[https://www.fao.org/fishery/en/collection/global_commodity_prod\\](https://www.fao.org/fishery/en/collection/global_commodity_prod\){.uri}\> - [Metadata](https://www.fao.org/fishery/en/collection/global_commodity_prod)

-   `eco_mar_prep.Rmd`
    -   Mariculture Revenue Data (1984 - 2022)
        -   Data came from FishStatJ, FAO's application to obtain different fishery-related metrics by country as well as by sector

        -   Citation: © FAO 2024. Global Aquaculture Production. In: Fisheries and Aquaculture. Rome. [Cited Tuesday, July 9th 2024]. <https://www.fao.org/fishery/en/collection/aquaculture>

        -   **Instructions for download from FishStatJ**

            -   Go to FAO website for download [FAO](https://www.fao.org/fishery/en/statistics/software/fishstatj)
            -   Also open the user manual found on that page, linked [here](https://www.fao.org/fishery/static/FishStatJ/FishStatJ_4.03.05-Manual.pdf)
            -   Once downloaded, open FishStatJ on your computer and follow the instructions to set it up.
            -   Then click file -\> manage workspaces -\> click 'FAO Global Fishery and Aquaculture Production Statistics' -\> click 'Import' -\> Next -\> Next; until it opens
            -   This should import the workspace and allow you to access the 'FAO Global Fishery and Aquaculture Production Value' data
            -   Once it opens, click 'File' -\> 'Export Selection (CSV File)'
            -   Store it somewhere you can find on your local drive and from there move it into the 'FAO_mariculture' folder under /home/shares/ohi/git-annex/globalprep/\_raw_data/FAO_mariculture/*your data year*
-   `eco_cf_prep.Rmd`
    -   USD Value of Marine (Commercial) Fishing per Country/Region per Year (1976-2019)

    -   **FAO Capture Data (downloaded August 24, 2023)**

        -   Data Source FAO Global Capture Production (in metric tonnes)

        -   This version of the value database was downloaded from the Statistical Query Panel. Data from [FAO Global Capture Production](https://www.fao.org/fishery/en/collection/capture?lang=en)

        -   Citation: FAO 2023. Global Capture Production. Fisheries and Aquaculture Division <https://www.fao.org/fishery/en/collection/capture?lang=en>

        -   Source information: Navigate to the [online query portal](https://www.fao.org/fishery/statistics-query/en/capture/capture_quantity) for FAO Global Capture Production Quantity. Deselect all pre-selected years. Drag these fields into selected rows: ASFIS species name, FAO major fishing area name, ASFIS species ISSCAP group name En. ASFIS species Family scientific name, FAO major fishing areas, Inland/Marine areas Name en. Click on show data and confirm that data is present for 1950- two years prior to current year. Click download and select yes to include Null Values.

        -   Date: September 15th, 2023

        -   Time range: 1950-2021

        -   Native data resolution: Country level

        -   Format: csv

        -   Description: Global Capture Production Quantity

        **Ex-Vessel Price Data (downloaded August 24, 2023)**

        -   Ex-vessel price data is in USD/metric tonne.

            -   ex-vessel-prices: ex-vessel prices for fishery caught species from 1976-2019

                -   exvessel_price_database_1976_2019.csv: ex-vessel price data gathered from [Melnychuk et al. 2016](https://doi.org/10.1093/icesjms/fsw169) and updated to 2019 using methods described in the public-facing [github repo](https://github.com/SFG-UCSB/price-db-sfg) associated with the Melnychuk et al. 2016 paper

            -   \*\*Citation for paper\*\*  

            -   Melnychuk, M. C., Clavelle, T., Owashi, B., and Strauss, K. 2016. Reconstruction of global ex-vessel prices of fished species. - ICES Journal of Marine Science. <doi:10.1093/icesjms/fsw169>.
            
-   `eco_tour_prep.Rmd`
    -   Tourism Revenue in USD per Country per Year (2008 - 2019)

    -   **Tourism direct GDP as a proportion of total GDP (indicator 8.9.1):** **UNWTO Dept. of Statistics (UN Tourism)**

        -   <https://www.unwto.org/tourism-statistics/economic-contribution-SDG>

        -   A big issue with this data set is that it does not have data for mainland China. Thus, I was instructed to gapfill using another data source. I found tourism revenue data on the website for the National Bureau of Statistics for China

        -   China Gapfilling -- °ºNational Data: National Bureau of Statistics of China (NBS) <https://data.stats.gov.cn/english/easyquery.htm?cn=C01>

        -   Made an account to download data:

        -   Email: [aramji\@bren.ucsb.edu](mailto:aramji@bren.ucsb.edu){.email}

        -   Password: OHI.f3ll0ws!

        -   Security Question: who has influenced you the most?

        -   Answer: Melanie Frazier

        -   Returned to home page, clicked “Annual”, clicked “Tourism” from options on the left, clicked “Year” dropdown menu and selected “LATEST20”, then clicked the download button and selected “csv”. File appeared as “Annual.csv”, which I then renamed to `eco_tour_china_all_metrics_2004-2023.csv`

        -   Added to new file in `_raw_data` on Mazu → NBS_China

        -   For this tourism revenue data used for China, I wanted to discern whether or not these numbers included Macao and Hong Kong, as that can sometimes be the case (and would significantly impact my data processing methods). Thankfully, the website where I downloaded the data had information on this:

        > "National statistical indicators involved in the database don't contain data from Hong Kong Special Administrative Regions (SAR), Macao SAR and Taiwan Province except for administrative divisions, land area, forest resources and precipitation. Hong Kong SAR and Macao SAR are a part of the overall national statistics. According to the relevant principles of the PRC Hong Kong Basic Law and Macao SAR Basic Law, Hong Kong, Macao and the mainland are relatively independent statistical regions. Based on their different statistical systems and legal requirements, they conduct statistical work independently." <https://data.stats.gov.cn/english/staticreq.htm?m=aboutctryinfo#:~:text=National%20statistical%20indicators%20involved%20in,area%2C%20forest%20resources%20and%20precipitation.>

        -   while this is a little ambiguous, I think it's safe to interpret this to mean that the tourism data we downloaded from the site does not include data from/about Macao and Hong Kong

        **GDP: World Bank, in "constant 2015 US\$"**

        -   <https://data.worldbank.org/indicator/NY.GDP.MKTP.KD>

            -   Downloaded July 9, 2024.
            -   Contains country-level annual GDP value (in constant 2015 USD) from 1960-2023.
            -   Additional metadata copied and saved as a `.rtf` in the `WorldBank_global_annual_GDP_2015_constant_USD` subfolder of the `_raw_data`'s `WorldBank` folder for `d2024`.
            -   Date last updated (found in the first few rows of the `.csv` when opened locally using Numbers): 2024-06-28

        **USA Coastal Tourism**

        Economics: National Ocean Watch (ENOW) Data

        -   Marine Economies: Industries for States and Coastal US
        -   <https://coast.noaa.gov/digitalcoast/data/>

        Office for Coastal Management, 2024: Time-Series Data on the Ocean and Great Lakes Economy for Counties, States, and the Nation between 2005 and 2021 (Sector Level) from 2008-01-01 to 2019-12-31. NOAA National Centers for Environmental Information, <https://www.fisheries.noaa.gov/inport/item/48033>. Downloaded 2024-07-18.

        > Abstract: Economics: National Ocean Watch (ENOW) contains annual time-series data for over 400 coastal counties, 30 coastal states, 8 regions, and the nation, derived from the Bureau of Labor Statistics and the Bureau of Economic Analysis. It describes six economic sectors that depend on the oceans and Great Lakes and measures four economic indicators: Establishments, Employment, Wages, and Gross Domestic Product (GDP).

        ```         
        -   Metadata: https://www.fisheries.noaa.gov/inport/item/48033 
        ```

        -   Range: 2005-2021

        Has sector-level data: - Includes Ship and Boat Building, Tourism and Recreation, Living Resources, Fish hatcheries and aquaculture, Seafood processing, Seafood markets, Fishing, Marine Construction, Marine Transportation, All Ocean Sectors - Has employment, wages, GDP, RealGDP columns (RealGDP = adjusted for inflation -- theoretically to year of most recent update based on the metadata, which would be 2021. However, upon futher investigation, the gdp and real gdp values match in the year 2012, so it seems that RealGDP is GDP adjusted to 2012 USD) - Contains -9999 values for data privacy – these values are captured in the totals but not in state-level

        -   On Mazu in `home/shares/ohi/git-annex/globalprep/_raw_data/ENOW/d2024/ENOW_Industries/ENOW_Industries_2005_2021.csv`

        -   Downloaded from NOAA Office for Coastal Management; Digital Coast website: <https://coast.noaa.gov/digitalcoast/data/>.
-   `eco_usd_adj.Rmd`
    -   Adjusting Economies data by Sector for Inflation
    -   No new data brought in
    -   Uses `inflation_adjustment.R`
        -   a function we made that utilizes priceR::adjust_for_inflation()
        -   `priceR` description: "Inflate/deflate prices from any year to any year, using World Bank inflation data and assumptions only where necessary. Typically used for converting past (nominal) values into current (real) values. This uses World Bank inflation data where available, but allows for both historical and future assumptions in extrapolation."
        -   We adjusted to USD 2017, arbitrarily, as long as it was before 2020.

## Three steps to calculate the overall ECO subgoal score:

### *First: clean*

-   **3 scripts, each one produces a dataset**: e.g., eco_cf_prep.Rmd (rgn_id, rgn_name, year, usd, unit, sector, usd_yr). Make sure that all the USD are in the same units!!! e.g., non-inflation adjusted, or inflation adjusted to same year, etc.

    -   usd = "value", in US Dollars

    -   usd_yr is a column to describe what year the column "usd" was adjusted to. If there were no adjustments, usd_yr would equal year.

    -   Cleaning the data

        -   Don’t filter dates here. This will be done procedurally downstream

        -   This will ideally end with columns: **country**, **year**, **usd** (value), **unit** (currency), **sector**, **data_source**

    -   Assigning countries to OHI regions where possible

        -   Done using the **name_2_rgn()** function from ohicore

        -   Check that values align and that there are no duplicated countries

    -   Add column **usd_yr** that contains the year that the associated **usd** value is currently adjusted to

        -   Example: If I have a value for each year from 1984-2022, each with a value that was adjusted to USD for that year, my **usd_yr** column would be each year from 1984-2022, because 1984’s value is adjusted to 1984 USD, and 1985’s value is adjusted to 1985 USD 

        -   Example: If all of my data were already adjusted to 2015 USD, my **usd_yr** column would contain only 2015

    -   This step should end with multiple scripts, one for each sector with the following naming conventions:

        -   eco\_”sector abbreviation”\_prep.Rmd → creating the eco\_”sector abbreviation”\_usd_pre.csv file

        -   Ex: “eco_mar_prep.Rmd” creates “eco_mar_usd_pre.csv”

### *Second: adjust inflation*

-   **1 script, produce 1 dataset**: eco_usd_adj.Rmd (rgn_id, rgn_name, year, unit, sector, usd_yr, usd_adj): script that takes care of all layers: adjusts for inflation and combines sectors into 1 csv.

    -   With the previously made dataframes in the correct file structure, this script’s job will be to read them in and adjust “usd” columns for inflation. This will be done using the “priceR” package.

    -   First the user will follow the steps at the top to read in the data for each sector and rbind them

        -   This is possible because each df should have the same columns in the same order

        -   Then they will use a small chunk of code to identify the **most recent minimum year (highest minimum)** in each of the datasets. Due to the nature of calculating the score, we found that it was important that the bound “score calculation” df have the range of years that corresponds to the most recent shared minimum year and to the most recent shared maximum year **(lowest maximum)**

    -   We made a small function that takes each of the eco_sector_usd_pre.csv dataframes, the year that you want each value to be inflation-adjusted for, the country of the currency that the value is in, and the year of assessment.

        -   This function then draws out relevant values from the df for both usd and usd_yr, adjusts the values for inflation to your desired year, and

            -   1\. Adds a column onto the sector df that contains the adjusted values for usd

            -   2\. Writes a csv out to the ‘int’ folder with the naming structure eco\_”sector abbreviation”\_usd_adj.csv

                -   This is so as to be able to track changes in real time as well as look back/forward when working on a different script

### *Third: calculate*

-   **1 script, calculates score** (use the methods: <https://oceanhealthindex.org/images/htmls/Supplement.html#67_Livelihoods_and_economies>)
