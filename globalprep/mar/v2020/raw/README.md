## Source for Truj_label_sust.csv:

Seafood Watch sustainability data

Monterey Bay Aquarium Seafood Watch aquaculture recommendations. Sustainability scored from 0-10. Rescaled to 0-1.


Column headers:

report_title - title of species and where it is generally located
start_year - corresponding species name in FAO mariculture data
sw_species - common name of the species given by sfw
genus - genus
spp - species name 
fao_species - fao species name 
region - general region it is located in
country - country it is located in 
state_territory - the state or territory it is located in 
sub_region - sub region it is located in 
water_body - Body of water 
parent_method - the method of aquaculture used 
method - a more specific method of aquaculture description
score - the overall sustainability score given by SFW
escapes_score - the escapes score given by SFW
rec - the overall recommendation given by SFW


## Notes on species_list.csv
This is the list of species from the FAO. Any new species you will have to manually add (there are instructions in the RMD). Make sure to update the taxon_code and species columns as well. 

List of taxon_code categories: 
AL - Algae; any seaweed
GAST - gastropods   
BI - bivalves     
CEPH - cephalopods
CRUST - crustaceans
F - Fishes
INV - invertebrates
NS-INV
OTHER - other (usually reptiles)  
SH - shrimp
TUN - tunicates
URCH - urchins   
 
 