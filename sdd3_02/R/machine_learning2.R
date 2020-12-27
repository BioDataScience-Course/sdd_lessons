# Machine learning (seconde partie)

# LDA sur iris (rappel) ---------------------------------------
library(mlearning)

data(iris)
# La version de mlearning sur la SciViews Box 2018 a besoin absolument d'un data frame
iris <- as.data.frame(iris)
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


iris_lda <- mlLda(Species ~ ., data = iris_learn)
iris_lda
# Matrice de confusion et métriques
iris_lda_conf <- confusion(predict(iris_lda, iris_test), iris_test$Species)
iris_lda_conf
plot(iris_lda_conf)
summary(iris_lda_conf)


# Idem mais avec validation croisée ---------------------------------------
# Ici, on utilise donc TOUTES les données!
iris_lda2 <- mlLda(Species ~ ., data = iris)
iris_lda_conf2 <- confusion(cvpredict(iris_lda2, cv.k = 10), iris$Species)
iris_lda_conf2
plot(iris_lda_conf2)
summary(iris_lda_conf2)

## Leave-one-out
iris_lda_conf3 <- confusion(cvpredict(iris_lda2, cv.k = 150), iris$Species)
iris_lda_conf3
plot(iris_lda_conf3)
summary(iris_lda_conf3)


# kNN sur iris ---------------------------------------

# Pas avec mlearning, mais disponible dans MASS ou ipred
library(ipred)
# k = nombre de proches voisins à considérer
iris_knn <- ipredknn(Species ~ ., data = iris_learn, k = 3)
iris_knn # Pas très utile : trop détaillé!
predict(iris_knn, type = "class")
# Matrice de confusion obtenue par validation croisée
# (c'est un peu plus tordu qu'avec mlearning!)
# Problème avec l'argument k = qui correspond à errorest() et ipredknn()
# Donc, on doit définir sa propre fonction...
knn3 <- function(formula, data, k = 3)
  ipredknn(formula, data = data, k = k)
# Forcer predict() à renvoyer les classes automatiques
predict_class <- function(object, newdata)
  predict(object, newdata = newdata, type = "class")
# Validation croisée 10 fois (k = 10)
iris_knn_error <- errorest(Species ~ ., data = iris, model = knn3,
  estimator = "cv", predict = predict_class,
  est.para = control.errorest(predictions = TRUE))
iris_knn_conf <- confusion(iris_knn_error$predictions, iris$Species)
iris_knn_conf
plot(iris_knn_conf)
summary(iris_knn_conf)


# LVQ sur iris ---------------------------------------
# k.nn = nombre de proches voisins
iris_lvq <- mlLvq(Species ~ ., data = iris, k.nn = 3)
iris_lvq_conf <- confusion(cvpredict(iris_lvq, cv.k = 10), iris$Species)
iris_lvq_conf
plot(iris_lvq_conf)
summary(iris_lvq_conf)

# Quel algorithme vous part-il le meilleur ici?
