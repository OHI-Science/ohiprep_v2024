## MAR Wastewater Project: Plume model 

Here I will document how to run the plume model. Much of this was written by Gage Clawson, and updated by Maddie Berger for the MAR wastewater project.
 
 - You will need to download this folder (**/plumes**, or the plumes folder from the wastewater repo) to your local mazu drive. I.e. /home/username/. An easy way to download a zip of the folder is to use this service: https://downgit.github.io/#/home
 - Go ahead and install the anaconda installer for 64-bit (x86) linux from https://www.anaconda.com/products/individual and throw the file into your home directory on mazu (or Aurora if that is what you use). You will end up with a folder akin to /home/username/anaconda3
 - In your terminal, ssh into mazu.. i.e. `ssh username@mazu.nceas.ucsb.edu` and enter your password
 - Create a folder in your "anaconda3/envs" folder named "py2", this will be your python environment. This can be done with this line `conda create --name py2 python=2`
 - Type `conda activate py2` in your terminal. This will activate this py2 environment and act as your python environment. 
 - Install gdal by typing `conda install -c conda-forge gdal` to install gdal in your python environment. 
 - Create a folder in your mazu home drive entitled "grassdata" or something of the like.
 - I recommend using [screens](http://www.kinnetica.com/2011/05/29/using-screen-on-mac-os-x/) in the terminal, so you can turn on the plumes model and leave it running.
    + you can also use [tmux](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) in [iTerm2](https://iterm2.com/), Maddie found this easier to download and use
 - Follow the steps outlined below, updating file paths as needed: 
 
 ```
# this is all done in the shell
# NOTE: CHANGE THE USERNAME TO YOURS... don't use sgclawson.. it won't work for you.

# After creating a new python env, I.e. py2: 

conda activate py2

cp /home/shares/ohi/git-annex/globalprep/prs_land-based_nutrient/v2021/int/ocean_masks/ocean_mask_1km.tif /home/sgclawson/grassdata/ 
## copy the ocean mask to YOUR grassdata folder (meaning change the username...). The ocean mask is a raster where the land values are set to nan and the ocean values to 1.

rm -r /home/sgclawson/grassdata/location # replace username with your home directory name

grass -c ~/grassdata/ocean_mask_1km.tif ~/grassdata/location ## start a grass session and create a location folder where grass will run 

exit ## exit grass, and copy ocean_mask_1km.tif to PERMANENT folder, located in location folder

cp /home/sgclawson/grassdata/ocean_mask_1km.tif /home/sgclawson/grassdata/location/PERMANENT/

# Move your pourpoint files into a folder in plumes. 
##first create the folder, called "shp" 

rm -r plumes/shp # remove old shps
 
mkdir plumes/shp # make new shps folder

## navigate to the folder they were saved to which in my case is the prs_land-based_nutrient/v2021 folder

cd /home/shares/ohi/git-annex/globalprep/prs_land-based_nutrient/v2021/int/pourpoints_FINAL/

## copy files to the new shp folder you just created. These shapefiles are shapefiles with pourpoints and the associated amount of nutrient aggregated to each pourpoint.

cp pourpoints_* ~/plumes/shp

# get back to the plumes directory

cd ~/plumes # make sure you start the loop in plumes. location is very important for the loop to run!

grass ## enter grass again

# Now run yearly_global_loop.sh #this contains all the code needed. edit file paths if needed (right now they are absolute), especially "outdir" which is the directory the final tif files will be added. once finished, it should plop 15 joined tif files (1 for every year) into whatever was defined as "outdir"

sh yearly_global_loop.sh

exit # exit grass

# Tips for troubleshooting
## create a messages.txt in your plumes folder and run this to see how far the loop got: 

sh yearly_global_loop.sh > messages.txt

```

