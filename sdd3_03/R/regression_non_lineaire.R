# Régression non linéaire

## Régression non linéaire avec spécification de la fonction à ajuster
# Exemple de la perte de poids en fonction du temps lors d'un régime amaigrissant
library(MASS)
data(wtloss)
summary(wtloss)
?wtloss
# Graphe
plot(wtloss$Days, wtloss$Weight)
# Modèle choisi et valeur de départ des paramètres
wtlost <- function(t, b0, b1, th) b0 + b1 * 2^(-t/th)
wtlost_start <- c(b0 = 100, b1 = 85, th = 100)
# Ajustement du modèle dans les données
# ici on utilise trace = TRUE pour visualiser le processus itératif
wtloss_reg <- nls(Weight ~ wtlost(Days, b0, b1, th), data = wtloss,
  start = wtlost_start, trace = TRUE)
 # Résultats
summary(wtloss_reg)
# Superposition de la courbe sur le graphe
lines(wtloss$Days, predict(wtloss_reg), col = "blue", lwd = 2)


## Utilisation de modèles 'SelfStart'
# Courbe Michaelis-Menten: SSmicmen(input, VM, K)
# Y = Vm * X/(K + X)
# Exemple de données de cinétique de type Michaelis-Menten
PurTrt <- Puromycin[ Puromycin$state == "treated", ]
?Puromycin
# Graphe
plot(rate ~ conc, data = PurTrt)
# Ajustement utilisant un modèle tout fait "Self-Start"
?SSmicmen
fm1 <- nls(rate ~ SSmicmen(conc, Vm, K), data = PurTrt, trace = TRUE)
summary(fm1)
# Ajouter la courbe sur le graphe
lines(PurTrt$conc, predict(fm1), col = "blue", lwd = 2)
# Les points ne sont pas asez nombreux pour bien représenter la courbe
# On peut avoir une courbe mieux lissée en utilisant plus de points
plot(rate ~ conc, data = PurTrt)
# Utilisation de 100 points sur l'étendue des valeurs
x <- seq(from = min(PurTrt$conc), to = max(PurTrt$conc), length.out = 100)
lines(x, predict(fm1, newdata = list(conc = x)), col = "blue", lwd = 2)
# C'est beaucoup mieux!


## Courbe logistique: SSlogis(input, Asym, xmid, scal)
#Y = Asym/(1 + exp((xmid - X) / scal))
data(ChickWeight)
# Courbe de croissance de tous les poulets
coplot(weight ~ Time | Chick, data = ChickWeight, type = "b", show = FALSE)
# Uniquement pour le premier
Chick1 <- ChickWeight[ChickWeight$Chick == 1, c("Time", "weight")]
plot(Chick1$Time, Chick1$weight)
# Ajustement du modèle et visualisation des résultats
?SSlogis
Chick1_reg <- nls(weight ~ SSlogis(Time, Asym, xmid, scal), data = Chick1, trace = TRUE)
summary(Chick1_reg)
# Ajout de la courbe sur le graphique
x <- seq(from = min(Chick1$Time), to = max(Chick1$Time), length.out = 100)
lines(x, predict(Chick1_reg, newdata = list(Time = x)), col = "blue", lwd = 2)


## Trouver tous les modèles 'SelfStart' disponibles:
apropos("^SS")


## Modèles de croissance -comparaison et choix du meilleur modèle
# Croissance de l'oursin violet Paracentrotus lividus
library(UsingR)
data(urchin.growth)
plot(urchin.growth, xlab = "âge (an)", ylab = "taille (mm)")
title("Croissance de l'oursin P. lividus")
# Séparation des points sur le graphe
plot(jitter(size) ~ jitter(age, 3), data = urchin.growth,
  xlab = "âge (an)", ylab = "taille (mm)")
title("Croissance de l'oursin P. lividus")

## Gompertz
?SSgompertz
reg_gomp <- nls(size ~ SSgompertz(age, Asym, b2, b3),
  data = urchin.growth, trace = TRUE)
summary(reg_gomp)
AIC(reg_gomp)
# Ajouter la courbe sur le graphe
Pred <- list(age = seq(from = min(urchin.growth$age),
  to = max(urchin.growth$age), length.out = 100))
lines(Pred$age, predict(reg_gomp, newdata = Pred), col = "red")

## Courbe logistique
reg_logis <- nls(size ~ SSlogis(age, Asym, xmid, scal),
  data = urchin.growth)
summary(reg_logis)
AIC(reg_logis)
lines(Pred$age, predict(reg_logis, newdata = Pred), col = "blue")

## Weibull
?SSWeibull
reg_weib <- nls(size ~ SSweibull(age, Asym, Drop, lrc, pwr),
  data = urchin.growth)
summary(reg_weib)
AIC(reg_weib)
lines(Pred$age, predict(reg_weib, newdata = Pred), col = "green")

## Richards (pas de modèle 'SelfStart' disponible !)
Richards <- function(x, Asym, k, x0, m) Asym * (1 - exp(-k * (x - x0)))^m
reg_rich <- nls(size ~ Richards(age, Asym, k, x0, m),
  data = urchin.growth, start = c(Asym = 55, k = 1, x0 = 1, m = 1))
# Ne converge pas... essayer avec d'autres valeurs de départ
reg_rich <- nls(size ~ Richards(age, Asym, k, x0, m),
  data = urchin.growth, start = c(Asym = 55, k = .5, x0 = 0, m = 1), trace = TRUE)
summary(reg_rich)
AIC(reg_rich)
lines(Pred$age, predict(reg_rich, newdata = Pred), col = "black")

# Ajouter une légende au graphique final
legend(5, 20, c("Gompertz", "Logistique", "Weibull", "Richards"),
    col = c("red", "blue", "green", "black"), lwd = 2)

# Quel modèle garde-t-on? Décider à la fois en fonction de AIC et de ce que
# l'on voit sur le graphique
