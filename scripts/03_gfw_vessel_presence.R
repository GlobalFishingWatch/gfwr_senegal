library(gfwr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(glue)

# nouveau
#install.packages("tmap")
library(tmap)


?gfwr::gfw_ais_presence

start_date <- '2024-01-01' # will be included
end_date <- '2024-04-01'   # will be excluded. search will be up to 2024-03-31


## ----eez_region_codes
eez_regions <- gfw_regions(region_source = 'EEZ')
eez_regions


## ----code_eez--------
# gfw_region_id pour chercher le code EEZ Senegal
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
vp_senegal_flag
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
View(vp_senegal_vesselID)


vp_senegal_vesselID |> count(`Gear Type`)

vp_senegal_vesselID |> count(`Vessel Type`)

## interruption, projecteur éteint

## Chercher la presence dans la MPA de Gorée 

gfw_regions(region_source = "MPA")
gfw_region_id(region = "Gorée", region_source = "MPA")

# On peut aussi charger un shapefile propre -> .shp
# le package qui lit les shapefiles sur R est sf
library(sf)
cayar <- read_sf("./data/Shapefiles/Cayr_Profond/Cayar_Offshore_Profond.shp")
cayar

## une visualisation du shapefile (il y a d'autres options)
##library(tmap)
tmap_mode("view")
tm_basemap() +
  tm_shape(cayar) +
  tm_borders()

## Pour le shapefile: USER_SHAPEFILE
presence_cayar <- gfw_ais_presence(
  spatial_resolution = "LOW",
  temporal_resolution = "DAILY",
  start_date = start_date,
  end_date = end_date,
  region_source = "USER_SHAPEFILE",
  region = cayar)



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
    colors = map_effort_light,
    na.value = NA,
    labels = scales::comma) +
  labs(title = "Vessel Presence hours in the Senegalese EEZ",
       subtitle = glue("{start_date} to {end_date}"),
       fill = "Vessel presence hours (log)")

## Pour ploter présence à Cayar
presence_cayar |>
  ggplot() +
  geom_tile(aes(x = Lon,
                y = Lat,
                fill = `Vessel Presence Hours`)) +
  geom_sf(data = ne_countries(returnclass = "sf", scale = "medium")) +
  coord_sf(xlim = c(min(presence_cayar$Lon), max(presence_cayar$Lon)),
           ylim = c(min(presence_cayar$Lat), max(presence_cayar$Lat))) +
  scale_fill_gradientn(
    trans = 'log10',
    colors = map_effort_light,
    na.value = NA,
    labels = scales::comma) +
  labs(title = "Vessel Presence hours in Cayar",
       subtitle = glue("{start_date} to {end_date}"),
       fill = "Vessel presence hours (log)")
