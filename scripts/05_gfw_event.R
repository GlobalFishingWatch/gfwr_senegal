# packages
library(gfwr)
library(dplyr)
library(tidyr)
 
# API événements


# On peut chercher par un navire: vessels
id_test <- "098ac6ed6-65a9-260b-fb84-8c932eb977ae"

# GAPS - interruptions de la transmission

gaps <- gfw_event(event_type = "GAP",
                  vessels = id_test,
                  start_date = "2017-01-26",
                  end_date = "2023-02-04",
                  key = gfw_auth())

gaps %>% unnest_wider(event_info) %>% View() # pour visualiser ce qu'on vient de
# générer

# Obtenir que des gaps de plus d'un jour

gaps <- gfw_event(event_type = "GAP",
                  # vessels = id_test,
                  flags = 'SEN',
                  start_date = "2017-01-01",
                  end_date = "2024-12-31",
                  duration = 24*60, # in minutes
                  key = gfw_auth())
gaps <- gaps %>% unnest_wider(event_info)

View(gaps)

# ordonner les gaps par durée

gaps |>
  arrange(desc(durationHours)) |> 
  View()

# on fait une figure pour la position avec le gap le plus long

gaps_top <- gaps |> 
  arrange(desc(durationHours)) |> 
  slice_head(n = 1)
gaps_top <- gaps_top |> unnest_wider(offPosition, names_sep = "_") |>
  unnest_wider(onPosition, names_sep = "_") |>
  select(vesselId, vessel_name, vessel_ssvid, durationHours, offPosition_lat,
         offPosition_lon, onPosition_lat, onPosition_lon)
gaps_top


# Pour créer une carte comme hier: 

# On transforme d'abord les données en objets sf
library(sf)
gaps_start_df <- st_as_sf(gaps_top, coords = c("offPosition_lon",
                                               "offPosition_lat"),
                          crs = 4326) |>
  st_cast("POINT")

gaps_end_df <- st_as_sf(gaps_top, coords = c("onPosition_lon",
                                             "onPosition_lat"),
                        crs = 4326) |>
  st_cast("POINT")


# On choisi d'utiliser tmap pour faire les plots
library(tmap)
tmap_mode("view")
tm_basemap() +
  tm_shape(gaps_start_df) +
  tm_dots(size = 0.5, fill = "red") +
  tm_shape(gaps_end_df) +
  tm_dots(size = 0.3)


# visites à port


visites_port <- gfw_event(event_type = "PORT_VISIT",
                          vessels = "098ac6ed6-65a9-260b-fb84-8c932eb977ae",
                          start_date = "2017-01-26",
                          end_date = "2022-12-31",
                          key = gfw_auth())
names(visites_port)

View(visites_port)
visites_port %>% tidyr::unnest_wider(event_info) %>% View()

# Filtres pour le niveau de confiance
gfw_event(event_type = "PORT_VISIT",
          vessels = id_test,
          start_date = "2017-01-26",
          end_date = "2022-12-31",
          confidence = c(3,4),
          key = gfw_auth())

# On retrouve les visites aux port sénégalais des bateaux sénégalais

# Pour cela, on retrouve d'abord le ID de la ZEE sénégalaise
region_id <- gfw_region_id(region = "SEN" )
visites_port_sen <- gfw_event(event_type = "PORT_VISIT",
                              flags = "SEN",
                              region = region_id$id,
                              region_source = "EEZ",
                              start_date = "2017-01-01",
                              end_date = "2022-12-31",
                              key = gfw_auth())
names(visites_port_sen)

# Puis on transforme en objet sf
port_sf <- st_as_sf(visites_port_sen, coords = c("lon",
                                                 "lat"),
                    crs = 4326) 

# Et on fait le plot avec tmap
tmap_mode("view")
tm_basemap() +
  tm_shape(port_sf) +
  tm_dots(size = 0.3) 



# Rencontres

encounter_example <- gfw_event(event_type = "ENCOUNTER",
                               vessels = id_test,
                               start_date = "2020-01-30",
                               end_date = "2024-02-04",
                               key = gfw_auth()) |> unnest_wider(regions) |>
  unnest_wider(event_info)

View(encounter_example)
encounter_example$vessel


## loitering a Cayar
library(sf)
cayar <- read_sf("./data/Shapefiles/Cayr_Profond/Cayar_Offshore_Profond.shp")
cayar
##library(tmap)
tmap_mode("view")
tm_basemap() +
  tm_shape(cayar) +
  tm_borders()

loit_cayar <- gfw_event(event_type = "LOITERING",
          start_date = "2022-01-01",
          end_date = "2024-01-01",
          region_source = "USER_SHAPEFILE", 
          region = cayar) |> unnest_wider(regions) |>
  unnest_wider(event_info)

loit_cayar_sf <- st_as_sf(loit_cayar, coords = c("lon", "lat"),
                       crs = 4326) 

tmap_mode("view")
tm_basemap() +
  tm_shape(cayar) +
  tm_borders() + 
  tm_shape(loit_cayar_sf) + 
  tm_bubbles(fill = "vessel_type", 
             popup.vars = c("vessel_flag", "vessel_name"))

             