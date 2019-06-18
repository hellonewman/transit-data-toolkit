setwd("R stuff/transit-data-toolkit/")
# Load library
library(leaflet)
library(dplyr)

# Read in MBTA Station txt file
rawlocs <- read.csv(file="paac_gtfs/stops.txt", head=TRUE,sep=",")
View(rawlocs)

# Select columns with MBTA T stations
station_locs <- rawlocs
head(station_locs)

#Select the columns we want and change columns name to latitude and longitude
station_locs <- station_locs[c("stop_id","stop_name","stop_lat","stop_lon")]
colnames(station_locs)[3] <- "latitude"
colnames(station_locs)[4] <- "longitude"

# Convert the columns imported as a factor to characters
#station_locs$stop_id <- as.character(station_locs$stop_id)
#station_locs$stop_name <- as.character(station_locs$stop_name)

# Convert stop ID to number (remove the E)
#station_locs <- station_locs[!is.na(as.numeric(station_locs$stop_id)), ]
#station_locs <- station_locs[substr(station_locs$stop_id,2:), ]

station_locs$stop_short <- substr(station_locs$stop_name,1,10)
head(station_locs)

stop_group <- station_locs %>%
  group_by(stop_short) %>%
  summarise(number = n())

stop_type <- station_locs %>%
  group_by(stop_type) %>%
  summarise(number = n())
stop_type

station_locs$stop_type <- substr(station_locs$stop_id,1,1)
head(station_locs)
paacMap <- leaflet(station_locs) %>%
  addTiles() %>%  
  #setView(-71.057083, 42.361145, zoom = 12) %>%
  addCircles(~longitude, ~latitude, weight = 3, radius=120, 
             color=station_locs$stop_type, stroke = TRUE, fillOpacity = 0.8) %>% 
  addLegend("bottomleft", colors="#0073B2", 
            labels="Data Source: PAAC Developer Portal", 
            title="Port Authority Stations")

# show the map
paacMap 















##################################################################

# Convert the Stop ID column into numbers
station_locs$stop_id = as.numeric(station_locs$stop_id)
station_locs

# Select columns with MBTA T stations
station_locs <- station_locs[which ((station_locs$stop_id >= 70000) & (station_locs$stop_id <= 70279) ),]


stop_group

# Saint Paul Street Station names are altered to include their line.
# This change is done to be able to distinguish the two stations
# named Saint Paul Street on the B and C line.

station_locs$stop_name[station_locs$stop_id == 70140] <-  "Saint Paul Street B Line"
station_locs$stop_name[station_locs$stop_id == 70141] <-  "Saint Paul Street B Line"
station_locs$stop_name[station_locs$stop_id == 70217] <-  "Saint Paul Street C Line"
station_locs$stop_name[station_locs$stop_id == 70218] <-  "Saint Paul Street C Line"

# Most T stations are defined by multiple station platforms, 
# which might not be at the same latitude/longitude. 
# Find the unique station names so we can get one observation per station
station_locs <- station_locs[!duplicated(station_locs$stop_name),]



# Select the rows which do not have Outbound in the text
# Remove string with dash
station_locs$stop_name <- sub("\\-.*","",station_locs$stop_name)

#Remove and extra spaces
station_locs$stop_name <- trimws(station_locs$stop_name,which = c("right"))
View(station_locs)

#export the data to a csv file
write.csv(station_locs, "./mbta_stops.csv")

# Map the stations
# Lat Long corrdinates from www.latlong.net
paacMap <- leaflet(station_locs) %>%
  addTiles() %>%  
  #setView(-71.057083, 42.361145, zoom = 12) %>%
  addCircles(~longitude, ~latitude, weight = 3, radius=120, 
             color="#0073B2", stroke = TRUE, fillOpacity = 0.8) %>% 
  addLegend("bottomleft", colors="#0073B2", 
            labels="Data Source: PAAC Developer Portal", 
            title="Port Authority Stations")

# show the map
paacMap 


