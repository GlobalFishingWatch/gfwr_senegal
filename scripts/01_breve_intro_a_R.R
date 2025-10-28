#### Quelques bonnes pratiques

# 1. Un dossier principal, clarté sur le répertoire de travail
# 2. Une structure claire du dossier, et des chemins relatifs dans le code
# 3. Faire confiance aux scripts, pas à l'espace de travail
#   sur le menu choisissez ne pas sauver le workspace! Tools > Global Options > General
# 4. Ne pas modifier les données brutes
# 5. Documentation sur les méthodes employées, commentaires accompagnant le code

###############

# La commande getwd nous donne l'endroit où vous avez gardé le dossier
getwd()


##################### Créer des objets sur R ###############################

2 + 2
# ne crée pas d'objet

trois <- 3
# crée un objet: voyez l'onglet environnement: l'objet trois se trouve là. (il utilise de la mémoire RAM!)



##################### Types d'objets sur R #################################

# Classes
# numérique, caractère, logique,

3
"a"
TRUE

class(3)
class("a")
class("3")
class(TRUE)

# Il y a d'autres comme integer: un nombre entier. On ajoute un L au chiffre:
3L
class(3L)

## Une structure: le vecteur #####
# Vecteurs: avec la fonction c() -> "concatenate"

c(3, 2, 1) # ne crée pas d'objet
objet <- c(3, 2, 1)
class(objet)
is(objet)

# Si sur un vecteur, on mélange des caractères, numériques et logiques,
# caractère aura priorité sur numerique et sur logique
mix <- c(3, "a")
class(mix)

mix <- c(3, "a", TRUE)
mix
class(mix)

# numeric a priorité sur logique: TRUE = 1 FALSE = 0
mix <- c(TRUE, 1)
mix
class(mix)

mix <- c(FALSE, 1)
mix
class(mix)

# Les classes et les rapports entre elles sont importantes parce que les
# fonctions sont créées pour opérer sur des types de données spécifiques
# ex. logical: TRUE ou FALSE
# ex. numeric: 3, pas "3"


## Subset: selectionner un élément d'un vecteur ###############
animaux <- c("souris", "rat", "chien", "chat")
# par la position, entre crochets
animaux[2]
## avec un autre vecteur (créé avec c()  )
animaux[c(3, 2)]
## avec une clause logique
poids_g <- c(21, 34, 39, 54, 55)
poids_g[c(TRUE, FALSE, FALSE, TRUE, TRUE)]


## --La longueur des vecteurs importe: si un vecteur est plus long que l'autre: erreur

animaux      <- c("souris", "rat", "chien", "chat")
autres_animaux <- c("rat", "chat", "chien", "canard", "chevre")

animaux == autres_animaux

animaux %in% autres_animaux

# Égal, différent
animaux      <- c("souris", "rat", "chien", "chat", "chevre")
autres_animaux <- c("rat", "chat", "chien", "canard", "chevre")

animaux == autres_animaux
animaux != autres_animaux

length(animaux)
dim(animaux)

## Une autre structure: le dataframe #######
## Dataframes (tables)
# C'est le format le plus commun lorsqu'on lit un fichier (excel, csv, txt) sur R

# On va d'abord creer un dataframe sur place:

dataframe <- data.frame(var1 = c(1, 3, 4),
                        var2 = c("b", "bonjour!", 4),
                        var3 = c(TRUE, TRUE, FALSE))
dataframe
names(dataframe)

#quelles sont les classes des variables du dataframe?

# chaque colonne est un vecteur: éléments du même type
# MAIS les colonnes n'ont pas besoin d'être du même type
# Exemple : Un data frame de trois colonnes
# Une colonne caractère : nom du navire,
# Une colonne numérique : nombre d'heures,
# Une colonne logique : est-ce qu'il s'agit d'un navire de pêche ? TRUE FALSE


dim(dataframe) # Sur R, les dimensions sont toujours d'abord les lignes, puis les colonnes
# pour sélectionner, on utulise les crochets et une virgule:
#[lignes, colonnes]
dataframe[1, ] # la première ligne
dataframe[, 1] # la première colonne
dataframe[1, 1]


# comment selectionner la troisième colonne?

# le deuxième élément de la première colonne?


## Listes----

# Une liste est un objet avec une structure flexible.
# Ses éléments peuvent être de n'importe quelle nature (y compris d'autres listes).

objet1 <- c(1, 3, 4)
objet2 <- dataframe
objet3 <- c(TRUE, TRUE, FALSE, FALSE, TRUE, FALSE)

liste <- list(objet1, objet2, objet3)

# On peut créer une liste dont les éléments sont nommés :

liste_nommee <- list(numeriques = objet1,
                     mon_dataframe = objet2,
                     logiques = objet3)
liste_nommee

# On peut aussi donner des noms a une liste déjà créée :
names(liste)
names(liste) <- c("numeriques", "dataframe", "logiques")
names(liste)
str(liste)

# On va parler de listes après parce que la fonction gfw_vessel_info() retourne une liste.


## tidyverse
## select, filter
## pipe
