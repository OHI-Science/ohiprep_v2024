
# this script reads in and cleans the data tables found in the paper associated with the Global Mangrove Watch (1996 - 2020) Version 3.0 Dataset, and exports it as a csv

# Bunting, P.; Rosenqvist, A.; Hilarides, L.; Lucas, R.M.; Thomas, T.; Tadono, T.; Worthington, T.A.; Spalding, M.; Murray, N.J.; Rebelo, L-M. Global Mangrove Extent Change 1996 – 2020: Global Mangrove Watch Version 3.0. Remote Sensing. 2022



df_list <- tabulizer::extract_tables(
  file = file.path(dir_hab_mangrove, "globalMangroveWatch2022_data.pdf"),
  method = "decide", 
  output = "data.frame")


df_1 <- df_list[[1]] %>% 
  select(-1, country = Country.Territory)
names(df_1) <- gsub("X", "", names(df_1))

df_2 <- df_list[[2]] %>% 
  select(-1, country = Country.Territory)
names(df_2) <- gsub("X", "", names(df_2))

df_3 <- df_list[[3]] %>% 
  select(-1)
names(df_3) <- df_3[1, ]
df_3 <- df_3[2:nrow(df_3), ] %>% 
  rename(country = "Country/Territory") %>% 
  mutate(across(2:ncol(df_3), ~gsub(",", "", .)),
         across(2:ncol(df_3), ~as.numeric(.)))

df_4 <- df_list[[4]] %>% 
  select(-1)
names(df_4) <- df_4[1, ]
df_4 <- df_4[2:nrow(df_4), ] %>% 
  rename(country = "Country/Territory") %>% 
  mutate(across(2:ncol(df_4), ~gsub(",", "", .)),
         across(2:ncol(df_4), ~as.numeric(.)))


gmw_paper_extents <- bind_rows(list(df_1, df_2, df_3, df_4)) %>% 
  pivot_longer(cols = 2:12, names_to = "year", values_to = "km2") %>% 
  left_join(rgns_all, by = c("country" = "rgn_name")) %>% 
  select(country, year, km2, rgn_id)

write.csv(gmw_paper_extents, here(dir_hab_mangrove, "data/gmw_paper_extents_1996-2020.csv"), row.names = FALSE)

rm(df_1, df_2, df_3, df_4, df_list)
gc()





