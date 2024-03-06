mar_split <- function(m) {
  ### Deal with special cases of countries, specific to MAR: Netherlands Antilles reported multiple ways, including 'Bonaire/S.Eustatius/Saba' 
  ### - FAO reports 'Antilles' as one region, but OHI considers as four 
  ###   reported regions; break up and distribute values 
  
  m_ant <- m %>%
    filter(country == 'Netherlands Antilles') %>%  # Conch was cultivated for restoration purposes in a joint programme across these 3 countries
    mutate(value            = value/3,  
      'Aruba'        = value,
      'Bonaire'           = value,
      'Curacao'   = value) %>%
    select(-value, -country) %>%
    gather('country', 'value', -species, -fao, -environment, -year, -Taxon_code, -family) %>%
    mutate(country = as.character(country))

  m <- m %>%
    filter(country != 'Netherlands Antilles') %>%
    bind_rows(m_ant) %>%  
    arrange(country, fao, environment, species, year, value) 
    
m_ant2 <- m %>%
  filter(country == 'Bonaire/S.Eustatius/Saba') %>%  # Cobia was probably mostly in Curacao, but can't find evidence for it
  mutate(
    value            = value/3,
    'Bonaire'        = value,
    'Saba'           = value,
    'Sint Eustatius'   = value) %>%
  select(-value, -country) %>%
  gather(country, value, -species, -fao, -environment, -year, -Taxon_code, -family) %>%
  mutate(country = as.character(country)) 
m <- m %>%
  filter(country != 'Bonaire/S.Eustatius/Saba') %>%
    bind_rows(m_ant) %>% 
  arrange(country, fao, environment, species, year, value) 

m_ant3 <- m %>%
  filter(country == 'Channel Islands') %>%
  mutate(
    value            = value/2,
    'Guernsey'        = value,
    'Jersey'           = value) %>%
  select(-value, -country) %>%
  gather(country, value, -species, -fao, -environment, -year, -Taxon_code, -family) %>%
  mutate(country = as.character(country))  
m <- m %>%
  filter(country != 'Channel Islands') %>%
      bind_rows(m_ant) %>%  
  arrange(country, fao, environment, species, year, value) 


  return(m)
}

cat_msg <- function(x, ...) {
  if(is.null(knitr:::.knitEnv$input.dir)) {
    ### not in knitr environment, so use cat()
    cat(x, ..., '\n')
  } else {
    ### in knitr env, so use message()
    message(x, ...)
  }
  return(invisible(NULL))
}

add_georegion_id <- function(k) {
  ### Code from Melanie to attach a georegional id tag to dataframe k.
  region_data()
  key <- rgns_eez %>% 
    rename(cntry_key = eez_iso3) %>% 
    select(-rgn_name)
  dups <- key$rgn_id[duplicated(key$rgn_id)]
  key[key$rgn_id %in% dups, ]
  
  key  <- key %>%
    filter(!(cntry_key %in% c('Galapagos Islands', 'Alaska',
                              'Hawaii', 'Trindade', 'Easter Island',
                              'PRI', 'GLP', 'MNP')))  %>%
    select(rgn_id, cntry_key)
  #PRI (Puerto Rico) and VIR (Virgin Islands) in the same r2 zone (just selected one), 
  #GLP (Guadalupe) and MTQ (Marinique) in the same r2 zone (just selected one),  
  #MNP (Northern Mariana Islands) and GUM (Guam)
  
  
  georegion <- read.csv(file.path(here(), "globalprep/np/v2020/raw/cntry_georegions.csv"))
  
  
  georegion <- georegion %>%
    filter(level == "r2")
  
  k1 <- k %>%
    left_join(key, by = 'rgn_id') %>%
    left_join(georegion, by = 'cntry_key') %>%
    select(-cntry_key)
  ### cleaning out variables
  return(k1)
}