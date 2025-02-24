# Effet des types de liens
SciViews::R("explore")
zoo <- read("zooplankton", package = "data.io")

zoo %>.%
  select(., -class) %>.%   # Élimination de la colonne class
  slice(., 13:28) ->       # Récupération des lignes 13 à 18
  zoo6

zoo6 %>.% # Matrice de dissimilarité sur données standardisées
  dissimilarity(., method = "euclidean", scale = TRUE) ->
  zoo6std_dist

# Liens complets
zoo6std_dist %>.%
  cluster(.) ->
  zoo6std_clust # Calcul du dendrogramme
chart(zoo6std_clust) +
  ylab("Hauteur")

# Liens moyens
zoo6std_dist %>.%
  cluster(., method = "average") ->
  zoo6std_clust # Calcul du dendrogramme
chart(zoo6std_clust) +
  ylab("Hauteur")

# Liens simples
zoo6std_dist %>.%
  cluster(., method = "single") ->
  zoo6std_clust # Calcul du dendrogramme
chart(zoo6std_clust) +
  ylab("Hauteur")

# Liens simples
zoo6std_dist %>.%
  cluster(., method = "single") ->
  zoo6std_clust # Calcul du dendrogramme
chart(zoo6std_clust) +
  ylab("Hauteur")

# Liens médians
zoo6std_dist %>.%
  cluster(., method = "median") ->
  zoo6std_clust # Calcul du dendrogramme
chart(zoo6std_clust) +
  ylab("Hauteur")
