
# unwto_employment <- read_excel("globalprep/tr/v2022/raw/unwto_employment.xlsx")

unwto_clean <- unwto_employment[, c(4, 6, 11:(ncol(unwto_employment) - 1))]

names(unwto_clean) <- c("country", "metric", as.character(unwto_clean[2, 3:ncol(unwto_clean)]))

unwto_clean <- unwto_clean[3:nrow(unwto_clean), ] %>% 
  fill(country, .direction = "down") %>% 
  filter(metric == "Total") %>% 
  pivot_longer(cols = 3:ncol(unwto_clean), names_to = "year",
               values_to = "jobs_ct") %>% 
  mutate(jobs_ct = na_if(jobs_ct, ".."),
         country = str_to_title(country),
         jobs_ct = round(as.numeric(jobs_ct) * 1000)) %>% 
  select(-metric)

