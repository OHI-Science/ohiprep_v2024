ao_split <- function(m) {
  ### Deal with special cases of countries, specific to AO.  
  ### - UNEP reports 'Bonaire, Sint Eustatius and Saba' as one region, but OHI considers as three separately
  ###   reported regions; break up and distribute values 
  
  stopifnot( sum(c('Bonaire','Saba','Sint Maarten','Sint Eustatius') %in% m$country) == 0 )
  m_ant <- m %>%
    filter(country == 'Netherlands Antilles') %>%
    mutate(
      value            = value/4,
      'Bonaire'        = value,
      'Saba'           = value,
      'Sint Maarten'   = value,
      'Sint Eustatius' = value) %>%
    select(-value, -country) %>%
    gather(country, value, -commodity, -product, -year) %>%
    mutate(country = as.character(country))  # otherwise, m_ant$country is factor; avoids warning in bind_rows bel
  m1 <- m %>%
    filter(country != 'Netherlands Antilles') %>%
    bind_rows(m_ant)
  return(m1)
}
