# Status of Livelihoods and Economies Update

In 2023 we cleaned and prepped the best available data for most sectors and components included in this goal. Data for tourism still needs to be selected, and is discussed in tourism sections. When newly updated data wasn't available, we re-downloaded and cleaned the previous data source. The old versions of the raw data prepped by OHI were stored on a server previously used by OHI and were no longer accessible. All of the cleaned files are now saved in the folder `~/ohiprep_v2023/globalprep/le/v2023/int` in the format sector_component.csv.

More detailed methods and explanations are available in the livelihoods_economies_dataprep.RMD saved in `~/ohiprep_v2023/globalprep/le/v2023`. Included below is a summary of what tasks were completed in the methods update.

For all datasets, except tourism revenue, the current format has one value for each country and year included in the dataset. Tourism uses a pre-cleaned version of the revenue data, so countries have already been converted to regions. We did not do any gapfilling to fill in countries missing from the cleaned data sets, so this will likely need to be done for most of the included data.

Acronyms for sectors used in the original output layers are used for simplicity of incorporating into the finalized OHI model. A new sector fish processing FP was added in this analysis, and will need to be incorporated into the model.

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

# Revenue:

Value in each of these data sets is the total estimated revenue per country in us dollars.

## Ocean Energy

-   This sector was originally called Wave and Renewable Energy

<!-- -->

-   We used the indicator "All ocean and offshore energy (offshore wind + ocean energy) RD&D, million USD 2021 PPP" from the [OECD: Sustainable Ocean Economy](https://stats.oecd.org/Index.aspx?QueryId=95228#) dataset.
    -   Metadata is available for download through the portal. This platform is being retired, this data set will likely be located in the [OECD Data Explorer](https://data-explorer.oecd.org/) in future years.
    -   v2024: new link to the Ocean Sustainability data on [OECD Data Explorer](https://data-explorer.oecd.org/vis?df%5Bds%5D=DisseminateFinalDMZ&df%5Bid%5D=DSD_SOE%40DF_SOE&df%5Bag%5D=OECD.ENV.EPI&dq=AUS.A....&pd=2017%2C&to%5BTIME_PERIOD%5D=false)
-   The ocean energy data from OECD is actually the amount country and state governments budget for ocean energy, and is not specifically revenue. However, it is included as this was the only comprehensive data set available with monetary amounts related to ocean energy, it will likely need to be modified before being used as a proxy for revenue.
-   This dataset only contains 32 countries, so gap filling would be needed.

## Aquarium Fishing

-   The original data source for aquarium fishing revenue had been updated since this goal was originally calculated: [FAO global trade value data.](https://www.fao.org/fishery/en/collection/global_commodity_prod)
-   Revenue data was prepared as is described in the methods: export data from the FAO Global Commodities database for 'Ornamental fish' for all available years, ornamental freshwater fish were excluded. The global commodities database is a component of the Global Aquatic Trade Statistic Collection published by FAO.
-   v2024: downloaded using on July 3rd, 2024 using the FAO status query interface (like a data download portal, seems to be relatively new):
-   [Global aquatic trade - By partner country Value (2019 - 2021)](https://www.fao.org/fishery/statistics-query/en/trade_partners/trade_partners_value)
-   under "Trade Flow" in the Dimensions filtering section, select "Exports"
-   scroll to the bottom of the page, click the "download" button/icon, then select "csv", "Flag enabled" (we clean this later), then "Yes" for "Include null values"
-   select "Preferences", then:
    -   for "Show unavailable values" select "NA"
    -   for "Thousands separator" select "No space"
    -   (all years -- 2019, 2020, and 2021 are selected by default, no countries or commodities etc. are selected for any filtering)
    -   © FAO 2024. Global Aquatic Trade Statistics. In: Fisheries and Aquaculture. Rome. [Cited Wednesday, July 3rd 2024]. <https://www.fao.org/fishery/en/collection/global_commodity_prod>
-   [Metadata](https://www.fao.org/fishery/en/collection/global_commodity_prod)
-   I also downloaded the full dataset, which showed up as a folder titled "FI_Trade_Partners" and contained other metadata-adjacent documents on what different symbols represented, as well as several other tables describing country codes, UN codes, and terms of usage and licensing.

## Fishing

Data:

-   [FAO Capture Production Database](https://www.fao.org/fishery/statistics-query/en/capture): This database contains capture production statistics by country or territory, species item, and FAO Major Fishing Area.

    -   [Metadata](https://www.fao.org/fishery/en/collection/capture?lang=en)

        |       |                             |
        |-------|-----------------------------|
        | Type: | Quantity                    |
        | Unit: | Tonnes                      |
        | Unit: | Number of animals (removed) |

-   Exvessel price database: Metada stored on Mazu with database.

Methods Description:

-   This component which was previously just commercial fishing, and has been updated to include fishing included in the FAO capture production database, as this was the best available data source.
-   The capture production database was subset to only marine areas, to ensure that inland fishing was not included.
-   Since the capture production database did not include value we used the ex-vessel price database (acquired from emlab). This data had a yearly global price per tonne for each species, which was multiplied by the tonnes captured in the FAO data. This data is derived from the FAO commodities database, so the species overlapped significantly with those in the fao capture data. We gapfilled this data set using a linear model for each species based on year. To fill in missing species we then gapfilled further using an average for each isscaap_group by year. For roughly 5% of species we were not able to gapfill, and no price value was included.

## Mariculture

-   The original data source for revenue from mariculture had been updated. [FAO (Aquaculture value).](https://www.fao.org/fishery/statistics-query/en/aquaculture/aquaculture_value)
-   Revenue data was prepared as described in the methods. Total revenue from mariculture was calculated by summing value of all marine/brackish species for each country.
-   Note: "the OHI methods (7.19.0.3 Mariculture) state:
    -   that to isolate production values attributable to marine and brackish aquaculture, data pertaining to freshwater species were omitted. This species classification process was very time consuming as each species had to be queried individually per year. There was little year-to year variation, and thus data were extracted in 5 year increments, providing data for 1997, 2002 and 2007."
    -   It was unclear how this process was implemented in the previous methods, this was replaced with simply filtering out species that were listed as freshwater in the environment column.
-   [Metadata](https://www.fao.org/fishery/en/collection/aquaculture?lang=en)

## Marine Mammal Watching

-   No new data was available for this sector, so previous data from [O'Connor et al 2009](https://www.mmc.gov/wp-content/uploads/whale_watching_worldwide.pdf) was used.
-   Data was extracted from a pdf of this paper stored on MAZU
-   For revenue data we attempted to replicate the methods described in the OHI supplemental methods, this involved quantifying the percent of marine mammal watching that was marine vs freshwater, and then multiplying this by total revenue to find total marine revenue.
    -   We modified the methods used to determine percent marine to a programmatic approach using habitat classification from the IUCN Red List api. Percent marine was calculated as an exact percentages (total species marine/total species) instead of grouping countries into 50%, 90% or 100% marine.
-   Unlike the other revenue components, value in this data set already includes indirect revenue as this was given in the paper.
-   Years of available data are not always consistent for every country, it is unclear how this was handled in previous methods.

## Tourism

The data previously used from WTTC is no longer available for free, and we were unable to locate this data on MAZU.

-   The methods state: "WTTC reports dollar values of visitor exports (spending by foreign visitors) and domestic travel and tourism spending; combining these two data sets creates a proxy for total travel and tourism revenues. WTTC was chosen as the source for tourism revenue data because of the near-complete country coverage, the yearly time series component starting in 1988 and updated yearly, and the inclusion of both foreign and domestic expenditures. This dataset lumps inland and coastal/marine revenues, and so was adjusted by the percent of a country's population within a 25 mile inland coastal zone. We included no projected data. We used total contribution to GDP data (rather than direct contribution to GDP) to avoid the use of literature derived multiplier effects."

### Tourism Revenue Data

Data for revenue from tourism was not finalized in 2023. One potential option is listed below.

-   "Tourism spending in the country", "Inbound Tourism-Expenditure", from the UNWTO.
    -   To download this data navigate to the [UNWTO Website](https://www.unwto.org/tourism-statistics/key-tourism-statistics), click on inbound tourism, and scroll to expenditure data.
    -   [metadata](https://www.unwto.org/glossary-tourism-terms)

#### v2024: Tourism – Livelihood data

Jobs: Number of jobs (employed in the tourism sector) per country/region per year

-   UN Tourism (UNWTO) Key Tourism Statistics <https://www.unwto.org/tourism-statistics/key-tourism-statistics>
-   Downloaded June 26th, 2024. According to the website, the latest update of the dataset took place in 31 January 2024.
-   The data ranges from 1995 to 2021, with many data gaps for many countries along that range. We limited the range from 2009-2019 to address the notable cutoff in data for many countries beginning in 2020 (reflective of the COVID-19 Pandemic), which had a notable impact on global tourism that should be investigated in future years of OHI prep (once more data is available).
-   The data is in the form of a `.xlsx` with many tabs. We use the "Employment" tab in our "number of jobs" dataprep script.

Labor Force: used to find proportion of working-eligible population employed in tourism sector

-   World Bank (downloaded June 28. 2024)

    -   <https://data.worldbank.org/indicator/SL.TLF.TOTL.IN>

"Quality": wages

-   "Average monthly earnings of employees by sex and economic activity - Annual"

-   ILO via ILOSTAT explorer <https://rshiny.ilo.org/dataexplorer46/?lang=en&id=EAR_4MTH_SEX_ECO_CUR_NB_A>

    -   navigate to ILOSTAT explorer, select:

        -   "Sex": select "none" (to un-select all options), then select "Total"

        -   "Economic Activity": select "none" and then select "ISIC-Rev.4: I. Accommodation and food service activities"

        -   "Currency": keep all selected (we end up filtering this in R)

        -   set Time Frame (sliding range bar) to 2009-present year (for us it would have been 2024, but we ended up ending our time frame at 2019 due to data constraints in the employment dataset)

    -   Then click "Export", and for the file type option (appears as a drop-down menu), select "csv".

    -   Raw data file name used in 2024: `EAR_4MTH_SEX_ECO_CUR_NB_A-filtered-2024-07-02-tour-wage.csv`

#### v2024: Tourism – Economies data:

-   Tourism direct GDP as a proportion of total GDP (indicator 8.9.1 on UN Tourism page)

    -   <https://www.unwto.org/tourism-statistics/economic-contribution-SDG>

-   Downloaded July 1st, 2024, along with Metadata, stored in UNWTO folder

    -   raw data file name `Indicator-8_9_1-2022-UN_Tourism_april2024_update.xlsx`
    -   metadata file name `metadata_unwto_economies_tourism.Rmd (change this to updated name)`

### Percent of Population within 25 miles of coast

In order to calculate percent of a country's population within a 25 mile inland coastal zone we will need total population and coastal population information.

-   Coastal population within 25 miles of the coast is calculated in the mar_prs_population folder. As of 2023 the latest version of this file was `~/OHI_repositories/ohiprep_v2023/globalprep/mar_prs_population/v2021/output/mar_pop_25mi.csv`

-   In order to obtain total population for most regions, one potential option would be to use the World Bank Data Population data in the WDI package. Example code is given below.

    `population_total <- WDI(`

    `country = "all",`

    `indicator = "SP.POP.TOTL",`

    `start = 2000, end = 2020) %>%`

    `select(eez_iso3 = iso3c, population = SP.POP.TOTL, year) %>%`

    `filter(!is.na(eez_iso3)) %>%`

    `filter(!eez_iso3 == "")`

-   A possible alternative to the WDI package is calculating total population based on a similar method to mar_prs_population.

# v2024: Fishing - Livelihood data (downloaded July 3, 2024)

## "Number": jobs

#### OECD Data Explorer:

-   Employment in fisheries, aquaculture and processing (2009 - 2021) [https://data-explorer.oecd.org/vis?fs[0]=Topic%2C1%7CAgriculture%20and%20fisheries%23AGR%23%7CFisheries%20and%20aquaculture%23AGR_FSA%23&pg=0&fc=Topic&bp=true&snb=6&vw=tb&df[ds]=dsDisseminateFinalDMZ&df[id]=DSD_FISH_EMP%40DF_FISH_EMPL&df[ag]=OECD.TAD.ARP&df[vs]=1.0&dq=.A....\_T.\_T&pd=2009%2C&to[TIME_PERIOD]=false](https://data-explorer.oecd.org/vis?fs%5B0%5D=Topic%2C1%7CAgriculture%20and%20fisheries%23AGR%23%7CFisheries%20and%20aquaculture%23AGR_FSA%23&pg=0&fc=Topic&bp=true&snb=6&vw=tb&df%5Bds%5D=dsDisseminateFinalDMZ&df%5Bid%5D=DSD_FISH_EMP%40DF_FISH_EMPL&df%5Bag%5D=OECD.TAD.ARP&df%5Bvs%5D=1.0&dq=.A...._T._T&pd=2009%2C&to%5BTIME_PERIOD%5D=false){.uri}

    -   ============= OECD_2009-2021_employment_fish_aqua_processing_raw.csv ==========

        Title: Employment in fisheries, aquaculture and processing

        This dataset contains information on the number of fishers (marine coastal, marine deep-sea, inland, subsistence), fish farmers, and fish processors working in each country. Data are broken down by working status (part-time, full-time, occasional) and sex.

        Unit of measure: Persons

        Topic: Agriculture and fisheries \> Fisheries and aquaculture

        Number of unfiltered data points: 48142

        Last updated: March 08, 2024 at 10:53:06 AM

        Date Downloaded: July 8th, 2024

        Link: [https://data-explorer.oecd.org/vis?fs[0]=Topic%2C1%7CAgriculture%20and%20fisheries%23AGR%23%7CFisheries%20and%20aquaculture%23AGR_FSA%23&pg=0&fc=Topic&bp=true&snb=6&vw=ov&df[ds]=dsDisseminateFinalDMZ&df[id]=DSD_FISH_EMP%40DF_FISH_EMPL&df[ag]=OECD.TAD.ARP&df[vs]=1.0&dq=.A....\_T.\_T&pd=2009%2C&to[TIME_PERIOD]=false&ly[cl]=TIME_PERIOD&ly[rs]=REF_AREA&ly[rw]=DOMAIN](https://data-explorer.oecd.org/vis?fs%5B0%5D=Topic%2C1%7CAgriculture%20and%20fisheries%23AGR%23%7CFisheries%20and%20aquaculture%23AGR_FSA%23&pg=0&fc=Topic&bp=true&snb=6&vw=ov&df%5Bds%5D=dsDisseminateFinalDMZ&df%5Bid%5D=DSD_FISH_EMP%40DF_FISH_EMPL&df%5Bag%5D=OECD.TAD.ARP&df%5Bvs%5D=1.0&dq=.A...._T._T&pd=2009%2C&to%5BTIME_PERIOD%5D=false&ly%5Bcl%5D=TIME_PERIOD&ly%5Brs%5D=REF_AREA&ly%5Brw%5D=DOMAIN){.uri}

        Download directions: Navigate to the link. Choose a start date (v2024 used 2009 - 2021). For Reference area, use advanced selection modes and select all. For Sex, select Total. For working status, select Total. Click download, and select "Filtered data in tabular text (CSV)". Bring into Mazu and rename intuitively.

#### FAO (gapfilling):

-   FAO Yearbook Number of Fishers (2015 - 2021) <https://openknowledge.fao.org/server/api/core/bitstreams/2be6c2fa-07b1-429d-91c5-80d3d1af46a6/content>

    -   `/home/shares/ohi/git-annex/globalprep/_raw_data/FAO/d2024/fao_statistics_yearbook_07_03_24.pdf`

-   Title: Fishery and Aquaculture Statistics – Yearbook 2021

    "This is the second edition of a totally revamped Yearbook, both in layout and content. In addition to presenting the datasets, the Yearbook now includes a synthesis of the major trends in the fisheries and aquaculture sector. Statistics are presented in a coherent, systematic and easily accessible way in the form of maps, figures and tables in eight thematic chapters, accompanied by a short descriptive analysis highlighting the main findings. The information is complemented by methodological notes (general and specific for the different chapters), glossary and reference tables to facilitate its use.

    Comments and feedback on the new format and on how the presentation of data could be further improved can be provided to the email account [Fish-Statistics-Inquiries\@fao.org](mailto:Fish-Statistics-Inquiries@fao.org){.email}. This same email can be used for queries on our freely accessible statistics, FishStat."

    Source: FAO. 2023. FishStat. Employment 1995-2021 (unpublished data).

    Required citation: FAO. 2024. Fishery and Aquaculture Statistics – Yearbook 2021. FAO Yearbook of Fishery and Aquaculture Statistics. Rome. <https://doi.org/10.4060/cc9523en>

    Unit of measure: Employment: Persons (1)

    Topic: CHAPTER 6: EMPLOYMENT. TABLE T.39. FISHERS BY TOP CAPTURE FISHERIES PRODUCERS.

    Last updated: Food and Agriculture Organization of the United Nations. Rome, 2024

    Date Downloaded: July 3rd, 2024

    Link: <https://openknowledge.fao.org/server/api/core/bitstreams/2be6c2fa-07b1-429d-91c5-80d3d1af46a6/content>

## "Quality": wages

#### ILO via ILOSTAT explorer <https://rshiny.ilo.org/dataexplorer48/?lang=en&id=EAR_4MTH_SEX_ECO_CUR_NB_A>

-   "Average monthly earnings of employees by sex and economic activity - Annual"

    -   navigate to ILOSTAT explorer, select:

        -   "Sex": select "none" (to un-select all options), then select "Total"

        -   "Economic Activity": select "none" and then select "ISIC-Rev.3.1: B. Fishing"

        -   "Currency": keep all selected (we end up filtering this in R)

        -   set Time Frame (sliding range bar) to 2009-present year (for us it would have been 2024, but we ended up ending our time frame at 2019 due to data constraints in the employment dataset)

    -   Then click "Export", and for the file type option (appears as a drop-down menu), select "csv".

    -   Raw data file name used in 2024: `EAR_4MTH_SEX_ECO_CUR_NB_A-filtered-2024-07-03-cf-wage.csv`

#### OECD PPP GDP Adjustment by year

============= OECD_2009-2020_wage_quality_annual_ppp_raw.csv ==========

Title: Annual Purchasing Power Parities and exchange rates

This table shows annual Purchasing Power Parities (PPPs) for Gross Domestic Product (GDP), household final consumption expenditure and actual individual consumption. It also shows exchange rates (annual averages and end of period), sourced from the International Monetary Fund's database on International Financial Statistics.

Final consumption expenditure is the expenditure of resident households on consumption goods or services, while individual consumption is the sum of household consumption plus the individual (not collective) consumption of the non-profit institutions serving households (NPISH) and General Government sectors.

These indicators were presented in the previous dissemination system in the SNA_TABLE4 dataset. For further information on (PPPs) please check the following link: [Purchasing Power Parities](%22http://www.oecd.org/std/purchasingpowerparities-frequentlyaskedquestionsfaqs.html%22).

OECD statistics contact: [STAT.Contact\@oecd.org](mailto:STAT.Contact@oecd.org){.email}

Institutional sector: Total economy

Counterpart institutional sector: Total economy

Financial instruments and non-financial assets: Currency

Unit of measure: National currency per US dollar

Topic: Economy \> National accounts \> GDP and non-financial accounts \> GDP and components

Number of unfiltered data points: 15517

Last updated: July 05, 2024 at 4:09:47 PM

Link: [https://data-explorer.oecd.org/vis?lc=en&tm=ppp&pg=0&snb=111&vw=ov&df[ds]=dsDisseminateFinalDMZ&df[id]=DSD_NAMAIN10%40DF_TABLE4&df[ag]=OECD.SDD.NAD&df[vs]=1.0&dq=A.AUS%2BAUT%2BBEL%2BCAN%2BCHL%2BCOL%2BCRI%2BCZE%2BDNK%2BEST%2BFIN%2BFRA%2BDEU%2BGRC%2BHUN%2BISL%2BIRL%2BISR%2BITA%2BJPN%2BKOR%2BLVA%2BLTU%2BLUX%2BMEX%2BNLD%2BNZL%2BNOR%2BPOL%2BPRT%2BSVK%2BSVN%2BESP%2BSWE%2BCHE%2BTUR%2BGBR%2BUSA...PPP_B1GQ.......&pd=2009%2C2020&to[TIME_PERIOD]=false](https://data-explorer.oecd.org/vis?lc=en&tm=ppp&pg=0&snb=111&vw=ov&df%5Bds%5D=dsDisseminateFinalDMZ&df%5Bid%5D=DSD_NAMAIN10%40DF_TABLE4&df%5Bag%5D=OECD.SDD.NAD&df%5Bvs%5D=1.0&dq=A.AUS%2BAUT%2BBEL%2BCAN%2BCHL%2BCOL%2BCRI%2BCZE%2BDNK%2BEST%2BFIN%2BFRA%2BDEU%2BGRC%2BHUN%2BISL%2BIRL%2BISR%2BITA%2BJPN%2BKOR%2BLVA%2BLTU%2BLUX%2BMEX%2BNLD%2BNZL%2BNOR%2BPOL%2BPRT%2BSVK%2BSVN%2BESP%2BSWE%2BCHE%2BTUR%2BGBR%2BUSA...PPP_B1GQ.......&pd=2009%2C2020&to%5BTIME_PERIOD%5D=false){.uri}

Download directions: Navigate to the link. Choose a start date (v2024 used 2009 - 2020). For Reference area, use advanced selection modes and select all. For Transaction, select "Purchasing Power Parities for GDP". Click download, and select "Filtered data in tabular text (CSV)". Bring into Mazu and rename intuitively.

## Jobs

### Fishing

v2023:

-   We used "People employed in fishing sectors excluding inland fisheries, total by occupation rate, thousands" from [OECD: Sustainable Ocean Economy](https://stats.oecd.org/Index.aspx?QueryId=95228#) as the primary data set.
    -   Metadata is available for download through the portal. This platform is being retired, this data set will likely be located in the [OECD Data Explorer](https://data-explorer.oecd.org/) in future years.
-   Additional countries were filled in using the number of fishers data from the [2019 FAO yearbook](#0).
-   We were not able to separate subsistence fishing from other fishing jobs, as the data only includes totals for people employed in fishing. For this reason the sector has been renamed from commercial fishing to fishing.
-   It is worth noting that using a value of 1 job for all employment is different from the original methods. Previously these methods were used: "Employment is disaggregated into full-time, parttime, occasional, and unspecified statuses. These categories are defined as full time workers having \> 90% of their time or livelihood from fishing/aquaculture, part time workers are between 30-90% time (or 30-90% of their livelihood) and occasional workers are \< 30% time. Unspecified status workers could fall anywhere from 0-100% time. Taking the midpoints of those ranges, we assume that 1 part time worker = 0.6 full time workers, 1 occasional worker = 0.15 full time workers, and 1 unspecified worker = 0.5 full time workers, which we used as a weighting scheme for determining total numbers of jobs."
-   A disaggregation version of the OECD data can be found in OECD's [Employment in fisheries, aquaculture and processing Database](#0) if needed. We did not use the dis-aggregated data, as the disaggregated numbers were not available for the FAO data which was used to gapfill.
-   Even after using FAO data to gapfill, there are still only 77 countries with available data. Further gapfilling will be necessary.

v2024:

-   We used the ["Employment in fisheries, aquaculture and processing"](%22https://data-explorer.oecd.org/vis?fs%5B0%5D=Topic%2C1%7CAgriculture%20and%20fisheries%23AGR%23%7CFisheries%20and%20aquaculture%23AGR_FSA%23&pg=0&fc=Topic&bp=true&snb=6&vw=tb&df%5Bds%5D=dsDisseminateFinalDMZ&df%5Bid%5D=DSD_FISH_EMP%40DF_FISH_EMPL&df%5Bag%5D=OECD.TAD.ARP&df%5Bvs%5D=1.0&dq=.A...._T._T&pd=2009%2C2021&to%5BTIME_PERIOD%5D=false&ly%5Bcl%5D=TIME_PERIOD&ly%5Brs%5D=REF_AREA&ly%5Brw%5D=DOMAIN%22) dataset from OECD as the primary dataset.

### Mariculture

-   We used [OECD Sustainable Ocean Economies](https://www.google.com/url?q=https://stats.oecd.org/Index.aspx?QueryId%3D95228%23&sa=D&source=editors&ust=1694558475957922&usg=AOvVaw0YmPDwvN_uKIAReu61df6G) data on people employed in aquaculture sector (marine and inland), total by occupation rate, thousands.

    -   Metadata is available for download through the portal. This platform is being retired, this data set will likely be located in the [OECD Data Explorer](https://data-explorer.oecd.org/) in future years.

-   Additional jobs data is filled in from the [2019 FAO yearbook](#0).

-   Because this data included both marine and inland values, we estimate the proportion of total aquaculture jobs that can be attributed to marine and brackish aquaculture. We used country and year specific proportions of marine and brackish aquaculture revenues (compared to total revenues) calculated from FAO aquaculture production value data set.

-   See note in fishing about data disaggregation for fulltime, partime, occassional and status unspecified.

-   Even after using two datasets to fill in additional countries, there are only 57 countries with data, further gapfilling will be needed.

### Fish Processing

-   Data for the fishery processing sector is from the [OECD: Sustainable Ocean Economy](#0) database. We use the variable: "People employed in fishery processing sector (marine and inland), total by occupation rate, thousands"

    -   Metadata is available for download through the portal. This platform is being retired, this data set will likely be located in the [OECD Data Explorer](https://data-explorer.oecd.org/) in future years.

-   Due to timing constraints we did not determine a method to subset this data to only marine related fishery processing in 2023. **This will needed to be added to the cleaning script once a method is determined.**

-   There are only 49 countries included in this dataset, further gapfilling will be needed.

### Tourism

Takeaways from the methods:

-   Original data source was "The World Travel & Tourism Council (WTTC) provides data on travel and tourism's total contribution to employment for 180 countries (<http://www.wttc.org/eng/Tourism_Research/Economic_Data_Search_Tool/>).

-   WTTC provides projected data, however, we do not use these values. We used total employment data to avoid the use of literature derived multiplier effects.

-   The WTTC shares a significant drawback with UNTWO data, in that data on coastal/marine and inland tourism are lumped. Therefore, a country-specific coefficient must be applied to estimate the jobs provided by coastal/marine tourism alone. We adjusted national tourism data by the proportion of a country's population that lives within a 25 mile inland coastal zone."

The optimal data source for revenue from tourism was not finalized in 2023. There are multiple potential options.

**WTTC Data:** Jobs data is the original source of data used for this goal. This data is no longer available online, however it was used by the tourism goal until 2022, and downloaded versions of the data are available on MAZU.

```         
-   WTTC Jobs data was last cleaned in the 2022 version of the repository and is located here:

    `"~/OHI_repositories/ohiprep_v2023/globalprep/tr/v2022/intermediate/wttc_empd_rgn.csv"`
```

**UNWTO Data**: [Number of Employees by tourism industry.](https://www.unwto.org/tourism-statistics/key-tourism-statistics)

-   The latest version from 2023 is located on Mazu:

```         
`/home/shares/ohi/git-annex/globalprep/_raw_data/UNWTO/d2023/unwto-employment-data.xlsx.`
```

-   This data had too many missing values to be used in the tourism and recreation goal, so extensive gapfilling will be needed.

-   A cleaning script was created for this data in the exploratory phase of the 2023 tourism update `~/OHI_repositories/ohiprep_v2023/globalprep/tr/v2023/unused_R/process_UNWTO_employ.R`

**Ilostat**: [Employment by sex and occupation - ISCO level 2 (thousands) - Annual](https://www.ilo.org/shinyapps/bulkexplorer9/?lang=en&id=EMP_TEMP_SEX_OC2_NB_A)

-   Latest version from 2023 is located on Mazu

    `/home/shares/ohi/git-annex/globalprep/_raw_data/ILOSTAT/d2023EMP_TEMP_SEX_OC2_NB_A-filtered-2023-07-28.csv`

-   A cleaning script was created for this data in the exploratory phase of the 2023 tourism update `~/OHI_repositories/ohiprep_v2023/globalprep/tr/v2023/unused_R/process_ILOSTAT.R`

-   This data had too many missing values to be used in the tourism and recreation goal, so extensive gapfilling will be needed.

**OECD**: [Enterprises and employment in tourism](https://doi.org/10.1787/065e083a-en)

-   Latest version from 2023 is located on Mazu

    `/home/shares/ohi/git-annex/globalprep/_raw_data/OECD/d2023/TOURISM_ENTR_EMPL_31072023210756847.csv`

-   A cleaning script was created for this data in the exploratory phase of the 2023 tourism update `~/OHI_repositories/ohiprep_v2023/globalprep/tr/v2023/unused_R/process_OECD.R`

-   This data had too many missing values to be used in the tourism and recreation goal, so extensive gapfilling will be needed.

**Eurostat:** [Employed persons by full-time/part-time activity and NACE Rev. 2 activity](https://ec.europa.eu/eurostat/data/database) (tour_lfs1r2)

-   Latest version from 2023 is located on Mazu

    `/home/shares/ohi/git-annex/globalprep/_raw_data/OECD/d2023/tour_lfs1r2_linear.csv`

<!-- -->

-   A cleaning script was created for this data in the exploratory phase of the 2023 tourism update `~/OHI_repositories/ohiprep_v2023/globalprep/tr/v2023/unused_R/process_Eurostat.R`

-   This data had too many missing values to be used in the tourism and recreation goal, so extensive gapfilling will be needed.

For information on data for calculating proportion of the population within 25 miles of the coast, see the above tourism revenue section.

### Ocean Energy

-   Data for marine renewable energy was previously only available for two countries, one was obtained through a news release, the other through personal communication. We were not able to use this old data or find an updated data source.

### Marine Mammal Watching

-   No new data was available for this sector, so previous data from [O'Connor et al 2009](https://www.mmc.gov/wp-content/uploads/whale_watching_worldwide.pdf) was used.
-   Data was extracted from a pdf of this paper stored on MAZU
-   Jobs are based on number of whale watchers in a country and a regional average number of whale watchers per employee. Includes all marine mammal watching.
-   We attempted to replicate the methods described in the OHI supplemental methods, this involved quantifying the percent of marine mammal watching that was marine vs freshwater, and then multiplying this by total jobs to find total marine jobs.
    -   We modified the methods used to determine percent marine to a programmatic approach using habitat classification from the IUCN Red List api. Percent marine was calculated as an exact percentages (total species marine/total species) instead of grouping countries into 50%, 90% or 100% marine.

# Wages

### Tourism, fishing, ports and harbors, ship and boat-building.

-   The [OWW databas](https://www.nber.org/research/data/occupational-wages-around-world-oww-database)e is used to determine wages for all sectors where data is available: tourism, fishing, ports and harbors, ship and boat-building.
-   The last year of data available is 2008, however this is still an update from the original livelihoods calculations as the OHI methods state we originally used a version of the database that stopped in 2003.
-   I performed only minimal cleaning of this data- as some of the cleaning relies on determining next steps:
    -   The methods state that we need to: divided by the inflation conversion factor for 2010 so that wage data across years would be comparable (<http://oregonstate.edu/cla/polisci/sahr/sahr>), then multiply by the purchasing power parity-adjusted per capita gdp (ppppcgdp, WorldBank) and finally multiply the adjusted wage by 12 to get annual wages
    -   I did not complete these steps as I assume it is likely we will be using an inflation conversion factor for a year other than 2010.
    -   It was also unclear how wages were determined for sectors with more than one occupation in the dataset. I assume that these may have been average.
    -   An additional data set that is available is the ilo data set, which has fishing sector wages through 2022. We didn't include this data for consistency reasons, since all other sector wage data was available only until 2008, and the interpolation methods may not be the same between data sets. However this data set is stored on MAZU in case it is needed in the future, it can be found at "`/home/shares/ohi/git-annex/globalprep/_raw_data/ILOSTAT/d2023/ILO_earnings_economic.csv" if needed in the future.`
