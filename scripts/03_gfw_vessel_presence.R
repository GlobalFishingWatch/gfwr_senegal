library(gfwr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(glue)
library(tmap)

start_date <- '2024-01-01' # will be included
end_date <- '2024-04-01'   # will be excluded. search will be up to 2024-03-31


## ----eez_region_codes
eez_regions <- gfw_regions(region_source = 'EEZ')
eez_regions


## ----code_eez--------
# Use gfw_region_id function to get EEZ code for Senegal
senegal_eez_code <- gfw_region_id(region = "Senegal", region_source = "EEZ")
senegal_eez_code

# Request simple
vp_senegal <- gfw_ais_presence(spatial_resolution = "LOW",
                               temporal_resolution = "MONTHLY",
                               start_date = start_date,
                               end_date = end_date,
                               region_source = "EEZ",
                               region = 8371)
vp_senegal


## --Request yearly ----
vp_senegal <- gfw_ais_presence(spatial_resolution = "LOW",
                               temporal_resolution = "YEARLY",
                               start_date = start_date,
                               end_date = end_date,
                               region_source = "EEZ",
                               region = 8371)
vp_senegal


## ---Monthly and group by flag
vp_senegal_flag <- gfw_ais_presence(spatial_resolution = "LOW",
                                    temporal_resolution = "MONTHLY",
                                    group_by = "FLAG",
                                    start_date = start_date,
                                    end_date = end_date,
                                    region_source = "EEZ",
                                    region = 8371)
vp_senegal_flag |> count(flag) |> arrange((desc(n)))



## -------group by mmsi
vp_senegal_MMSI <- gfw_ais_presence(spatial_resolution = "LOW",
                                    temporal_resolution = "MONTHLY",
                                    group_by = "MMSI",
                                    start_date = start_date,
                                    end_date = end_date,
                                    region_source = "EEZ",
                                    region = 8371)
vp_senegal_MMSI


## --group by vessel ID ----
vp_senegal_vesselID <- gfw_ais_presence(spatial_resolution = "LOW",
                                        temporal_resolution = "MONTHLY",
                                        group_by = "VESSEL_ID",
                                        start_date = start_date,
                                        end_date = end_date,
                                        region_source = "EEZ",
                                        region = 8371)
vp_senegal_vesselID |> count(`Gear Type`)
vp_senegal_vesselID |> count(`Vessel Type`)



# On peut aussi charger un shapefile propre -> .shp
# le package qui lit les shapefiles sur R est sf
# First we can use a shapefile that is loaded in the package:
?gfwr
data(test_shape)


tmap_mode("view")
tm_basemap() +
  tm_shape(test_shape) +
  tm_borders()

test_shape

# When you want to read your owné um objeto sf
#sf::read_sf()



# Palette for fishing activity
map_effort_light <- c("#ffffff", "#eeff00", "#3b9088","#0c276c")

## --carte---
vp_senegal

vp_senegal |>
  ggplot() +
  geom_tile(aes(x = Lon,
                y = Lat,
                fill = `Vessel Presence Hours`)) +
  geom_sf(data = ne_countries(returnclass = "sf", scale = "medium")) +
  coord_sf(xlim = c(min(vp_senegal$Lon), max(vp_senegal$Lon)),
           ylim = c(min(vp_senegal$Lat), max(vp_senegal$Lat))) +
  scale_fill_gradientn(
    trans = 'log10',
    #colors = viridis::cividis(n = 4),
    colors = map_effort_light,
    na.value = NA,
    labels = scales::comma) +
  labs(title = "Vessel Presence hours in the Senegalese EEZ",
       subtitle = glue("{start_date} to {end_date}"),
       fill = "Vessel presence hours (log)")

