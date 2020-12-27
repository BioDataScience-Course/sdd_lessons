# plankton analysis
# package-----
SciViews::R
library(MASS)

#plankton <- readr::read_csv("sdd3_19/data/plankton_set.csv")
test <- data.io::read("sdd3_19/data/plankton_set.csv")

test$Class <- as.factor(test$Class)

test <- as.data.frame(test)
# ADL simple

n <- nrow(test)
n_learning <- round(n * 2/3)
set.seed(164)

learning <- sample(1:n, n_learning)
learning
test_learn <- test[learning, ]
nrow(test_learn)
summary(test_learn)
test_test <- test[-learning, ]
nrow(test_test)
summary(test_test)

# Ou plus court si on utilise toutes les variables du tableau
test_lda <- lda(formula = Class ~ ., data = test_learn)
test_lda
plot(test_lda, col = as.numeric(test_learn$Class))


## Phase 2 : test - Matrice de confusion et métriques
# Obtenir les coordonnées des points pour les composantes de l'ADL
test_test_pred <- predict(test_lda, test_test)
plot(test_test_pred$x[, 1], test_test_pred$x[, 2], col = test_test$Class)

# Obtenir les classes prédites par l'ADL
test_test_class <- predict(test_lda, test_test)$class
test_test_class

# Matrice de confusion
test_conf <- table(Manuel = test_test$Class, Auto = test_test_class)
test_conf

# Taux global de reconnaissance
acc_test <- (sum(diag(test_conf)) / sum(test_conf)) * 100
acc_test

# Taux d'erreur
100 - acc_test


# adl avec matrice de confusion-----------------------------------------------------

plankton_lda2 <- mlLda(Class ~ ., data = test)
plankton_lda_conf2 <- confusion(cvpredict(plankton_lda2, cv.k = 10), test$Class)
plankton_lda_conf2
summary(plankton_lda_conf2)

# LVQ  ---------------------------------------
# k.nn = nombre de proches voisins
plankton_lvq <- mlLvq(Class ~ ., data = test, k.nn = 3)
plankton_lvq_conf <- confusion(cvpredict(plankton_lvq, cv.k = 10), test$Class)
plankton_lvq_conf
summary(plankton_lvq_conf)


plankton_rf <- mlRforest(Class ~ ., data = test)
plankton_rf_conf <- confusion(cvpredict(plankton_rf, cv.k = 10), test$Class)
plankton_rf_conf
summary(plankton_rf_conf)
# Ici, la matrice de confusion obtenue à l'aide des données d'apprentissage
# montre bien le biais:
confusion(predict(plankton_rf), test$Class)

plot(plankton_rf)

# Réseau de neurones avec iris -------------------------------------------------
plankton_nnet <- mlNnet(Class ~ ., data = test)
plankton_nnet_conf <- confusion(cvpredict(plankton_nnet, cv.k = 10), test$Class)
plankton_nnet_conf
summary(plankton_nnet_conf)
