# Ocean Health Index 2024: Ocean Acidification Pressure Layer

## Data Source

**Overview from CMS website:**

The [data source product](https://data.marine.copernicus.eu/product/MULTIOBS_GLO_BIO_CARBON_SURFACE_REP_015_008/description) corresponds to a REP L4 time series of monthly global reconstructed surface ocean pCO2, air-sea fluxes of CO2, pH, total alkalinity, dissolved inorganic carbon, saturation state with respect to calcite and aragonite, and associated uncertainties on a 0.25° x 0.25° regular grid.
The product is obtained from an ensemble-based forward feed neural network approach mapping situ data for surface ocean fugacity (SOCAT data base, Bakker et al. 2016, <https://www.socat.info/>) and sea surface salinity, temperature, sea surface height, chlorophyll a, mixed layer depth and atmospheric CO2 mole fraction.
Sea-air flux fields are computed from the air-sea gradient of pCO2 and the dependence on wind speed of Wanninkhof (2014).
Surface ocean pH on total scale, dissolved inorganic carbon, and saturation states are then computed from surface ocean pCO2 and reconstructed surface ocean alkalinity using the CO2sys speciation software \[See: Citation information\].

### Classification

**Reference:** [Copernicus Marine Service](https://data.marine.copernicus.eu/product/MULTIOBS_GLO_BIO_CARBON_SURFACE_REP_015_008/description)

**Downloaded:**

**Description**: Aragonite Saturation State $\Omega_{arg}$

**Full name:** Global Ocean Surface Carbon

**Product ID:** MULTIOBS_GLO_BIO_CARBON_SURFACE_REP_015_008

**Source:** In-situ observations

**Spatial extent:** Global OceanLat -88.12° to 89.88°Lon -179.87° to 179.88°

**Spatial resolution:** 0.25° × 0.25°

**Temporal extent:** 31 Dec 1984 to 30 Nov 2022

**Temporal resolution:** Monthly

**Processing level:** Level 4

**Variables:** Dissolved inorganic carbon in sea water (DIC), Sea water pH reported on total scale (pH), Surface partial pressure of carbon dioxide in sea water (spCO2), Surface downward mass flux of carbon dioxide expressed as carbon (fpCO2), Total alkalinity in sea water

**Feature type:** Grid

**Blue markets:** Conservation & biodiversity, Climate & adaptation, Science & innovation, Marine food

**Projection:** WGS 84 / World Mercator (EPSG 3395)

**Data assimilation:** None

**Update frequency:** Annually

**Format:** NetCDF-4

**Originating centre:** LSCE (France)

**Last metadata update:** 30 November 2023

## Methods

1.  Set-up source and file paths

2.  Download data needed

-   Automated download of new data
-   Automated download of historical data

3.  Split the global OA MultiLayer NetCDF into its individual raster layers, which are by month.

-   This would be saved in Mazu, within `/home/shares/ohi/git-annex/globalprep/prs_oa/v2024/int/oa_monthly_rasters`

4.  Raster calculations for historical and new data

-   Create a raster of the average historical values by making a `terra` RasterBrick and calculate the average over the reference years (1985 - 2000)
    -   Save within `/home/shares/ohi/git-annex/globalprep/prs_oa/v2024/int`
-   Create annual mean rasters for the new data by stacking the monthly rasters by year and using `raster::calc` to calculate the mean for that year.
    -   Save within `/home/shares/ohi/git-annex/globalprep/prs_oa/v2024/int/oa_annual_mean`

5.  Rescale each annual raster between 0 to 1 using the historical average data as a reference -- v2024 updated the function

6.  Project, resample, and check the extent of the new data, historical ref data, and zones raster from OHI

7.  Calculate Zonal Statistics using the "mean" between the zones raster and the rescaled annual rasters for each region.
    Finish by saving the dataframe within `/home/lecuona/OHI_Intro/ohiprep_v2024/globalprep/prs_oa/v2024/output`.
    
**References:**

Chau, T. T. T., Gehlen, M., and Chevallier, F.: A seamless ensemble-based reconstruction of surface ocean pCO2 and air–sea CO2 fluxes over the global coastal and open oceans, Biogeosciences, 19, 1087–1109, <https://doi.org/10.5194/bg-19-1087-2022>, 2022.

Climate Change Indicators: Ocean Acidity (2024) EPA Climate Change Indicators. Available at: <https://www.epa.gov/climate-indicators/climate-change-indicators-ocean-acidity> (Accessed: 06 August 2024). 

Barker, S. & Ridgwell, A. (2012) Ocean Acidification. Nature Education Knowledge 3(10):21.

**If using these data, please see our [citation policy](http://ohi-science.org/citation-policy/).**




  
