# Lecture et pretraitement de données avec un fichier xlsx
library(readxl)
library(stringr)


donnees_xlsx <- read_xlsx("./donnees/LISTE DES NAVIRES BENEFICIAIRES DE LICENCE PECHE 2025.xlsx")
str(donnees_xlsx) # On observe les colonnes et ses premières valeurs

View(donnees_xlsx) # On voit toute suite des erreurs de type fautes de frappe

# On réfléchit à l'histoire de ce fichier
# Idéalement, on devrait avoir les données brutes dans un fichier de données, pas en image qui doit ensuite se transformer en tableau excel.
# Si le fichier a encore de fautes de frappe, il faut vérifier avec des sources officielles

# On montre ici un exemple pour corriger les erreurs de la colonne option
# Les options devraient être :
# 1. Chalutier crevettier, 2. Chalutier poissonnier céphalopodier
# 3. Palangrier de fond, 4. Chalutier poissonnier, 5. Casier à langouste rose
# 6. Casier à crabe profond, 7. Senneur, 8. Chalutier, 9. Canneur,
# 10. Senneur, 11. Palangrier

# Cependant, on retrouve pas exactement ces catégories.
# Il faut être sûr que la metadata est actualisée.

# On continue avec l'exemple pour corriger les données.

donnees_xlsx$OPTION <- str_to_title(donnees_xlsx$OPTION)

# Pas à pas avec la fonction gsub
(donnees_xlsx$OPTION <- gsub(pattern = "Chaletier", replacement = "Chalutier", x = donnees_xlsx$OPTION))

(donnees_xlsx$OPTION <- gsub(pattern = "Chalutter", replacement = "Chalutier", x = donnees_xlsx$OPTION))

donnees_xlsx$OPTION <- gsub(pattern = "Chalatier", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chelutier", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chalstier", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chalsber", replacement = "Chalutier", x = donnees_xlsx$OPTION)
(donnees_xlsx$OPTION <- gsub(pattern = "Chaluber", replacement = "Chalutier", x = donnees_xlsx$OPTION))

donnees_xlsx$OPTION <- gsub(pattern = "Chaliter", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chalvter", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chalitier", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chalutiet", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chaluller", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chakurier", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chalvtier", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chalutior", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chalutler", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chaluter", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chaktier", replacement = "Chalutier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Chelstier", replacement = "Chalutier", x = donnees_xlsx$OPTION)

donnees_xlsx$OPTION <- gsub(pattern = "Cephalopodier", replacement = "Céphalopodier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Cephalopoder", replacement = "Céphalopodier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Cephalopodi", replacement = "Céphalopodier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Dephalopodier", replacement = "Céphalopodier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Cephalopodler", replacement = "Céphalopodier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Céphalopodler", replacement = "Céphalopodier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Géphalopodler", replacement = "Céphalopodier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Géphalopoder", replacement = "Céphalopodier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Cephalopodiler", replacement = "Céphalopodier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Céphalopodierler", replacement = "Céphalopodier", x = donnees_xlsx$OPTION)

donnees_xlsx$OPTION <- gsub(pattern = "Piche", replacement = "Pêche", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Congelattieve", replacement = "Congélateur", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Congelateur", replacement = "Congélateur", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Congelatour", replacement = "Congélateur", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Thonker", replacement = "Thonier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Grevetter", replacement = "Crevettier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Thanior", replacement = "Thonier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Crevetter", replacement = "Crevettier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Crevettler", replacement = "Crevettier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Oevetter", replacement = "Crevettier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Sennour", replacement = "Senneur", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Senreur", replacement = "Senneur", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Thaner", replacement = "Thonier", x = donnees_xlsx$OPTION)
donnees_xlsx$OPTION <- gsub(pattern = "Thonler", replacement = "Thonier", x = donnees_xlsx$OPTION)

# On regarde si les catégories ont du sens
levels(as.factor(donnees_xlsx$OPTION)) # c'est bon

# Sauver le dataframe dans un nouveau fichier
write.csv(x = donnees_xlsx, file = "./donnees/ListeNaviresPreTraitee.csv")
