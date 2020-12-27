# Cours 5: manipulation de tableau et databases

SciViews::R

library(pryr)
data(iris)
iris
object_size(iris)

# Si on peut traiter un tableau qui occupe 2Go
150/7*2e6 # Environ 40 millions de lignes

## Database management
# Toutes les données que R manipule sont stockées en mémoire => problème avec
# les très gros jeux de données!
# Une solution est d'utiliser des bases de données et des requêtes d'extraction
# Explication de bases de données relationnelles
# Language SQL
# ex: SELECT * FROM table
#     SELECT `x`, y, z FROM table WHERE x > 0 ORDER BY y
# Autres exemples dans manuel
#
# Il faut:
# - Un driver
# - Se connecter à une base
# - Utiliser une requête pour récupérer la fraction des données à traiter
#
# Concernant les drivers, il faut mettre en place des logiciels externes pour
# toutes les bases de données, sauf une: SQLite => démo de son utilisation
# Exemple:
# Création d'une base de données pour stocker une table
# create a SQLite instance and create one connection.
library('RSQLite')

m <- dbDriver('SQLite')

# Connxion à une base de données sur le disque
dbfile <- 'data/dbtest.sqlite'
con <- dbConnect(m, dbname = dbfile)
data(iris)
dbWriteTable(con, 'iris', iris)

# Information à propos de la connexion
show(con)
dbIsValid(con)

# Accès à plus de fonctions dans SQLite
initExtension(con)
# Maintenant, la fonction median() est aussi disponible
dbGetQuery(con, "select median(`Petal.Length`) from iris")

# Récupère une table
dbExistsTable(con, "iris")
(iris2 <- dbReadTable(con, "iris"))
dbListFields(con, "iris")
dbListTables(con)


# Requête SQL -------------------------------------------------------------

# Simple
df <- dbGetQuery(con, "select * from iris")
df$Petal.Length

# Avec plus de contrôle
rs <- dbSendQuery(con, "select * from iris")
(d1 <- fetch(rs, n = 10))      # 10 lignes
dbGetInfo(rs)
dbHasCompleted(rs)
dbGetRowCount(rs)
(d2 <- fetch(rs, n = -1))      # tout ce qui reste
dbHasCompleted(rs)
dbClearResult(rs)

# Récupère seulement les données de setosa pour les pétales
dbGetQuery(con, "select `Petal.Length`, `Petal.Width` from iris where Species = 'virginica' and `Sepal.Length` > 7")

# Les requêtes SQL peuvent également modifier des tables
# Exemple: effacer toutes les données concernant virginica et versicolor
rs2 <- dbSendQuery(con, "delete from iris where Species in ('virginica', 'versicolor')")
# utiliser "delete from table" pour effacer tout le contenu de la table, sans
# effacer la table elle-même
dbGetRowsAffected(rs2) # 100 lignes éliminées

# Nettoyer une base de données
dbSendQuery(con, "vacuum")

# Impossible de remplacer une table existante sans l'effacer d'abord
dbWriteTable(con, "iris", iris) # Pas accepté
# mais...
dbRemoveTable(con, "iris")
dbWriteTable(con, "iris", iris) # Accepté

# Toujours se rappeler de se déconnecter à la fin!
dbDisconnect(con)
file.info(dbfile)



# dplyr sur bases de données ----------------------------------------------

# Pouvoir traiter des tables de bases de données comme
# si c'était des dataframes classiques à l'aide de dplyr.
dbfile <- "data/dbtest.sqlite"
# Utiliser src_XXX() pour se connecter à une base de données. Ex. src_mysql(),
# src_postgres(), src_bigquery() ou src_sqlite()
my_db <- src_sqlite(dbfile) # Utiliser create = TRUE pour la créer
my_db
# Ici, on peut utiliser copy_to() pour copier des données R dans la base
# copy_to permet aussi de spécifier des index
# Exemple:
#library(nycflights13)
#flights_sqlite <- copy_to(my_db, flights, temporary = FALSE, indexes = list(
#  c("year", "month", "day"), "carrier", "tailnum"))

my_table <- tbl(my_db, sql("SELECT * FROM iris"))
# Notez qu'on ne connait pas le nombre de lignes car la table n'est PAS chargée en mémoire!
(df2 <- collect(my_table))

# Utilisation des verbes select(), filter(), arrange(), mutate(), summarise()
# sur la base
# Selectionner quelques variables
select(my_table, Sepal.Width, Petal.Length:Species)
# Filtrer les fleurs à gros pétales
filter(my_table, Petal.Length > 1.5)
# Réarranger les lignes par longueur de pétale croissante et largeur de sépale décroissant
arrange(my_table, Petal.Length, desc(Sepal.Width))
# Créer une nouvelle variables
mutate(my_table, logPL = log10(Petal.Length))
# Résumer les données
explain(summarise(my_table, taille = median(Petal.Length)))

# On peut naturellement chainer tout cela avec le pipe %>% de tidyverse,
# ou celuis de SciViews::R %>.%, ou combiner les requêtes
# comme on veut. Rien n'est fait avant de *collect()*er les résultats!
my_table %>.%
  filter(., Petal.Length > 1.5) %>.%
  select(., Petal.Length, Sepal.Width, Species) %>.%
  mutate(., logPL = log10(Petal.Length)) -> query1
query2 <- arrange(query1, Petal.Length, desc(Sepal.Width))
query2
# Récupérer le résultat
res <- collect(query2)
res
# En arrière plan, dplyr a traduit vos commandes en requêtes SQL directement
# dans la base de données. explain() détaille ce qui est fait:
explain(query2)

# Le résultat de la requête peut être également laissé dans la base de données:
# compute() stocke le résultat dans une table temporaire dans la base
# collapse() transforme la requête en une nouvelle table dans la base

# dbplyr::translate_sql() indique comment du code R est tranformé en requête SQL
dbplyr::translate_sql(x^3 < 15 || y > 20)
dbplyr::translate_sql(mean(x))
dbplyr::translate_sql(mean(x, na.rm = TRUE))
# Tout ne fonctionne pas, car R offre plus de possibilités que SQL
dbplyr::translate_sql(plot(x)) #???
dbplyr::translate_sql(mean(x, trim = TRUE))

# Il est aussi possible de grouper les données, mais pas avec SQLite (avec PosgreSQL)
# (voir la vignettes correspondante de dplyr)



# Exercices de manipulation de données ------------------------------------

cats <- read("cats", package = "MASS")
View(cats)

# 1) Séparer les males des femelles
catsM <- cats[cats$Sex == "M", ]
catsF <- cats[cats$Sex == "F", ]

# 2) Extraire tous les chats dont le poids total
#    et le poids de coeur > 3ème quartile
cats3q <- cats[cats$Bwt > quantile(cats$Bwt, 0.75) &
	cats$Hwt > quantile(cats$Hwt, 0.75), ]

# 3) Idem pour < 1er quartile
cats1q <- cats[cats$Bwt < quantile(cats$Bwt, 0.25) &
	cats$Hwt < quantile(cats$Hwt, 0.25), ]

# 4) Rassembler les deux tableaux
catsExtremes <- rbind(cats1q, cats3q)

# 5) Calculer log Bwt et Hwt, présenter le tableau
#    Sex, logHwt, Hwt, logBwt, Bwt + M d'abord et puis F
cats$logHwt <- log10(cats$Hwt)
cats$logBwt <- log10(cats$Bwt)
cats2 <- cats[order(as.numeric(cats$Sex),
	decreasing = TRUE),
	c("Sex", "logHwt", "Hwt", "logBwt", "Bwt")]

# 5bis) Ordre croissant de logHwt, puis logBwt
cats3 <- cats[order(cats$Bwt), ]
cats3 <- cats3[order(cats3$Hwt), ]

# Changer l'ordre des niveaux de la variable facteur
data(iris)
iris$Species
# Tri versicolor, virginica, setosa
# Changer l'ordre des niveaux
Sp2 <- factor(as.character(iris$Species),
	levels = c("versicolor", "virginica", "setosa"))
iris[order(as.numeric(Sp2)), ]

# Apply et co
apply(cats[, -1], 2, mean)
tapply(cats$Bwt, cats$Sex, mean)

# Exécution conditionnelle
if (nrow(cats) > 200) {
	cat("Tableau trop volumineux\n")
} else {
	cat("Calcul très long...\n")
}

# Traitement sur toutes les lignes (mieux = apply()!)
i <- 1
while (i <= nrow(cats)) {
	cat("chat", i, "de poids", cats[i, "Bwt"], "\n")
	i <- i + 1
}

# Boucle for, lorsqu'on sait combien de fois on doit réitérer
for (i in 1:nrow(cats)) {
	cat("chat", i, "de poids", cats[i, "Bwt"], "\n")
}



# Requêtes SQL dans un data frame -----------------------------------------

# Pas dans SciViews Box 2018 !!!
# SQLiteDF : traiter un data.frame comme une base de données et pouvoir
#install.packages('SQLiteDF')
# utiliser des requêtes SQL dessus
library('SQLiteDF')
data(iris)
iris.sdf <- sqlite.data.frame(iris)
names(iris.sdf)
# Notez que les noms sont conservés... de même que d'autres caractéristiques
# telles que les niveaux exacts des variables 'factor'
class(iris.sdf)
iris.sdf$Petal.Length[1:10]
iris.sdf[["Petal.Length"]][1:10]
iris.sdf[1, c(TRUE, FALSE)]
lsSdf() # Les tables sont nommées data1, data2, ..., par défaut
# Mais il est possible aussi d'utiliser d'autres noms!
