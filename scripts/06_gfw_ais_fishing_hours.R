library(gfwr)
library(tmap)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(tmap)

id_reg <- gfw_region_id(region = "Senegal",
                        region_source = "EEZ")
# 8371

# Janvier-Mars 2023
sen_fisheff <- gfw_ais_fishing_hours(spatial_resolution = 'LOW',
                                     temporal_resolution = 'MONTHLY',
                                     start_date = '2023-01-01',
                                     end_date = '2023-04-01',
                                     region = 8371,
                                     region_source = 'EEZ',
                                     key = gfw_auth())
names(sen_fisheff)

# group_by = "VESSEL_ID" "GEARTYPE" and "FLAGANDGEARTYPE" vont retourner des
# colonnes différentes

sen_fisheff_VI <- gfw_ais_fishing_hours(spatial_resolution = 'LOW',
                                        temporal_resolution = 'MONTHLY',
                                        start_date = '2023-01-01',
                                        end_date = '2023-04-01',
                                        group_by = "VESSEL_ID",
                                        region = 8371,
                                        region_source = 'EEZ',
                                        key = gfw_auth())
names(sen_fisheff_VI)

# NOUVEAU: pour les heures de pêche on peut regrouper par l'engin
sen_fisheff_flaggear <- gfw_ais_fishing_hours(spatial_resolution = 'LOW',
                                              temporal_resolution = 'MONTHLY',
                                              start_date = '2023-01-01',
                                              end_date = '2023-04-01',
                                              group_by = "FLAGANDGEARTYPE",
                                              region = 8371,
                                              region_source = 'EEZ',
                                              key = gfw_auth())
names(sen_fisheff_flaggear)
sen_fisheff_flaggear


# On peut utiliser quelques filtres come flag IN

CHN_au_SEN <- gfw_ais_fishing_hours(spatial_resolution = 'LOW',
                                    temporal_resolution = 'MONTHLY',
                                    start_date = '2023-01-01',
                                    end_date = '2023-04-01',
                                    group_by = "FLAGANDGEARTYPE",
                                    filter_by = "flag IN ('CHN')",
                                    region = 8371,
                                    region_source = '')
CHN_au_SEN



# Palette for fishing activity
map_effort_light <- c("#ffffff", "#eeff00", "#3b9088","#0c276c")

## --carte---
sen_fisheff_flaggear

sen_fisheff_flaggear |>
  ggplot() +
  geom_tile(aes(x = Lon,
                y = Lat,
                fill = `Apparent Fishing Hours`)) +
  geom_sf(data = ne_countries(returnclass = "sf", scale = "medium")) +
  coord_sf(xlim = c(min(sen_fisheff_flaggear$Lon), max(sen_fisheff_flaggear$Lon)),
           ylim = c(min(sen_fisheff_flaggear$Lat), max(sen_fisheff_flaggear$Lat))) +
  scale_fill_gradientn(
    trans = 'log10',
    colors = map_effort_light,
    na.value = NA,
    labels = scales::comma) +
  labs(title = "Apparent Fishing hours in the Senegalese EEZ",
       fill = "Apparent fishing hours (log)") +
  theme_bw()


sen_fisheff_flaggear |>
  ggplot() +
  geom_tile(aes(x = Lon,
                y = Lat,
                fill = `Apparent Fishing Hours`)) +
  geom_sf(data = ne_countries(returnclass = "sf", scale = "medium")) +
  coord_sf(xlim = c(min(sen_fisheff_flaggear$Lon), max(sen_fisheff_flaggear$Lon)),
           ylim = c(min(sen_fisheff_flaggear$Lat), max(sen_fisheff_flaggear$Lat))) +
  scale_fill_gradientn(
    trans = 'log10',
    colors = map_effort_light,
    na.value = NA,
    labels = scales::comma) +
  labs(title = "Apparent Fishing hours in the Senegalese EEZ",
       fill = "Apparent fishing hours (log)") +
  theme_bw() +
  facet_wrap(~Flag)
  