# On charge les packages
library(gfwr)
library(tidyr)
library(dplyr)

library(gfwr)

# Chercher le menu d'aide
help("gfwr")

help("gfw_vessel_info")
# Toujours la même structure :
# Description
# Usage (arguments, leur ordre, les valeurs par défaut
# Arguments: une explication de chaque un, quelques informations
# par ex. "numeric" pour indiquer qu'il faut utiliser une valuer numérique
# Details: informations utiles
# Examples
# on peut copier coller, ou selectionner et exécuter


# On commence par une recherche simple avec le paramètre query

info_vessel <- gfw_vessel_info(query = 431782000, #length 1: un seul marqueur
                               search_type = "search",
                               key = gfw_auth())

# search_type = "search" et key = gfw_auth() sont les valeurs par défaut
# cette commande est équivalente a gfw_vessel_info(431782000)

# 2 navires !


# explorant l'objet
# noms de l'objet
names(info_vessel) # sept éléments

info_vessel$dataset # dollar
info_vessel["registryInfoTotalRecords"] # crochets

# 1. Info AIS $selfReportedInfo:
info_vessel$selfReportedInfo
names(info_vessel$selfReportedInfo)
View(info_vessel$selfReportedInfo)

# 2. registre $registryInfo
info_vessel$registryInfo
View(info_vessel$registryInfo)
# info supplémentaire! IMO du deuxième par ex. callsign
# geartype, tonnage

# 3 Autorizations
info_vessel$registryPublicAuthorizations

# quand vous trouvez des info ocultes utilisez la fonction unnest de tidyr
# sur R base:
unnest(info_vessel$registryPublicAuthorizations, sourceCode)
# une autre façon d'écrire la même chose:
info_vessel$registryPublicAuthorizations %>% unnest(sourceCode)

# 4 Propriétaires
info_vessel$registryOwners

unnest(info_vessel$registryOwners, sourceCode)
#info_vessel$registryOwners |> unnest(sourceCode)

# S'agit-il d'un comportement suspect ?
# Rappel 1 : si un navire change de pavillon, il doit changer de MMSI (ssvid)
# Rappel 2 : un MMSI peut être réciclé

# On peut explorer les dates auxquelles le MMSI a été utilisé (AIS) par chaque navire
info_vessel$selfReportedInfo[c("transmissionDateFrom", "transmissionDateTo", "ssvid", "index", "flag")]
# on trie les données par date
info_vessel$selfReportedInfo[c("transmissionDateFrom", "transmissionDateTo", "ssvid", "index")] %>%
  arrange(transmissionDateFrom, transmissionDateTo)
# Le MMSI n'a pas été utilisé par les deux navires au même temps !
# Il semblerait être un cas de réciclage de MMSI


#
# Si on veut l'info de tous les chalutiers sénégalais avec AIS ou registres compilés
# par GFW :
senegal_trawlers <- gfw_vessel_info(where = "flag = 'SEN' AND geartypes = 'TRAWLERS'",
  search_type = "search", print_request = TRUE
  ) # 118 total vessels
names(senegal_trawlers)

senegal_trawlers$selfReportedInfo[, c("index", "vesselId")]

# On va utiliser des fonctions de R pour explorer cet objet

senegal_trawlers$selfReportedInfo[, c("index", "vesselId")] |> tail()

nrow(senegal_trawlers$selfReportedInfo) # 217
tail(senegal_trawlers$selfReportedInfo)
unique(senegal_trawlers$selfReportedInfo[, c("vesselId")]) # 205 vesselid

# On enlève les duplicats de vesselId dans selfReportedInfo
ind_dup <- which(duplicated(senegal_trawlers$selfReportedInfo$vesselId))
sen_trawlers_nodup <- senegal_trawlers$selfReportedInfo[-ind_dup, ] %>% unnest(sourceCode)

# Si on veut filtrer pour une période de temps et sélectionner un
# sous-échantillon des colonnes
str(sen_trawlers_nodup)

# On transforme d'abord les dates de format caractère en format POSIXct (date)
sen_trawlers_nodup$transmissionDateFrom <- as.POSIXct(
  sen_trawlers_nodup$transmissionDateFrom, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")
sen_trawlers_nodup$transmissionDateTo <- as.POSIXct(
  sen_trawlers_nodup$transmissionDateTo, format = "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")

# On peut ordonner les données par ssvid, vesselId and first transmission date
sen_trawlers_nodup %>%
  arrange(ssvid, vesselId, transmissionDateFrom) %>% View()

# On filtre et sélectionne
filtres_date <- sen_trawlers_nodup %>% filter(transmissionDateFrom > "2020-01-01" &
                               transmissionDateTo < "2025-01-01") %>%
  select(index, ssvid, shipname, callsign, imo, transmissionDateFrom, transmissionDateTo)
length(unique(filtres_date$index)) # 33 navires

# D'autres filtres avec where
sen_trawlers_dates <- gfw_vessel_info(where = "flag = 'SEN' AND geartypes = 'TRAWLERS' AND
                transmissionDateFrom > '2020-01-01' AND
                transmissionDateTo < '2025-01-01'",
                search_type = "search", print_request = TRUE
)
# On enlève les duplicats de vesselId dans selfReportedInfo
ind_dup_2 <- which(duplicated(sen_trawlers_dates$selfReportedInfo$vesselId))
sen_trawlers_dates_nodup <- sen_trawlers_dates$selfReportedInfo[-ind_dup_2, ] %>%
  unnest(sourceCode)  %>%
  select(index, ssvid, shipname, callsign, imo, transmissionDateFrom, transmissionDateTo)

length(unique(sen_trawlers_dates_nodup$index)) # 39 navires (et on explique pourquoi)


## RECHERCHE PAR ID

info_vessel$selfReportedInfo$vesselId[4]

id <- info_vessel$selfReportedInfo$vesselId[4]
id

# Pour faire une recherche d'information sur un navire pour un vessel ID spécifique :
id_search <- gfw_vessel_info(search_type = "id", ids = id)
