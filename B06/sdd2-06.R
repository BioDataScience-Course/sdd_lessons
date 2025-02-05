# SDDII : CAH

SciViews::R("explore", lang = "fr")

# Matrice de distance -----------------------------------------------------

# Calculez la matrice de distances selon l'indice de dissimilarité de
# Bray-Curtis (arrondissez à 2 décimales; représentez uniquement le triangle
# inférieur de la matrice) entre stations correspondant à ce jeu de données
# (détaillez vos calculs).

set.seed(20)
sp1 <- sample(x = 1:30, size = 5)
sp2 <- sample(x = 1:30, size = 5)
sp3 <- sample(x = 1:30, size = 5)
sp4 <- sample(x = 1:30, size = 5)
sp5 <- sample(x = 1:30, size = 5)
q_1 <- data.frame(
  Espece1 = sp1,
  Espece2 = sp2,
  Espece3 = sp3,
  Espece4 = sp4,
  Espece5 = sp5
)
rownames(q_1) <- paste0("Station", 1:5)
knitr::kable(q_1)

# solution
round(dissimilarity(q_1, method = "bray"), 2)


# CAH ---------------------------------------------------------------------

set.seed(66)
q_2 <- data.frame(
  Espece1 = sample(x = 1:50, size = 5),
  Espece2 = sample(x = 1:50, size = 5),
  Espece3 = sample(x = 1:50, size = 5),
  Espece4 = sample(x = 1:50, size = 5),
  Espece5 = sample(x = 1:50, size = 5)
)
rownames(q_2) <- paste0("Station", 1:5)
round(mat <- dissimilarity(q_2, method = "canberra"), 2)

# Dessinez le dendrogramme par lien complet sur base de la matrice de distance
# ci-dessus.

# solution
cluster(mat, method = "complete") |> chart()
