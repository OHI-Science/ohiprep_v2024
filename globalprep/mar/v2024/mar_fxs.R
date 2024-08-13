mar_split <- function(m) {
  ### Deal with special cases of countries, specific to MAR: Netherlands Antilles reported multiple ways, including 'Bonaire/S.Eustatius/Saba' 
  ### - FAO reports 'Antilles' as one region, but OHI considers as four 
  ###   reported regions; break up and distribute values 
  
  m_ant <- m %>%
    filter(country == 'Netherlands Antilles') %>%  # Conch was cultivated for restoration purposes in a joint programme across these 3 countries
    mutate(value = (value/3),  
           'Aruba' = value,
           'Bonaire' = value,
           'Curacao' = value) %>%
    select(-c(value, country)) %>%
    pivot_longer(cols = c("Aruba", "Bonaire", "Curacao"),
                 names_to = "country",
                 values_to = "value") %>%
    mutate(country = as.character(country),
           value = as.numeric(value)) %>% 
    select(c(country, fao, environment, species, year, Taxon_code, family, value))
  
  m <- m %>%
    filter(country != 'Netherlands Antilles') %>%
    bind_rows(m_ant) %>%  
    arrange(country, fao, environment, species, year, value) 
  
  # 2024 update
  m_ant2_new <- m %>%
    filter(country == "Bonaire, Sint Eustatius and Saba") %>%  # update in 2024 for new name string
    mutate(
      value = (value/3),
      'Bonaire' = value,
      'Saba' = value,
      'Sint Eustatius' = value) %>%
    select(-c(value, country)) %>%
    pivot_longer(cols = c("Bonaire", "Saba", "Sint Eustatius"),
                 names_to = "country",
                 values_to = "value") %>% 
    mutate(country = as.character(country),
           value = as.numeric(value)) %>% 
    select(c(country, fao, environment, species, year, Taxon_code, family, value))
  
  m <- m %>%
    filter(!country %in% c("Bonaire, Sint Eustatius and Saba")) %>%
    bind_rows(m_ant2_new) %>% 
    arrange(country, fao, environment, species, year, value)
  
  m_ant2 <- m %>%
    filter(country == 'Bonaire/S.Eustatius/Saba') %>%  # Cobia was probably mostly in Curacao, but can't find evidence for it
    mutate(
      value = (value/3),
      'Bonaire' = value,
      'Saba' = value,
      'Sint Eustatius' = value) %>%
    select(-c(value, country)) %>%
    pivot_longer(cols = c("Bonaire", "Saba", "Sint Eustatius"),
                 names_to = "country",
                 values_to = "value") %>% 
    mutate(country = as.character(country),
           value = as.numeric(value)) %>% 
    select(c(country, fao, environment, species, year, Taxon_code, family, value))
  
  m <- m %>%
    filter(country != 'Bonaire/S.Eustatius/Saba') %>%
    bind_rows(m_ant2) %>% 
    arrange(country, fao, environment, species, year, value) 
  
  m_ant3 <- m %>%
    filter(country == 'Channel Islands') %>%
    mutate(
      value = (value/2),
      'Guernsey' = value,
      'Jersey' = value) %>%
    select(-c(value, country)) %>%
    pivot_longer(cols = c("Guernsey", "Jersey"),
                 names_to = "country",
                 values_to = "value") %>%
    mutate(country = as.character(country),
           value = as.numeric(value)) %>% 
    select(c(country, fao, environment, species, year, Taxon_code, family, value))
  
  # m_ant3 <- m %>%
  #   filter(country == 'Channel Islands') %>%
  #   mutate(
  #     value = (value/2),
  #     'Guernsey' = value,
  #     'Jersey' = value) %>%
  #   select(-c(value, country)) %>%
  #   gather(country, value, -species, -fao, -environment, -year, -Taxon_code) %>% # pre 2024 version
  #   mutate(country = as.character(country)) 
  
  m <- m %>%
    filter(country != "Channel Islands") %>%
    bind_rows(m_ant3) %>%  
    arrange(country, fao, environment, species, year, value) 
  
  
  return(m)
}

