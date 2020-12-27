# Machine learning (première partie)

# Matrice de confusion et métriques ---------------------------------------

# Création d'une matrice de confusion
Man  <- c("A", "B", "C", "A", "A", "C", "B", "C", "B", "B")
Auto <- c("B", "B", "C", "C", "A", "C", "B", "C", "A", "B")

# Matrice de confusion
matconf <- table(Manuel = Man, Automatique = Auto)
matconf

# Métriques
## Taux global de reconnaissance (en %)
acc <- (sum(diag(matconf)) / sum(matconf)) * 100
acc

## Taux d'erreur (en %)
100 - acc

## Taux de reconnaissance par classe
## Recall pour A
recallA <- matconf[1, 1] / sum(matconf[1, ]) * 100
recallA
## Recall pour B
recallB <- matconf[2, 2] / sum(matconf[2, ]) * 100
recallB

## Precision pour A (en %)
precA <- matconf[1, 1] / sum(matconf[, 1]) * 100
precA

## Taux de faux négatifs (par ligne) pour A (en %)
FNR <- ((sum(matconf[1, ]) - matconf[1, 1]) / sum(matconf[1, ])) * 100
FNR
## Par rapport à la prédiction manuelle

## Taux de faux positifs (par colonne) pour A (en %)
FPR <- ((sum(matconf[, 1]) - matconf[1, 1]) / sum(matconf[, 1])) * 100
FPR
## Par rapport à la prédiction automatique

## Spécificité pour A (en %)
specA <- 100 - FPR
specA

## Mesure F ou F1-score pour A (en %)
2 * (recallA * precA) / (recallA + precA)

## Précision balancée (balanced accuracy) pour A (en %)
(specA + recallA) / 2



# ADL sur iris ------------------------------------------------------------

library(MASS)
data(iris)
summary(iris)
head(iris) # Mesures et identification manuelle
# Le jeu de données iris ressemble à un set d'apprentissage
# Séparation en 2/3 apprentissage, 1/3 test
n <- nrow(iris)
n_learning <- round(n * 2/3)
set.seed(164)
learning <- sample(1:n, n_learning)
learning
iris_learn <- iris[learning, ]
nrow(iris_learn)
summary(iris_learn)
iris_test <- iris[-learning, ]
nrow(iris_test)
summary(iris_test)


## Phase 1 : apprentissage - Création d'un outil de classification
iris_lda <- lda(
  formula = Species ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,
  data = iris_learn)
# Ou plus court si on utilise toutes les variables du tableau
iris_lda <- lda(formula = Species ~ ., data = iris_learn)
iris_lda
plot(iris_lda, col = as.numeric(iris_learn$Species))


## Phase 2 : test - Matrice de confusion et métriques
# Obtenir les coordonnées des points pour les composantes de l'ADL
iris_test_pred <- predict(iris_lda, iris_test)
plot(iris_test_pred$x[, 1], iris_test_pred$x[, 2], col = iris_test$Species)

# Obtenir les classes prédites par l'ADL
iris_test_class <- predict(iris_lda, iris_test)$class
iris_test_class

# Matrice de confusion
iris_conf <- table(Manuel = iris_test$Species, Auto = iris_test_class)
iris_conf

# Taux global de reconnaissance
acc_iris <- (sum(diag(iris_conf)) / sum(iris_conf)) * 100
acc_iris

# Taux d'erreur
100 - acc_iris

# Etc.

## Calcul facilité avec le package mlearning
library(mlearning)

iris_lda2 <- mlLda(Species ~ ., data = iris_learn)
iris_lda2
summary(iris_lda2)
plot(iris_lda2, col = as.numeric(response(iris_lda2)) + 1)

# Matrice de confusion et métriques
iris_conf2 <- confusion(predict(iris_lda2, iris_test), iris_test$Species)
iris_conf2
# Toutes les métriques sont disponibles d'un coup our toutes les classes ici!
summary(iris_conf2)
plot(iris_conf2)
