library(raster)
library(sp)


## to source:
## source('https://raw.githubusercontent.com/cdkuempel/food_chicken_salmon/master/_spatial/template_raster.R?token=ABLMCDNSCGBY3NWPCDJRISC5JA4JI')


# food_raster <- raster(nrows=2160, ncols=4320, xmn=-180, xmx=180, ymn=-90, ymx=90)
food_crs <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"

food_raster <- raster(nrows=2160, ncols=4320)

raster_df <- function(input_raster){ #input_raster=food_raster
  template_rast <- raster(nrows=2160, ncols=4320, xmn=-180, xmx=180, ymn=-90, ymx=90)
  values(template_rast) <- 1:ncell(food_raster)
  template_df <- as.data.frame(template_rast, xy=TRUE)
  names(template_df)[3] <- "cellindex"
  if(ncell(input_raster) == ncell(template_rast)){
    final_rast <- cbind(template_df, as.data.frame(input_raster))
    return(final_rast)
  } else
    stop("Rasters are different sizes")

}
# 
# raster_df <- function(input_raster){ #input_raster=food_raster
#   template_rast <- rast(nrows=2160, ncols=4320)
#   terra::values(template_rast) <- 1:ncell(food_raster)
#   template_df <- as.data.frame(template_rast, xy=TRUE)
#   names(template_df)[3] <- "cellindex"
#   if(ncell(input_raster[[1]]) == ncell(template_rast)){
#     final_rast <- cbind(template_df, as.data.frame(input_raster, xy = TRUE))
#     return(final_rast)
#   } else
#     stop("Rasters are different sizes")
#   
# }

food_rgns <- read_csv(here("globalprep/spatial/v2021/food_rgns.csv"), col_types = "cdc")

# Import food_rgns xy df
food_rgns_xy <-
  read.csv(file.path("/home/shares/ohi/git-annex/globalprep/spatial/v2021/food_rgns_xy.csv")) 
#%>%
 # dplyr::select(x, y, iso3c)
food_crs <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"

food_rgns_tif <- terra::rast(file.path("/home/shares/ohi/git-annex/globalprep/spatial/v2021/food_rgns.tif"))


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
