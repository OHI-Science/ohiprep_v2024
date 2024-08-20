# v2023: THE RESULTS OF THIS CAUSED A PIVOT TO OTHER DATA OPTIONS; CODE WAS LEFT HERE IN CASE IT BECOMES RELEVANT IN FUTURE EXPLORATIONS

library(tidyverse)
library(ohicore)

# change paths to where your data is stored; local paths left as examples
base_path <- "put anything preceding the folder and/or file name here"
file_path_receipts_dollars <- paste0(base_path, "API_ST/API_ST.INT.RCPT.CD_DS2_en_csv_v2_5734207.csv")
file_path_receipts_percent <- paste0(base_path, "API_ST-2/API_ST.INT.RCPT.XP.ZS_DS2_en_csv_v2_5736344.csv")
file_path_arrivals <- paste0(base_path, "API_ST-3/API_ST.INT.ARVL_DS2_en_csv_v2_5728898.csv")
file_path_expenditures_passenger_items <- paste0(base_path, "API_ST-4/API_ST.INT.TRNX.CD_DS2_en_csv_v2_5736348.csv")
file_path_expenditures_dollars <- paste0(base_path, "API_ST-5/API_ST.INT.XPND.CD_DS2_en_csv_v2_5736352.csv")
file_path_receipts_passenger_items <- paste0(base_path, "API_ST-6/API_ST.INT.TRNR.CD_DS2_en_csv_v2_5736347.csv")
file_path_departures <- paste0(base_path, "API_ST-7/API_ST.INT.DPRT_DS2_en_csv_v2_5734520.csv")
file_path_receipts_travel_items <- paste0(base_path, "API_ST-8/API_ST.INT.TVLR.CD_DS2_en_csv_v2_5736345.csv")
file_path_expenditures_percent <- paste0(base_path, "API_ST-9/API_ST.INT.XPND.MP.ZS_DS2_en_csv_v2_5736355.csv")

file_path_tr_data <- paste0(base_path, "tourism_props_geo_gf.csv")

# source in generalized WB data processing function and use on each WB dataset
source(here(paste0("globalprep/tr/v", version_year, "/R/process_WB_generalized_fxn.R")))
process_wb_data(file_path_receipts_dollars, "receipts_dollars", "final_receipts_dollars_df")
process_wb_data(file_path_receipts_percent, "receipts_percent", "final_receipts_percent_df")
process_wb_data(file_path_arrivals, "arrivals", "final_arrivals_df")
process_wb_data(file_path_expenditures_passenger_items, "expenditures_passenger_items", "final_expenditures_passenger_items_df")
process_wb_data(file_path_expenditures_dollars, "expenditures_dollars", "final_expenditures_dollars_df")
process_wb_data(file_path_receipts_passenger_items, "receipts_passenger_items", "final_receipts_passenger_items_df")
process_wb_data(file_path_departures, "departures", "final_departures_df")
process_wb_data(file_path_receipts_travel_items, "receipts_travel_items", "final_receipts_travel_items_df")
process_wb_data(file_path_expenditures_percent, "expenditures_percent", "final_expenditures_percent_df")

# add each dataset to the tourism data (tourism employment to total workforce at the time of this exploration)
tr_data <- read_csv(file_path_tr_data) %>%
  mutate(year = as.character(year)) %>%
  left_join(final_receipts_dollars_df, by = c("year", "rgn_id")) %>%
  left_join(final_receipts_percent_df, by = c("year", "rgn_id")) %>%
  left_join(final_arrivals_df, by = c("year", "rgn_id")) %>%
  left_join(final_expenditures_passenger_items_df, by = c("year", "rgn_id")) %>%
  left_join(final_expenditures_dollars_df, by = c("year", "rgn_id")) %>%
  left_join(final_receipts_passenger_items_df, by = c("year", "rgn_id")) %>%
  left_join(final_departures_df, by = c("year", "rgn_id")) %>%
  left_join(final_receipts_travel_items_df, by = c("year", "rgn_id")) %>%
  left_join(final_expenditures_percent_df, by = c("year", "rgn_id")) %>%
  select(Ep, r1_label, r2_label, receipts_dollars, receipts_percent, 
         arrivals, expenditures_passenger_items, expenditures_dollars,
         receipts_passenger_items, departures, receipts_travel_items,
         expenditures_percent)



# get R-squareds and AIC for all model combos

# get all possible combinations of predictor variables: add other relevant ones here if added more data
predictors <- c("r1_label", "r2_label", "receipts_dollars", "receipts_percent", 
                "arrivals", "expenditures_passenger_items", "expenditures_dollars",
                "receipts_passenger_items", "departures", "receipts_travel_items",
                "expenditures_percent")
all_combinations <- unlist(lapply(1:length(predictors), function(n) combn(predictors, n, simplify = FALSE)), recursive = FALSE)

# this function fits linear models and gets R-squared and AIC values
get_model_stats <- function(predictors) {
  formula <- as.formula(paste("Ep ~", paste(predictors, collapse = " + ")))
  model <- lm(formula, data = tr_data)
  return(c(R_squared = summary(model)$r.squared, AIC = AIC(model)))
}

# use the function on all the combos
model_stats <- sapply(all_combinations, function(combo) get_model_stats(combo))

# combine into a dataframe for analysis
results <- data.frame(
  Combination = sapply(all_combinations, paste, collapse = " + "),
  R_squared = model_stats["R_squared", ],
  AIC = model_stats["AIC", ]
)

# order the results for highest AIC and lowest R_squared (separately)
results_AIC <- arrange(results, AIC)
results_Rsq <- arrange(results, desc(R_squared))

# view the results
View(results_AIC)
View(results_Rsq)