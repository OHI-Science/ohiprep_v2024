# Status of Livelihoods and Economies Update

Acronyms for sectors used in the original output layers:

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

In 2024 we cleaned and prepped the best available data for most sectors and components included in this goal. The ECO subgoal was pursued, but LIV was tabled due to a lack of data in the fishing (cf) sector. When newly updated data wasn't available, we re-downloaded and cleaned the previous data source. ohiprep_v2023 contains all scripts and data produced during the 2023 fellows' deep dive. All of the cleaned files are now saved in the folder `~/ohiprep_v2024/globalprep/le/v2024/int` .

We produced three steps to calculate the overall ECO subgoal score:

*FIRST*:

-   **3 scripts, each one produces a dataset**: e.g., eco_cf_prep.Rmd (rgn_id, rgn_name, year, usd, unit, sector, usd_yr). Make sure that all the USD are in the same units!!! e.g., non-inflation adjusted, or inflation adjusted to same year, etc.

    -   usd = "value", in US Dollars

    -   usd_yr is a column to describe what year the column "usd" was adjusted to. If there were no adjustments, usd_yr would equal year.

    -   Cleaning the data

        -   Don’t filter dates here. This will be done procedurally downstream

        -   This will ideally end with columns:  **country**, **year**, **usd** (value), **unit** (currency), **sector**, **data_source**

    -   Assigning countries to OHI regions where possible

        -   Done using the **name_2_rgn()** function from ohicore

        -   Check that values align and that there are no duplicated countries

    -   Add column **usd_yr** that contains the year that the associated **usd** value is currently adjusted to

        -   Example: If I have a value for each year from 1984-2022, each with a value that was adjusted to USD for that year, my **usd_yr** column would be each year from 1984-2022, because 1984’s value is adjusted to 1984 USD, and 1985’s value is adjusted to 1985 USD 

        -   Example: If all of my data were already adjusted to 2015 USD, my **usd_yr** column would contain only 2015

    -   This step should end with multiple scripts, one for each sector with the following naming conventions: 

        -   eco\_”sector abbreviation”\_prep.Rmd → creating the eco\_”sector abbreviation”\_usd_pre.csv file

        -   Ex: “eco_mar_prep.Rmd” creates “eco_mar_usd_pre.csv”

*SECOND*:

-   **1 script, produce 1 dataset**: eco_usd_adj.Rmd (rgn_id, rgn_name, year, unit, sector, usd_yr, usd_adj): script that takes care of all layers: adjusts for inflation and combines sectors into 1 csv.

    -   With the previously made dataframes in the correct file structure, this script’s job will be to read them in and adjust “usd” columns for inflation. This will be done using the “priceR” package.

    -   First the user will follow the steps at the top to read in the data for each sector and rbind them on top of each other because each df should have the same number/order of columns

        -   Then they will use a small chunk of code to identify the **most recent minimum year (highest minimum)** in each of the datasets. Due to the nature of calculating the score, we found that it was important that the bound “score calculation” df have the range of years that corresponds to the most recent minimum year and to the most recent shared maximum year **(lowest maximum)** 

    -   We made a small function that takes each of the eco_sector_usd_pre.csv dataframes, the year that you want each value to be inflation-adjusted for, the country of the currency that the value is in, and the year of assessment. 

        -   This function then draws out relevant values from the df for both usd and usd_yr, adjusts the values for inflation to your desired year, and 

            -   1\. Adds a column onto the sector df that contains the adjusted values for usd

            -   2\. Writes a csv out to the ‘int’ folder with the naming structure eco\_”sector abbreviation”\_usd_adj.csv 

                -   This is so as to be able to track changes in real time as well as look back/forward when working on a different script

*THIRD*:

-   **1 script, calculates score** (use the methods: <https://oceanhealthindex.org/images/htmls/Supplement.html#67_Livelihoods_and_economies>)

### v2023 updates:

Detailed methods and explanations for v2023's work are available in the livelihoods_economies_dataprep.RMD saved in `~/ohiprep_v2023/globalprep/le/v2023`. Included below is a summary of what tasks were completed in the 2023 methods update.

For all datasets, except tourism revenue, the current format has one value for each country and year included in the dataset. Tourism uses a pre-cleaned version of the revenue data, so countries have already been converted to regions. We did not do any gapfilling to fill in countries missing from the cleaned data sets, so this will likely need to be done for most of the included data.

Acronyms for sectors used in the original output layers are used for simplicity of incorporating into the finalized OHI model. A new sector fish processing FP was added in this analysis, and will need to be incorporated into the model.

### v2024 updates:
