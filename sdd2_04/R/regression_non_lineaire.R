# Régression non linéaire ##################################################

SciViews::R

as.function.nls <- function(x, ...) {
  nls_model <- x
  name_x <- names(nls_model$dataClasses)
  stopifnot(length(name_x) == 1)
  function(x) predict(nls_model, newdata = structure(list(x), names = name_x))
}

# Spécification complète du modèle à ajuster ------------------------------

# Exemple de la perte de poids en fonction du temps lors d'un régime amaigrissant
wtloss <- read("wtloss", package = "MASS")
summary(wtloss)
.?wtloss

# Graphe (version de base en commentaire)
#plot(data = wtloss, Weight ~ Days)
wt_plot <- chart(data = wtloss, Weight ~ Days) +
  geom_point()
show(wt_plot)

# Modèle choisi et valeur de départ des paramètres
wtlost <- function(t, b0, b1, th) b0 + b1 * 2^(-t/th)
wtlost_start <- c(b0 = 100, b1 = 85, th = 100)

# Ajustement du modèle dans les données
# ici on utilise trace = TRUE pour visualiser le processus itératif
wtloss_reg <- nls(data = wtloss, Weight ~ wtlost(Days, b0, b1, th),
  start = wtlost_start, trace = TRUE)
# Résultats numériques
summary(wtloss_reg)

# Superposition de la courbe sur le graphe
# (on a besoin d'une fonction qui renvoie les valeurs prédites en fonction de x)
#plot(data = wtloss, Weight ~ Days, pch = 16)
#wtloss_fit <- as.function(wtloss_reg); curve(wtloss_fit, col = "red", add = TRUE)
wt_plot +
  stat_function(fun = as.function(wtloss_reg), color = "red")

# Utilisation de modèles 'SelfStart' --------------------------------------

# Courbe Michaelis-Menten : SSmicmen(input, VM, K)
# Y = Vm * X/(K + X)
# Exemple de données de cinétique de type Michaelis-Menten
pur <- Puromycin[Puromycin$state == "treated", ]
?Puromycin

# Graphe
#plot(data = pur, rate ~ conc)
pur_plot <- chart(data = pur, rate ~ conc) +
  geom_point()
show(pur_plot)

# Ajustement utilisant un modèle tout fait "Self-Start"
?SSmicmen
pur_reg <- nls(data = pur, rate ~ SSmicmen(conc, Vm, K), trace = TRUE)
summary(pur_reg)

# Ajouter la courbe sur le graphe
pur_fit <- function(x) predict(pur_reg, newdata = list(conc = x))
#curve(pur_fit, col = "red", add = TRUE)
pur_plot +
  stat_function(fun = pur_fit, color = "red")


# Modèle logistique -------------------------------------------------------

## Courbe logistique: SSlogis(input, Asym, xmid, scal)
#Y = Asym/(1 + exp((xmid - X) / scal))
chicks <- read("ChickWeight", package = "datasets")
.?chicks

# Courbe de croissance de tous les poulets (version de base en commentaire)
#coplot(weight ~ Time | Chick, data = chicks, type = "b", show = FALSE)
chart(data = chicks, weight ~ Time | Chick) +
  geom_point()

# Uniquement pour le premier poulet
chicks %>.%
  filter(., Chick == 1) %>.%
  select(., Time, weight) -> chick1

#plot(data = chick1, weight ~ Time)
chick1_plot <- chart(data = chick1, weight ~ Time) +
  geom_point()
show(chick1_plot)

# Ajustement du modèle et visualisation des résultats
?SSlogis
chick1_reg <- nls( data = chick1, weight ~ SSlogis(Time, Asym, xmid, scal), trace = TRUE)
summary(chick1_reg)

# Ajout de la courbe sur le graphique
chick1_fit <- function(x) predict(chick1_reg, newdata = list(Time = x))
#curve(chick1_fit, col = "red", add = TRUE)
chick1_plot +
  stat_function(fun = chick1_fit, color = "red")

# Trouver tous les modèles 'SelfStart' disponibles:
apropos("^SS")


# Comparaison et choix du meilleur modèle ---------------------------------

# Croissance de l'oursin violet _Paracentrotus lividus_
urchin <- read("urchin.growth", package = "UsingR")
help("urchin.growth", package = "UsingR")

plot(data = urchin, size ~ age, xlab = "âge (an)", ylab = "taille (mm)")
title(expression(paste("Croissance de l'oursin ", italic("P. lividus"))))

# Séparation des points superposés sur le graphe en utilisant jitter()
plot(jitter(size) ~ jitter(age, 3), data = urchin,
  xlab = "âge (an)", ylab = "taille (mm)")
title(expression(paste("Croissance de l'oursin ", italic("P. lividus"))))

# Version ggplot2 en utilisant chart()
urchin_plot <- chart(data = urchin, size ~ age) +
  geom_jitter() +
  # Note: geom_jitter() comme geom_point() mais sépare les points superposés
  # sur le graphique
  xlab("âge (an)") +
  ylab("taille (mm)") +
  ggtitle(expression(paste("Croissance de l'oursin ", italic("P. lividus"))))
show(urchin_plot)


# Gompertz
?SSgompertz
reg_gomp <- nls(data = urchin, size ~ SSgompertz(age, Asym, b2, b3),
  trace = TRUE)
summary(reg_gomp)
AIC(reg_gomp)
# Ajouter la courbe sur le graphe
Pred <- list(age = seq(from = min(urchin.growth$age),
  to = max(urchin.growth$age), length.out = 100))
lines(Pred$age, predict(reg_gomp, newdata = Pred), col = "red")

# Courbe logistique
reg_logis <- nls(size ~ SSlogis(age, Asym, xmid, scal),
  data = urchin.growth)
summary(reg_logis)
AIC(reg_logis)
lines(Pred$age, predict(reg_logis, newdata = Pred), col = "blue")

# Weibull
?SSWeibull
reg_weib <- nls(size ~ SSweibull(age, Asym, Drop, lrc, pwr),
  data = urchin.growth)
summary(reg_weib)
AIC(reg_weib)
lines(Pred$age, predict(reg_weib, newdata = Pred), col = "green")

# Richards (pas de modèle 'SelfStart' disponible !)
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

# Quel modèle garde-t-on ? Décider à la fois en fonction de AIC et de ce que
# l'on voit sur le graphique

