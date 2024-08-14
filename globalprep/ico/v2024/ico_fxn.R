# ico_fxn.R
# created Jun2015 by Casey O'Hara
# functions to support calculations of the Iconic Species subgoal.


message('NOTE: ico_fxn.R requires that the following variables be set in the global environment (main script):\n')
message(sprintf('dir_data:  currently set to \'%s\'\n', dir_data))
message(sprintf('scenario: currently set to \'%s\'\n\n', version_year))

## We use this ----
#############################################################################=
get_ico_list <- function(reload = TRUE) {
  ### This function loads the ico_global_list.csv to determine which species to
  ### consider for ICO (as well as global and regional ICO status); then attaches 
  ### this ICO species list to the IUCN master species list.  
  
  ico_list_file <- file.path(dir_here, 'int/ico_global_list.csv')
  ico_raw_file <- file.path(dir_data, 'ico/ico_global_list2016.csv')
  
  if(file.exists(ico_list_file) & !reload) {
    message(sprintf('Reading prepped iconic species list from: \n  %s\n', ico_list_file))
    ico_list <- readr::read_csv(ico_list_file)
  } else {
    message(sprintf('Prepping new ICO list from raw iconic species list: \n  %s\n', ico_raw_file))
    ico_list_raw <- readr::read_csv(ico_raw_file) %>%
      dplyr::select(rgn_name   =  Country, 
                    comname    = `Specie Common Name`,  
                    sciname    = `Specie Scientific Name`, 
                    ico_flag   = `Flagship Species`,
                    ico_local  = `Priority Species_Regional and Local`,
                    ico_global = `Priority Species_Global`,
                    ico_rgn    = `Nation Specific List`
      )
    # clean up names
    ico_list_raw <- ico_list_raw %>%
      dplyr::mutate(rgn_name = stringr::str_trim(rgn_name),
                    sciname  = stringr::str_trim(sciname),
                    comname  = stringr::str_trim(comname)) %>%
      dplyr::filter(sciname != '')  
    
    # convert global, flagship, and local iconic flags into single global iconic flag
    # ??? NOTE: 'local' is just humpbacks and minkes, across 50-60 countries each. Just call it global?
    ico_list <- ico_list_raw %>%
      dplyr::mutate(ico_gl = (!is.na(ico_global) | !is.na(ico_local) | !is.na(ico_flag))) %>%
      dplyr::select(-ico_global, -ico_local, -ico_flag) 
    
    ### Old method here::here('../ohi-global/eez/layers/rgn_global.csv') 
    rgn_name_file <- 'https://raw.githubusercontent.com/OHI-Science/ohi-global/draft/eez/layers/rgn_global.csv' 
    rgn_names <- readr::read_csv(rgn_name_file)
    ico_list <- ico_list %>%
      dplyr::left_join(
        ico_list %>%
          dplyr::filter(ico_rgn != '') %>%
          dplyr::select(rgn_name, sciname) %>%
          dplyr::left_join(rgn_names, by = c('rgn_name' = 'label')),
        by = c('rgn_name', 'sciname')) %>% 
      dplyr::rename(ico_rgn_id = rgn_id) %>% 
      # note: check that all countries properly translate on this. 
      # Should be easy since I can control the rgn-specific country names in the spreadsheet.
      dplyr::select(-rgn_name, -ico_rgn) %>%
      dplyr::mutate(ico_rgn_id = ifelse(ico_gl, NA, ico_rgn_id)) %>% ### 
      ### if globally iconic, rgn_id is unimportant - results in duplicates
      unique()
    
    message(sprintf('Writing prepped iconic species list to: \n  %s\n', ico_list_file))
    
    readr::write_csv(ico_list, ico_list_file)
  }
  
  return(ico_list)
}

## Do we use this one?  NO.  ----
#############################################################################=
get_ico_details = function(sid, download_tries = 10) {
  ### function to extract subpopulation information and population trend information
  ### for a species, given the IUCN species ID.
  ### example species Oncorhynchus nerka: sid=135301 # (parent) ## sid=135322 # (child)  # sid=4615
  url <- sprintf('http://api.iucnredlist.org/details/%d/0', sid)
  htm <- file.path(dir_data_iucn, sprintf('iucn_details/%d.htm', sid)) # htm = '135322.htm'
  
  i <- 0
  while (!file.exists(htm) | (file.info(htm)$size == 0 & i < download_tries)){
    download.file(url, htm, method = 'auto', quiet = TRUE, mode = 'wb')
    i <- i + 1
  }
  
  if (file.info(htm)$size == 0) stop(sprintf('Only getting empty file for: %s', url))
  h <- htmlParse(htm)
  #  countries <- as.character(xpathSApply(h, '//ul[@class="country_distribution"]/li/ul/li', xmlValue))
  native  <- as.character(XML::xpathSApply(h, '//ul[@class="country_distribution"]/li[div="Native"]/ul/li', xmlValue)) %>%
    as.data.frame() %>% dplyr::mutate(rgn_type = 'native')
  pos_ex  <- as.character(xpathSApply(h, '//ul[@class="country_distribution"]/li[div="Possibly extinct"]/ul/li', xmlValue)) %>%
    as.data.frame() %>% dplyr::mutate(rgn_type = 'possibly extinct')
  rgn_ex  <- as.character(xpathSApply(h, '//ul[@class="country_distribution"]/li[div="Regionally extinct"]/ul/li', xmlValue)) %>%
    as.data.frame() %>% dplyr::mutate(rgn_type = 'regionally extinct')
  reintro <- as.character(xpathSApply(h, '//ul[@class="country_distribution"]/li[div="Reintroduced"]/ul/li', xmlValue)) %>%
    as.data.frame() %>% dplyr::mutate(rgn_type = 'reintroduced')
  # ??? check for possibly/regionally extinct in here as well
  # NOTE greater specificity 
  #   for http://www.iucnredlist.org/details/135322/0 -- United States (Alaska) 
  #   vs  http://api.iucnredlist.org/details/135322/0 -- United States
  #countries = xpathSApply(h, '//td[@class="label"][strong="Countries:"]/following-sibling::td/div/text()', xmlValue)    
  countries = dplyr::bind_rows(native, pos_ex, rgn_ex, reintro)
  names(countries)[1] = 'rgn_name'
  return(countries)
}
# ??? update to scrape possibly/regionally extinct countries


## Do we use this one?  NO.  ----  
#############################################################################=
get_ico_details_all <- function(ico_spp_list, reload = FALSE) {
  ### gets a list of countries in which parents and subpops appear, from
  ### the scraped data in iucn_details.
  
  ico_rgns_file <- file.path(dir_data, 'tmp/ico_rgns.csv')
  if(!file.exists(ico_rgns_file) | reload == TRUE) {
    message('Creating temporary ICO regions list.\n')
    ico_rgns <- data.frame() # initialize
    
    for (sid in ico_spp_list$iucn_sid) { # sid = ico_spp_list$iucn_sid[3]
      region_list <-  get_ico_details(sid)
      # subpop
      if (length(region_list) > 0) {
        message(sprintf('Found native regions for species %d: %s\n', sid, paste(region_list[region_list$rgn_type == 'native', 1], collapse = ' ')))
        message(sprintf('Possibly/regionally extinct regions for species %d: %s\n', sid, paste(region_list[region_list$rgn_type != 'native', 1], collapse = ' ')))
        ico_regions_sid <- data.frame(sid, region_list)
        ico_rgns     <- rbind(ico_rgns, ico_regions_sid)
      }
    }
    
    message(sprintf('Writing temporary ICO regions file to: \n  %s\n', ico_rgns_file))
    readr::write_csv(ico_rgns, ico_rgns_file)
  } else {
    message(sprintf('Reading parent/subpop countries file from: \n  %s\n', ico_rgns_file))
    ico_rgns <- readr::read_csv(ico_rgns_file)
  }
  ico_rgns <- ico_rgn_name_to_number(ico_rgns)
  return(ico_rgns)
}

## Do we use this one?  YES.  ----  
#############################################################################=
get_from_api <- function(url, param, api_key, delay) {
  #  param = param_vec[which(param_vec == "12419")]
  i <- 1; tries <- 5; success <- FALSE
  
  while(i <= tries & success == FALSE) {
    message('try #', i)
    Sys.sleep(delay * i) ### be nice to the API server? later attempts wait longer
    api_info <- jsonlite::fromJSON(sprintf(url, param, api_key)) 
    if (class(api_info) != 'try-error') {
      success <- TRUE
    } else {
      warning(sprintf('try #%s: class(api_info) = %s\n', i, class(api_info)))
    }
    message('... successful? ', success)
    i <- i + 1
  }
  
  if (class(api_info) == 'try-error') { ### multi tries and still try-error
    api_return <- data.frame(
      param_id  = param,
      api_error = 'try-error after multiple attempts'
    )
  } 
  else if (class(api_info$result) != 'data.frame') { ### result isn't data frame for some reason
    api_return <- data.frame(
      param_id  = param,
      api_error = paste('non data.frame output: ', class(api_info$result),
                        ' length = ', length(api_info$result))
    )
  } 
  else if (length(api_info$result) == 0) { ### result is empty
    api_return <- data.frame(
      param_id  = param,
      api_error = 'zero length data.frame'
    )
  } 
  else {
    api_return <- api_info %>%
      data.frame(stringsAsFactors = FALSE)
  }
  
  return(api_return)
}

## We use this  ----  
#############################################################################=
mc_get_from_api <- function(url, param_vec, api_key, cores = NULL, delay = 0.5) {
  
  if (is.null(cores)) {
    numcores <- ifelse(Sys.info()[['nodename']] == 'mazu', 12, 1)
  } else {numcores <- cores}
  
  out_list <- parallel::mclapply(
    param_vec, 
    function(x) get_from_api(url, x, api_key, delay),
    mc.cores   = numcores,
    mc.cleanup = TRUE
  ) 
  
  if(any(sapply(out_list, class) != 'data.frame')) {
    error_list <- out_list[sapply(out_list, class) != 'data.frame']
    message('List items are not data frame: ', paste(sapply(error_list, class), collapse = '; '))
    message('might be causing the bind_rows() error; returning the raw list instead')
    return(out_list)
  }
  
  out_df <- out_list %>%
    dplyr::bind_rows() %>%
    setNames(names(.) %>% stringr::str_replace('result.', ''))
  return(out_df)
}

## Do we use this one?  NO.  ----  
#############################################################################=
ico_rgn_name_to_number <- function(ico_countries) {
  rgn_name_file <- 'https://raw.githubusercontent.com/OHI-Science/ohi-global/draft/eez/layers/rgn_global.csv'
  # rgn_name_file <- '~/github/ohi-global/eez2013/layers/rgn_global.csv'
  rgn_names <- readr::read_csv(rgn_name_file) %>%
    dplyr::rename(rgn_name = label)
  
  rgn_iucn2ohi <- read_csv(file.path(dir_data, 'rgns/rgns_iucn2ohi.csv'))
  ico_countries <- ico_countries %>%
    dplyr::left_join(rgn_names,
                     by = 'rgn_name')
  ico_countries <- ico_countries %>%
    dplyr::left_join(rgn_iucn2ohi, 
                     by = c('rgn_name' = 'iucn_rgn_name')) %>%
    dplyr::mutate(rgn_id   = ifelse(is.na(rgn_id),       ohi_rgn_id, rgn_id),
                  rgn_name = ifelse(is.na(ohi_rgn_name), rgn_name,   sprintf('%s WAS %s', ohi_rgn_name, rgn_name))) %>%
    dplyr::filter(!is.na(rgn_id)) %>% # comment this out to check that all country names get an ID
    dplyr::select(-ohi_rgn_id, -ohi_rgn_name)
  return(ico_countries)
}
# ??? good - may need to update with new mismatches
# This function is necessary for translating country lists from IUCN sites, with mismatches
# - so comes after all that process.
# Converts ALL the regions into rgn_id - should start with the basic region list as in 
# the get_ico_list function, and then apply patches afterward?
# OR: bind the patch list to Melanie's rgn name to number table and do it one swoop.


## Do we use this one?  NO.  ----  
#############################################################################=
process_ico_rgn <- function(ico_rgn_list) {
  ### Summarize category and trend for each region.
  
  # to overall lookup table, join scores for population category and trend.
  popn_cat    <- data.frame(category  = c('LC', 'NT', 'VU', 'EN', 'CR', 'EX'), 
                            category_score = c(   0,  0.2,  0.4,  0.6,  0.8,   1))
  popn_trend  <- data.frame(trend=c('decreasing', 'stable', 'increasing'), 
                            trend_score=c(-0.5, 0, 0.5))
  ico_rgn_list <- ico_rgn_list %>%
    dplyr::left_join(popn_cat,   by = 'category') %>%
    dplyr::left_join(popn_trend, by = 'trend') %>%
    dplyr::select(-category, -trend)
  
  ### This section aggregates category and trend for a single species sciname within a region,
  ### including parent and all subpopulations present in a region.
  ### Species, including parent and all subpops, is weighted same as species w/o parents and subpops.
  ico_rgn_list <- ico_rgn_list %>%
    dplyr::group_by(rgn_id, sciname) %>%
    dplyr::summarize(category_score = mean(category_score), trend_score = mean(trend_score, na.rm = TRUE))
  
  ico_rgn_sum <- ico_rgn_list %>%
    dplyr::group_by(rgn_id) %>%
    dplyr::summarize(mean_cat = mean(category_score), mean_trend = mean(trend_score, na.rm = TRUE))
  
  ico_rgn_sum_file <- file.path(dir_git, version_year, 'summary/ico_rgn_sum.csv')
  message(sprintf('Writing file for iconic species summary by region: \n  %s\n', ico_rgn_sum_file))
  readr::write_csv(ico_rgn_sum, ico_rgn_sum_file)
  
  return(invisible(ico_rgn_sum))
}

