SciViews::R("explore")
zoo <- read("zooplankton", package = "data.io")
zoo %>.%
  sselect(., -class) %>.% # Élimination de la colonne class
  # Matrice de dissimilarité sur données standardisées
  dissimilarity(., method = "euclidean", scale = TRUE) %>.%
  cluster(., method = "ward.D2") -> # CAH avec Ward D2
  zoo_clust

# Dendrogramme horizontal et sans labels (plus lisible si beaucoup d'items)
chart$horizontal(zoo_clust, labels = FALSE) +
  geom_dendroline(h = 70, color = "red") + # Séparation en 3 groupes
  ylab("Hauteur")

zoo <- augment(zoo_clust, data = zoo, h = 70)

# Comparaison class avecd .fitted
table(Classe = zoo$class, CAH = zoo$.fitted)

table(CAH = zoo$.fitted, Classe = zoo$class)
