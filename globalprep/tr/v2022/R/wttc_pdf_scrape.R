
### This script scrapes all the PDF download links from the WTTC Economic Impact page (URL below), downloads those files to a temporary directory, and reads the tables in (as best as tabulizer can). The purpose of this is to extract change in "Total contribution of Travel & Tourism to Employment" for each country in order to gapfill values from the WTTC that the TTDI doesn't offer (territories). Running the full script will result in writing a csv with the desired values and will delete the PDFs from Mazu after. Some years are hardcoded into strings below and will need to be changed for future uses.


library(tidyverse)
library(here)
library(rvest)
library(tabulizer)
library(purrr)

# pull html from the page of interest
page <- read_html("https://wttc.org/Research/Economic-Impact")

# name and create our download destination folder
pdf_dir <- here(paste0("globalprep/tr/v", version_year, "/wttc_pdfs/"))
dir.create(pdf_dir)

raw_list <- page %>% # takes the page above for which we've read the html
  html_elements("a") %>%  # find all links in the page
  html_attr("href") %>% # get the url for these links
  str_subset("/QuickDownload") %>% 
  unique() %>% 
  walk2(., paste0(pdf_dir, "wttc_", # extract unique identifier from URL for file name, and download file
                  (str_remove(., "https://wttc.org/Research/Economic-Impact/moduleId/704/itemId/") %>% 
                     str_remove("/controller/DownloadRequest/action/QuickDownload")), ".pdf"),
        download.file, mode = "wb")

# vector of names of files we downloaded
files <- list.files(here(paste0("globalprep/tr/v", version_year, "/wttc_pdfs")))

n_countries <- length(files)

# dataframe to be populated with extracted values
tr_jobs_pct_change <- data.frame("country" = vector(mode = "character", length = n_countries),
                                 "pct_change_2020" = vector(mode = "character", length = n_countries),
                                 "pct_change_2021" = vector(mode = "character", length = n_countries))

# this loops reads in the pdf tables using `tabulizer::extract_tables()`, pulls out the country name and the two percent change values we're interested in and then inserts them into the output dataframe
for (i in seq_along(files)) {
  
  df <- extract_tables(
    file = paste0("globalprep/tr/v", version_year, "/wttc_pdfs/", files[i]), 
    pages = 1,
    area = list(c(360, 38, 1120, 770)),
    method = "decide", 
    output = "data.frame")
  
  country <- df[[1]][2, 1] %>% 
    str_remove(" Key Data")
  
  pct_change_2020 <- df[[1]][15, 1] %>% 
    str_remove("Change: ") %>% 
    str_remove("%") %>% 
    as.numeric()
  
  pct_change_2021 <- df[[1]][16, 1] %>% 
    str_remove("Change: ") %>% 
    str_remove("%") %>% 
    as.numeric()
  
  tr_jobs_pct_change[i, ] <- c(country, pct_change_2020, pct_change_2021)
  
}

# save the csv which is then read in in the full workflow
write_csv(tr_jobs_pct_change, here(paste0("globalprep/tr/v", version_year, "/intermediate/tr_jobs_pct_change.csv")))

# This will delete all the downloaded pdfs from Mazu - they aren't needed beyond this point
unlink(pdf_dir, recursive = TRUE)


