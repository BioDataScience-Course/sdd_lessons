# Machine learning (troisième partie)

# Partitionnement récursif sur iris --------------------------------------------
library(mlearning)
library(ipred)
library(rpart)

data(iris)
# La version de mlearning sur la SciViews Box a besoin absolument d'un data frame
iris <- as.data.frame(iris)

iris_rpart <- rpart(Species ~ ., data = iris)
iris_rpart
# Visualisation de l'arbre de partitionnement
plot(iris_rpart, margin = 0.07)
text(iris_rpart, use.n = TRUE)
# Matrice de confusion et métriques, via validation croisée 10x
# Forcer predict() à renvoyer les classes automatiques
predict_class <- function(object, newdata)
  predict(object, newdata = newdata, type = "class")
# Validation croisée 10 fois (k = 10)
iris_rpart_error <- errorest(Species ~ ., data = iris, model = rpart,
  estimator = "cv", predict = predict_class,
  est.para = control.errorest(k = 10, predictions = TRUE))
iris_rpart_conf <- confusion(iris_rpart_error$predictions, iris$Species)
iris_rpart_conf
plot(iris_rpart_conf)
summary(iris_rpart_conf)


# Random forest sur iris -------------------------------------------------------
iris_rf <- mlRforest(Species ~ ., data = iris)
iris_rf_conf <- confusion(cvpredict(iris_rf, cv.k = 10), iris$Species)
iris_rf_conf
plot(iris_rf_conf)
summary(iris_rf_conf)
# Ici, la matrice de confusion obtenue à l'aide des données d'apprentissage
# montre bien le biais:
confusion(predict(iris_rf), iris$Species)

# Optimisation via le choix du nombre d'arbres
plot(iris_rf)
# 250 arbres sont suffisants ici
iris_rf2 <- mlRforest(Species ~ ., data = iris, ntree = 250)
iris_rf2_conf <- confusion(cvpredict(iris_rf2, cv.k = 10), iris$Species)
iris_rf2_conf
plot(iris_rf2_conf)
summary(iris_rf2_conf)


# Réseau de neurones avec iris -------------------------------------------------
iris_nnet <- mlNnet(Species ~ ., data = iris)
iris_nnet_conf <- confusion(cvpredict(iris_nnet, cv.k = 10), iris$Species)
iris_nnet_conf
plot(iris_nnet_conf)
summary(iris_nnet_conf)
# Test de différentes tailles de réseaux de neurones
library(dplyr)
nnet_size <- . %>%
  mlNnet(formula = Species ~ ., data = iris, size = .) %>%
  cvpredict(cv.k = 10) %>%
  confusion(iris$Species)

nnet_size(10)
nnet_size(20)
nnet_size(30)
nnet_size(40)
nnet_size(50)
# Devient meilleur avec la taille du réseau...
# mais le temps de calcul augmente exponentiellement!
#

# Machine à vecteur supports avec iris -----------------------------------------
iris_svm <- mlSvm(Species ~ ., data = iris)
iris_svm_conf <- confusion(cvpredict(iris_svm, cv.k = 10), iris$Species)
iris_svm_conf
plot(iris_svm_conf)
summary(iris_svm_conf)

# La plupart des algorithmes ont des paramètres ajustables. Il ne suffit donc
# pas simplement d'exécuter les fonctions avec les valeurs par défaut, mais il
# faut expérimenter des variations également.
# Voir l'aide en ligne des fonctions (?rpart, ?mlRforest)

# Par exemple, on peut choisir le noyau (kernel) de transformation des données. Il
# est radial par défaut. essayons d'autres options
library(dplyr)
svm_kernel <- . %>%
  mlSvm(formula = Species ~ ., data = iris, kernel = .) %>%
  cvpredict(cv.k = 10) %>%
  confusion(iris$Species)

# Noyau radial, valeur par défaut
svm_kernel("radial")

# Noyau linéaire
svm_kernel("linear")

# Noyau polynomial
svm_kernel("polynomial")

# Noyau sigmoidal
svm_kernel("sigmoid")

# Cela ne change pas grand chose pour un exemple aussi basique, mais essayez sur
# d'autres jeux de données... (radial est peut-être sensiblement meilleur)?
