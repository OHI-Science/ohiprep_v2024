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
    -   The original data source for aquarium fishing revenue had been updated since this goal was originally calculated: [FAO global trade value data.](https://www.fao.org/fishery/en/collection/global_commodity_prod) - Revenue data was prepared as is described in the methods: export data from the FAO Global Commodities database for 'Ornamental fish' for all available years, ornamental freshwater fish were excluded. The global commodities database is a component of the Global Aquatic Trade Statistic Collection published by FAO. - \*\*v2024:\*\* downloaded using on July 3rd, 2024 using the FAO status query interface/dashboard (data exploration & download portal, seems to be relatively new): - [Global aquatic trade - By partner country Value (2019 - 2021)](https://www.fao.org/fishery/statistics-query/en/trade_partners/trade_partners_value) - under "Trade Flow" in the Dimensions filtering section, select "Exports" (alternatively, you could skip this and filter to "Export" in R) - scroll to the bottom of the page, click the "download" button/icon, then select "csv", "Flag enabled" (we clean this later), then "Yes" for "Include null values" - select "Preferences", then: - for "Show unavailable values" select "NA" - for "Thousands separator" select "No space" - (all years -- 2019, 2020, and 2021 are selected by default, no countries or commodities etc. are selected for any filtering) - © FAO 2024. Global Aquatic Trade Statistics. In: Fisheries and Aquaculture. Rome. [Cited Wednesday, July 3rd 2024]. \<[[https://www.fao.org/fishery/en/collection/global_commodity_prod\\\\](https://www.fao.org/fishery/en/collection/global_commodity_prod\\){.uri}]([https://www.fao.org/fishery/en/collection/global_commodity_prod\\](https://www.fao.org/fishery/en/collection/global_commodity_prod\){.uri}){.uri}\>
    -   [Metadata](https://www.fao.org/fishery/en/collection/global_commodity_prod)
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
    -   **UNWTO: Tourism direct GDP as a proportion of total GDP**

        -   **Reference**: World Tourism Organization. (2024). *Tourism direct GDP as a proportion of total GDP (indicator 8.9.1)*. UNWTO. <https://www.unwto.org/tourism-statistics/economic-contribution-SDG>
        -   **Downloaded**: 2024-07-01
        -   **Last updated**: 2024-04-29
        -   **Description**: Tourism direct GDP as a proportion of total GDP (%) for 118 regions. Data is aggregated from multiple sources.
        -   **Download Instructions**: Navigate to the UN Tourism [Economic Contribution and SDG page](https://www.unwto.org/tourism-statistics/economic-contribution-SDG), find the "Tourism direct GDP as a proportion of total GDP (indicator 8.9.1)" section (should be the first section on the page), right-click on the "Download Data" button, copy the link address, and paste the link in a new tab to download the file (most browsers initially blocked the download and flagged it as "Insecure Content"). Upload the file to the appropriate folder on Mazu (UNWTO/dYYYY/, where YYYY = scenario year, e.g., 2024).
        -   **Time range**: 2008-2022
        -   **Native data resolution**: Country-level, not spatial data.
        -   **Format**: `.xlsx`
        -   **Metadata**: Linked in the "Download Metadata" button below the "Download Data" button: <http://pre-webunwto.s3.eu-west-1.amazonaws.com/s3fs-public/2024-04/Metadata-08-09-01%202_3_april2024_updated.pdf>
        -   **Note:** A big issue with this data set is that it does not have data for mainland China. Thus, I was instructed to gapfill using another data source. I found tourism revenue data on the website for the National Bureau of Statistics for China

    -   **National Data: National Bureau of Statistics of China (NBS): Development of Tourism**

        -   Files downloaded: Foreign Exchange Earnings from International Tourism(USD million); Earnings from Domestic Tourism (100 million yuan)

        -   **Reference**: National Bureau of Statistics of China. (2024). *Foreign Exchange Earnings from International Tourism(USD million)*. NBS. <https://data.stats.gov.cn/english/easyquery.htm?cn=C01> .

            National Bureau of Statistics of China. (2024). *Earnings from Domestic Tourism (100 million yuan)*. NBS. <https://data.stats.gov.cn/english/easyquery.htm?cn=C01> .

        -   **Downloaded**: 2024-07-11

        -   **Last updated**: n.d. 2024 assumed.

        -   **Description**: Foreign Exchange Earnings from International Tourism(USD million) "Foreign Exchange Earnings from International Tourism refer to the total expenditure on transportation, sighting, accommodation, food, shopping and entertainment of foreigners and overseas Chinese during their stay in the mainland of China." Assumed to be in present USD (i.e., 2018 values are in 2018 USD, 2022 values are in 2022 USD).

            Earnings from Domestic Tourism (100 million yuan) Earnings from Domestic Tourism in present 100 million yuan.

        -   **Download Instructions**:

            -   Make an account to download data.
            -   Return to the [home page](https://data.stats.gov.cn/english/index.htm), click "Annual" from the top navigation bar, then click "Tourism" from options on the left navigation menu, click "Year" dropdown menu and selected "LATEST20", then clicked the download button and select ".csv". File appears as "Annual.csv" -- rename this to `eco_tour_china_all_metrics_[start-year]-[end-year].csv`, e.g., `eco_tour_china_all_metrics_2004-2023.csv`
            -   Add new file to `_raw_data/NBS_China/d[YYYY]` folder on Mazu. Replace [YYYY] with scenario year, e.g., 2024.

        -   **Time range**: 2004-2023

        -   **Native data resolution**: N/A

        -   **Format**: `.csv`

        -   **Metadata**: <https://data.stats.gov.cn/english/staticreq.htm?m=aboutctryinfo#:~:text=National%20statistical%20indicators%20involved%20in,area%2C%20forest%20resources%20and%20precipitation.>

    -   **World Bank: GDP (constant 2015 US\$)**

        -   **Reference**: World Bank. (n.d.). *GDP (constant 2015 US\$)*. World Bank Open Data. <https://data.worldbank.org/indicator/NY.GDP.MKTP.KD>.
        -   License: CC BY-4.0
        -   **Downloaded**: 2024-07-09
        -   **Last updated**: No precise date listed on website. Found in the first few pages of the .csv when opened locally: 2024-06-28.
        -   **Description**: "GDP at purchaser's prices is the sum of gross value added by all resident producers in the economy plus any product taxes and minus any subsidies not included in the value of the products. It is calculated without making deductions for depreciation of fabricated assets or for depletion and degradation of natural resources. Data are in constant 2015 prices, expressed in U.S. dollars. Dollar figures for GDP are converted from domestic currencies using 2015 official exchange rates. For a few countries where the official exchange rate does not reflect the rate effectively applied to actual foreign exchange transactions, an alternative conversion factor is used." Aggregation method: Gap-filled total.
        -   **Download Instructions**: Navigate to the World Bank GDP (constant 2015 US\$) data page <https://data.worldbank.org/indicator/NY.GDP.MKTP.KD>. The full time range should be selected on the slider bar by default. Select "CSV" under the "Download" options on the lower right-hand side of the page. Save in the appropriate folder on Mazu: `home/shares/ohi/git-annex/globalprep/_raw_data/WorldBank/dYYYY/WorldBank_global_annual_GDP_2015_constant_USD/WorldBank_global_annual_GDP_2015_constant_USD.csv`
        -   **Time range**: 1960-2023
        -   **Native data resolution**: Country-level (not spatial data).
        -   **Format**: `.csv.` Note: Data is also available in XML and EXCEL formats.
        -   **Metadata**: Click on "Details" (in the upper right hand corner of the plot on the main page), scroll to the bottom of the popup page, and select "All Metadata". <http://databank.worldbank.org/data/reports.aspx?source=2&type=metadata&series=NY.GDP.MKTP.KD&_gl=1*10r25gl*_gcl_au*MTI5NjExNDc0NS4xNzE2NTY4ODAx>

    -   **Economics: National Ocean Watch (ENOW); Marine Economies: Industries for States and Coastal US**

        -   **Reference**: Office for Coastal Management, 2024: *Time-Series Data on the Ocean and Great Lakes Economy for Counties, States, and the Nation between 2005 and 2021 (Sector Level) from 2008-01-01 to 2019-12-31*. NOAA National Centers for Environmental Information, <https://www.fisheries.noaa.gov/inport/item/48033>. Downloaded 2024-07-18. Reference is tailored to the filtered date range used in this project. Actual date range of data was 2005-2021 as of 2024. <https://coast.noaa.gov/digitalcoast/data/>

        -   **Downloaded**: 2024-07-18

        -   **Last updated**: 2022

        -   **Description**: Annual marine sector- and industry-level data at national and state levels for coastal (Great Lakes included) United States. Data is processed in this notebook to filter data to the tourism industry and ultimately calculate coastal (Great Lakes exclusive) tourism GDP. RealGDP variable indicated 2012-adjusted GDP.

        -   <div>

            > Abstract: Economics: National Ocean Watch (ENOW) contains annual time-series data for over 400 coastal counties, 30 coastal states, 8 regions, and the nation, derived from the Bureau of Labor Statistics and the Bureau of Economic Analysis. It describes six economic sectors that depend on the oceans and Great Lakes and measures four economic indicators: Establishments, Employment, Wages, and Gross Domestic Product (GDP).

            </div>

        -   Providers: [Bureau of Economic Analysis](https://coast.noaa.gov/digitalcoast/contributing-partners/bureau-economic-analysis.html), [Bureau of Labor Statistics](https://coast.noaa.gov/digitalcoast/contributing-partners/bureau-labor-statistics.html), [NOAA Office for Coastal Management](https://coast.noaa.gov/digitalcoast/contributing-partners/office-for-coastal-management.html).

            Downloaded from NOAA Office for Coastal Management; Digital Coast website: <https://coast.noaa.gov/digitalcoast/data/>.

        -   **Download Instructions**: Navigate to the [NOAA Digital Coast Data Catalog](https://coast.noaa.gov/digitalcoast/data/) page, scroll down to "Marine Economies: Industries for States and Coastal US" and click on it. Then click the "Download" button, right click on the "Download" hyperlinked text that pops up, and copy and paste it into a new tab in your browser to download the zip file. It should be called "ENOW_Industries.zip". Open it (unzip it), and upload the whole folder to the appropriate folder on Mazu. `home/shares/ohi/git-annex/globalprep/_raw_data/ENOW/d[YYYY]/` replace [YYYY] with your scenario year, e.g., 2024.

            Note: the metadata linked for this data under "Other Resources" on the page where you download it links to the more general Time-Series Data page, which is not specific to this dataset. <https://www.fisheries.noaa.gov/inport/item/48033>

        -   **Time range**: 2005-2021. Filtered to 2008-2019

        -   **Native data resolution**: State and national level. Not spatial data. `NA` value code for privacy protection (see notes on `eco_tour_prep.Rmd` for more details): `-9999`.

        -   **Format**: `.csv`

        -   **Metadata**: <https://www.fisheries.noaa.gov/inport/item/48033> . Note: this metadata is not specific to this exact dataset.

    -   **National Aggregates of Geospatial Data Collection (NAGDC): Population, Landscape, And Climate Estimates (PLACE), v3 (1990, 2000, 2010)**

        -   Used for Coastal Proximity (within 100km of coast) population data. National Aggregates of Geospatial Data Collection (NAGDC). From Socioeconomic Data and Applications Center (SEDAC), hosted by Center for International Earth Science Information Network (CIESIN) at Columbia University.

        -   **Reference**: Center for International Earth Science Information Network - CIESIN - Columbia University. 2012. *National Aggregates of Geospatial Data Collection: Population, Landscape, And Climate Estimates, Version 3 (PLACE III)*. Palisades, New York: NASA Socioeconomic Data and Applications Center (SEDAC). <https://doi.org/10.7927/H4F769GP>. Accessed 22 July 2024.

            <https://sedac.ciesin.columbia.edu/data/set/nagdc-population-landscape-climate-estimates-v3/data-download>

        -   **Downloaded**: 2024-07-22

        -   **Last updated**: 2012-07-09

        -   **Description**: Abstract: "The National Aggregates of Geospatial Data Collection: Population, Landscape, And Climate Estimates, Version 3 (PLACE III) data set contains estimates of national-level aggregations in urban, rural, and total designations of territorial extent and population size by biome, climate zone, coastal proximity zone, elevation zone, and population density zone, for 232 statistical areas (countries and other UN recognized territories). This data set is produced by the Columbia University Center for International Earth Science Information Network (CIESIN)." Purpose: "To provide tabular data to researchers without GIS capabilities who need data on population and land area by country across a range of physical characteristics. These include measures such as the number of persons living within coastal zones, the percent of a region within specific elevation strata, or the number of persons living within different climate zones."

            2010 Coastal Population values used to create proportional multipliers for tourism GDP to calculate coastal tourism value.

        -   **Download Instructions**:

            -   Navigate to the SEDAC PLACE v3 [Data Download](https://sedac.ciesin.columbia.edu/data/set/nagdc-population-landscape-climate-estimates-v3/data-download) page. Select "CSV" to download the `.csv`. You may need to make an account to download the data. In 2024, our account information was as follows:
                -   Username: ohifellows2024
                -   Password: OHIfellows.2024!
            -   After logging in, the zip file `nagdc-population-landscape-and-climate-estimates-v3-csv` should be downloaded automatically. Upload this folder to the appropriate folder on Mazu: `home/shares/ohi/git-annex/globalprep/_raw_data/SEDAC_CIESIN/d[YYYY]`. Replace [YYYY] with the scenario year, e.g., 2024.

        -   **Time range**: 1990 (January 1), 2000 (January 1), 2010 (January 1)

        -   **Native data resolution**: This is a `.csv`, but the **Spatial Domain:** is as follows: Bounding Coordinates: West Bounding Coordinate: -180.000000 East Bounding Coordinate: 180.000000 North Bounding Coordinate: 85.000000 South Bounding Coordinate: -58.000000

        -   **Format**: `.csv` Note: Data is also available in `.xlsm` format.

        -   **Metadata**: Navigate to the "Documentation" tab of the PLACE page: <https://sedac.ciesin.columbia.edu/data/set/nagdc-population-landscape-climate-estimates-v3/docs>. Under "Documentation:", select "Methods (PDF)". Note: also available as an RTF. <https://sedac.ciesin.columbia.edu/downloads/docs/nagdc/nagdc-population-landscape-climate-estimates-v3.pdf>

            Portal metadata: <https://sedac.ciesin.columbia.edu/data/set/nagdc-population-landscape-climate-estimates-v3/metadata>

        -   **Notes**: - This data is not updated. Future years should consider using an updated version of PLACE, such as v4.

-   `eco_usd_adj.Rmd`
    -   Adjusting Economies data by Sector for Inflation
    -   No new data brought in
    -   Uses `inflation_adjustment.R`
        -   a function we made that utilizes `priceR::adjust_for_inflation()`
        -   `priceR` description: "Inflate/deflate prices from any year to any year, using World Bank inflation data and assumptions only where necessary. Typically used for converting past (nominal) values into current (real) values. This uses World Bank inflation data where available, but allows for both historical and future assumptions in extrapolation."
        -   We adjusted to USD 2017, arbitrarily, as long as it was before 2020.

## Three steps to calculate the overall ECO subgoal score:

### *First: clean*

-   **3 scripts, each one produces a dataset**: e.g., `eco_cf_prep.Rmd` (rgn_id, rgn_name, year, usd, unit, sector, usd_yr). Make sure that all the USD are in the same units!!! e.g., non-inflation adjusted, or inflation adjusted to same year, etc.

    -   `usd` = "value", in US Dollars

    -   `usd_yr` is a column to describe what year the column `usd` was adjusted to. If there were no adjustments, `usd_yr` would equal year.

    -   Cleaning the data

        -   Don't filter dates here. This will be done procedurally downstream

        -   This will ideally end with columns: **country**, **year**, **usd** (value), **unit** (currency), **sector**, **data_source**

    -   Assigning countries to OHI regions where possible

        -   Done using the **name_2_rgn()** function from ohicore

        -   Check that values align and that there are no duplicated countries

    -   Add column **usd_yr** that contains the year that the associated **usd** value is currently adjusted to

        -   Example: If I have a value for each year from 1984-2022, each with a value that was adjusted to USD for that year, my **usd_yr** column would be each year from 1984-2022, because 1984's value is adjusted to 1984 USD, and 1985's value is adjusted to 1985 USD 

        -   Example: If all of my data were already adjusted to 2015 USD, my **usd_yr** column would contain only 2015

    -   This step should end with multiple scripts, one for each sector with the following naming conventions:

        -   eco\_"sector abbreviation"\_prep.Rmd → creating the eco\_"sector abbreviation"\_usd_pre.csv file

        -   Ex: "eco_mar_prep.Rmd" creates "eco_mar_usd_pre.csv"

### *Second: adjust inflation*

-   **1 script, produce 1 dataset**: `eco_usd_adj.Rmd` (rgn_id, rgn_name, year, unit, sector, usd_yr, usd_adj): script that takes care of all layers: adjusts for inflation and combines sectors into 1 csv.

    -   With the previously made dataframes in the correct file structure, this script's job will be to read them in and adjust "`usd`" columns for inflation. This will be done using the `{priceR}` package.

    -   First the user will follow the steps at the top to read in the data for each sector and `rbind` them

        -   This is possible because each dataframe (df) should have the same columns in the same order

        -   Then they will use a small chunk of code to identify the **most recent minimum year (highest minimum)** in each of the datasets. Due to the nature of calculating the score, we found that it was important that the bound "score calculation" df have the range of years that corresponds to the most recent shared minimum year and to the most recent shared maximum year **(lowest maximum)**

    -   We made a small function that takes each of the eco_sector_usd_pre.csv dataframes, the year that you want each value to be inflation-adjusted for, the country of the currency that the value is in, and the year of assessment.

        -   This function then draws out relevant values from the df for both usd and usd_yr, adjusts the values for inflation to your desired year, and

            -   1\. Adds a column onto the sector df that contains the adjusted values for usd

            -   2\. Writes a csv out to the '`int`' folder with the naming structure `eco_"sector abbreviation"_usd_adj.csv`

                -   This is so as to be able to track changes in real time as well as look back/forward when working on a different script

### *Third: calculate*

-   **1 script, calculates score** (use the methods: <https://oceanhealthindex.org/images/htmls/Supplement.html#67_Livelihoods_and_economies>)
