# SDD II Module 9 - partie 1 : bases de données
# version 2022-2023, 2023-03-20
# Ph. Grosjean, license CC BY-NC-SA 4.0
#
# La question à laquelle nous souhaitons répondre est la suivante :
# Quels sont les dix pays où la prévalence de la tuberculose est la plus forte
# en moyenne pendant les années 2000 (2000 à 2009 inclus), chez les femmes âgées
# de 25 à 54 ans ?

# Configuration du système et chargement des packages
SciViews::R
library(DBI)
library(duckdb)
library(dm)

# Récupération des données depuis le package {tidyr}
who <- read("who", package = "tidyr")
str(who) # Structure du jeu de données who
pop <- read("population", package = "tidyr")
str(pop) # Structure du jeu de données pop


# Traitement en R à partir des données non modifiées ----------------------

# 1.  fusion des tableaux `who` et `pop`,
# 2.  filtrage des données pour ne conserver que les années égales ou supérieures à 2000 et inférieures à 2010,

dim(who)
dim(pop)
who %>.%
  left_join(., pop) %>.% # étape 1 fusion
  filter(., year >= 2000 & year < 2010) %->% # étape 2 filtrage années 2000-2010
  who2
dim(who2)

# 3.  **filtrage des données pour ne conserver que les femmes entre 25 et 54 ans,**

who2 %>.% # étape 3 filtrage des femmes entre 25 et 54 ans uniquement
  select(., country, year, population, ends_with(c("f2534", "f3544", "f4554"))) %->%
  who3
dim(who3)
names(who3)

# 4.  **somme des nouveaux cas de tuberculose, quelle que soit la méthode de détection et la classe d'âge,**

who3 %>.%
  select(., -country, -year, -population) %>.%
  transmute(., all_new = rowSums(., na.rm = TRUE)) %>.%
  collect_dtx(.) %>.%
  dtx(country = who3$country, year = who3$year, population = who3$population, all_new = .$all_new) %->%
  who4
dim(who4)
names(who4)

# 5.  calcul des proportions, soit la somme de cas divisés par la population totale, variable nommée `prevalence`,
# 6.  regroupement par pays,
# 7.  résumé des prévalences moyennes par pays, toutes années confondues,
# 8.  tri de ces prévalences moyennes par ordre décroissant,
# 9.  enfin, ne conserver que les dix pays ayant les plus fortes prévalences moyennes.

who4 %>.%
  mutate(., prevalence = all_new / population) %>.% # étape 5, calcul de la prévalence
  group_by(., country) %>.% # étape 6 regroupement par pays
  summarise(., mean_prev = mean(prevalence, na.rm = TRUE)) %>.% # étape 7 prévalence moyenne
  arrange(., desc(mean_prev)) %>.% # étape 8 tri décroissant
  collect_dtx(.) %>.%
  head(., 10) # étape 9 seulement les 10 premiers pays


# Traitement dans R après adaptation des données --------------------------

# Tableau large en long

who %>.%
  pivot_longer(., starts_with("new"), names_to = "type", values_to = "new_cases") %->%
  whol
dim(whol)
head(whol)

# Extraction de l"information depuis le type

substring("new_ep_f2534", 1, 6) # method
substring("new_ep_f2534", 8, 8) # sex
substring("new_ep_f2534", 9, 12) # age

whol %>.%
  mutate(.,
    method = substring(type, 1, 6),
    sex    = substring(type, 8, 8),
    age   = substring(type, 9, 12)) %>.%
  select(., -type) %->%
  whol
head(whol)

# 1.  fusion des tableaux `whol` et `pop`,
# 2.  filtrage des données pour ne conserver que les années \>= 2000 e \< 2010, et que les femmes entre 25 et 54 ans,
# 3.  regroupement par pays et par année,
# 4.  somme des nouveaux cas de tuberculose par pays et par année,
# 5.  calcul des proportions, soit la somme de cas divisés par la population totale, variable nommée `prevalence`,
# 6.  regroupement par pays,
# 7.  résumé des prévalences moyennes par pays, toutes années confondues,
# 8.  ne conserver que les dix pays ayant les plus fortes prévalences moyennes.

whol %>.%
  left_join(., pop) %>.% # étape 1 fusion
  filter(., year >= 2000 & year < 2010 & sex == "f" & age %in% c("2534", "3544", "4554")) %>.% # étape 2 filtrage
  group_by(., country, year) %>.% # étape 3 regroupement par pays et année
  summarise(., total = first(population), all_new = sum(new_cases, na.rm = TRUE)) %>.% # étape 4 somme des cas
  mutate(., prevalence = all_new / total) %>.% # étape 5, calcul de la prévalence
  group_by(., country) %>.% # étape 6 regroupement par pays
  summarise(., mean_prev = mean(prevalence, na.rm = TRUE)) %>.% # étape 7 prévalence moyenne
  slice_max(., mean_prev, n = 10) %>.% # étape 8 ne garder que les 10 plus élevés
  collect_dtx(.)


# Traitement dans DuckDB après normalisation avec {dm} --------------------

## Normalisation niveau 1

# Création & connexion à la base de données
drv <- duckdb(dbdir = "duckdb_test.db")
con <- dbConnect(drv)

# Injection de deux data frames comme tables
dbWriteTable(con, "who", whol)
dbWriteTable(con, "pop", pop)

# Création d'un objet dm qui reprend le schéma de la base
who_dm <- dm_from_src(con) %>.%
  dm_set_colors(., red = who, darkgreen = pop) # Couleurs pour les tables (pour le schéma)

dm_enum_pk_candidates(who_dm, pop)

# Création des clés primaires
who_dm %>.%
  dm_add_pk(., pop, c(country, year), force = TRUE) %>.%
  dm_add_pk(., who, c(country, year, method, sex, age), force = TRUE) %->%
  who_dm
# Graphique du schéma de la base
dm_draw(who_dm, view_type = "all")


## Relation entre tables

dm_enum_fk_candidates(who_dm, who, pop) # Ne fonctionne pas bien avec les clés composites !

who_dm <- dm_add_fk(who_dm, who, c(country, year), pop)
# Graphique du schéma de la base avec relation entre les tables
dm_draw(who_dm, view_type = "all")

# Vérification de l'intégrité des données
check_cardinality_0_n(as_dtbl(pop), c(country, year), as_dtbl(whol), c(country, year))

# Quel est le problème ?
# Années
unique(pop$year)
unique(whol$year)

whol1995 %<-% filter(whol, year >= 1995)

# Pays
whol_countries <- unique(whol1995$country)
pop_countries <- unique(pop$country)
all(whol_countries %in% pop_countries)

whol_countries[!whol_countries %in% pop_countries]

pop_countries[substring(pop_countries, 1, 1) == "C"]

# Cote d'Ivoire vs Côte d'Ivoire et Curacao vs Curaçao
whol1995$country[whol1995$country == "Cote d'Ivoire"] <- "Côte d'Ivoire"
whol1995$country[whol1995$country == "Curacao"] <- "Curaçao"
# Vérification
all(unique(whol1995$country) %in% pop_countries)

check_cardinality_0_n(as_dtbl(pop), c(country, year), as_dtbl(whol1995), c(country, year))

# On corrige les problèmes dans la base de données
# Effacement de la table "whol"
dbRemoveTable(con, "who")
dbWriteTable(con, "who", whol1995)
# Data model
who_dm <- dm_from_src(con) %>.%
  dm_set_colors(., red = who, darkgreen = pop) %>.% # Couleurs (optionel)
  dm_add_pk(., pop, c(country, year)) %>.% # Clé primaire pop
  dm_add_pk(., who, c(country, year, method, sex, age)) %>.% # Clé primaire who
  dm_add_fk(., who, c(country, year), pop) %->% # Clé étrangère who -> pop
  who_dm
# Graphique du schéma de la base
dm_draw(who_dm, view_type = "all")

examine_cardinality(as_dtbl(pop), c(country, year), as_dtbl(whol1995), c(country, year))


## Normalisation niveau 2

# OK, rien à faire...


## Normalisation niveau 3

# Nécessite une troisième table "countries" pour y placer iso2 et iso3

# Création du data frame coutries
whol1995 %>.%
  select(., country, iso2, iso3) %>.%
  distinct(.) %->%
  countries
head(countries)

# Elimination de iso2 et iso3 dans la table "xho"
dbExecute(con, 'ALTER TABLE "who" DROP COLUMN "iso2";')
dbExecute(con, 'ALTER TABLE "who" DROP COLUMN "iso3";')
# Vérification
dbListFields(con, "who")

# Ajout de la table "countries"
dbWriteTable(con, "countries", countries)
# Vérification
dbListTables(con)

# Rafraîchir le dm
dm_from_src(con) %>.%
  dm_set_colors(., red = who, darkgreen = pop, blue = countries) %>.% # Couleurs (optionel)
  dm_add_pk(., pop, c(country, year)) %>.% # Clé primaire pop
  dm_add_pk(., who, c(country, year, method, sex, age)) %>.% # Clé primaire who
  dm_add_pk(., countries, country) %>.% # Clé primaire countries
  dm_add_fk(., who, c(country, year), pop) %>.% # Clé étrangère who -> pop
  #dm_add_fk(., pop, country, countries) %>.% # Clé étrangère pop -> countries
  dm_add_fk(., who, country, countries) %->% # Clé étrangère who -> countries
  who_dm
# Graphique du schéma de la base
dm_draw(who_dm, view_type = "all")

# Vérification
validate_dm(who_dm)


## Requête dans la base de données 3NF avec {dm}

who_dm %>.%
  dm_filter(., who, year >= 2000 & year < 2010 & sex == "f" & age %in% c("2534", "3544", "4554")) %>.% # étape 2 filtrage
  dm_flatten_to_tbl(., who) %->%
  who_flat
head(who_flat)

who_dm %>.% # étape 1 de jointure inutile avec un objet dm
  dm_filter(., who, year >= 2000 & year < 2010 & sex == "f" & age %in% c("2534", "3544", "4554")) %>.% # étape 2 filtrage
  dm_flatten_to_tbl(., who) %>.% # Réduction en une seule table
  # Le traitement ci-dessous est identique à celui dans R !
  group_by(., country, year) %>.% # étape 3 regroupement par pays et année
  summarise(., total = first(population), all_new = sum(new_cases, na.rm = TRUE)) %>.% # étape 4 somme des cas
  mutate(., prevalence = all_new / total) %>.% # étape 5, calcul de la prévalence
  group_by(., country) %>.% # étape 6 regroupement par pays
  summarise(., mean_prev = mean(prevalence, na.rm = TRUE)) %>.% # étape 7 prévalence moyenne
  slice_max(., mean_prev, n = 10) # étape 8 garder les 10 plus élevés

# Déconnexion et nettoyage de la base de données
dbDisconnect(con, shutdown = TRUE)
unlink("duckdb_test.db") # Seulement pour effacer définitivement la base de données!

