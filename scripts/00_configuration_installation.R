# Les instructions d'installation se trouvent ici:
# https://docs.google.com/document/d/1zf20IZHqfbRjDhQUfjorVBU0jDPV_KfB/edit

#  mais nous les reprenons ici

# Compte Global Fishing Watch.
# Créez un compte sur la plateforme de Global Fishing Watch et un token d'accès aux APIs

# Installez les packages nécessaires pour installer le token
install.packages("usethis")

# Pour ouvrir et éditer le fichier .R_environ:
usethis::edit_r_environ()

# Le fichier sera ouvert. Copiez et collez votre (!!) token:
#GFW_TOKEN = "eyJhb..."
# Sauvez le fichier et redémarrez la session R: (menu: Session/Restart R)




# Installez le package depuis GitHub

install.packages("remotes") # si vous n'avez pas encore "remotes"

# Installez le package:
remotes::install_github("GlobalFishingWatch/gfwr",
                        dependencies = TRUE,
                        build_vignettes = TRUE,
                        ref = "develop")

# Pour confirmer l'installation, executez un appel aux fonctions:

library(gfwr)
gfw_auth()

gfw_vessel_info(431782000)

# SVP fermez RStudio et redémarrez si vous avez un problème.
# Si l'erreur persiste, contactez research@globalfishingwatch.org
