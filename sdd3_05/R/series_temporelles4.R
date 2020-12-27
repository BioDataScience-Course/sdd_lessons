# Séries spatio-temporelles (quatrième partie)
library(pastecs)


## Décomposition par médianes mobiles
# Pas très utile sur nottem ou co2, mais essayez par vous-même...

# Données relatives à du plancton le long d'un transect
data(marbio)
ClausoB.ts <- ts(log(marbio$ClausocalanusB + 1))
ClausoB.dec <- decmedian(ClausoB.ts, order = 2, times = 10, ends = "fill")
plot(ClausoB.dec, col = c(1,4,2), xlab = "stations")

# Visualisation des différentes masses d'eaux sur le graphique (pour interprétation)
plot(ClausoB.dec, col = c(0, 2), xlab = "stations", stack = FALSE, resid = FALSE)
lines(c(17, 17), c(0, 10), col = 4, lty = 2)
lines(c(25, 25), c(0, 10), col = 4, lty = 2)
lines(c(30, 30), c(0, 10), col = 4, lty = 2)
lines(c(41, 41), c(0, 10), col = 4, lty = 2)
lines(c(46, 46), c(0, 10), col = 4, lty = 2)
text(c(8.5, 21, 27.5, 35, 43.5, 57), 8.7, labels = c("Peripheral Zone",
  "D1", "C", "Front", "D2", "Central Zone"))


## Méthode des différences
data(nottem)
not.dif <- tsd(nottem, lag = 6, method = "diff")
not.dif
plot(not.dif, col = 1:3)
## Si on prend un décalage de 6 mois
not.dif <- tsd(nottem, lag = 6, order = 1, method = "diff")
not.dif
plot(not.dif, col = 1:3)
# Pas très concluant ici!

data(co2)
plot(co2)
co2.dif <- tsd(co2, lag = 1, order = 3, method = "diff")
co2.dif
plot(co2.dif, col = 1:3)
# Spectre de co2
spectrum(co2)
# Extraire série de co2 diff
co2.dif.ts <- tseries(co2.dif)
# Transforme toute les composante
plot(co2.dif.ts) # calcul de deux séries: filtrée et résidus
# Spectre de la première série (la série filtrée)
spectrum(co2.dif.ts[, 1], spans = c(3, 5))

## Décomposition sinusoidale des températures et du CO2
Time <- time(nottem)
tser.sin <- lm(nottem ~ I(cos(2*pi*Time)) + I(sin(2*pi*Time)))
summary(tser.sin)
tser.reg <- predict(tser.sin)

tser.dec <- decreg(nottem, tser.reg)
plot(tser.dec, col = c(1, 4), xlab = "time (years)", stack = FALSE, resid = FALSE, lpos = c(0, 4))

Time <- time(co2)
# Attention : ici on superpose un modèle linéaire (tendance) à un modèle
# sinusoïdal (cycle), mais on aurait très bien pu éliminer la tendance d'abord
# Sinuasoide parfaite
tser.sin <- lm(co2 ~ I(cos(2*pi*Time)) + I(sin(2*pi*Time)))
# Idem + droite
tser.sin <- lm(co2 ~ I(cos(2*pi*Time)) + I(sin(2*pi*Time)) + Time)
summary(tser.sin)
tser.reg <- predict(tser.sin)
tser.dec <- decreg(co2, tser.reg)
plot(tser.dec, col = c(1, 4), stack = FALSE, resid = FALSE, lpos = c(0, 4))


## Décomposition par loess
## sans tendance et fenêtre périodique
?decloess
co2.loess <- tsd(co2, method = "loess",
  trend = FALSE, s.window = "periodic")
plot(co2.loess, col = 1:3)
## Avec variation d'une année à l'autre
co2.loess <- tsd(co2, method = "loess",
  trend = FALSE, s.window = 13)
plot(co2.loess, col = 1:3)
# Elimine variation saisonière mais elle varie un peu

# Avec tendance à long terme et cycle
co2.loess <- tsd(co2, method = "loess",
  trend = TRUE, s.window = 13)
plot(co2.loess, col = 1:4)
# On décompose la série initiale en 3 composantes: tendance, cycle et résidus

## Extraction des composantes en séries temporelles
co2.loess.ts <- tseries(co2.loess)
plot(co2.loess.ts)
plot(co2.loess.ts[, 2])
acf(co2.loess.ts[, 2]) # typique d'un cycle
spectrum(co2.loess.ts[, 2], span = c(3, 7))

plot(co2.loess.ts[, 1])
acf(co2.loess.ts[, 1]) # Typique d'une tendance très forte
spectrum(co2.loess.ts[, 1], span = c(3, 7))

plot(co2.loess.ts[, 3])
acf(co2.loess.ts[, 3]) # Quasi plus d'autrocorrélation
spectrum(co2.loess.ts[, 3], span = c(3, 7)) # Tout n'est pas éliminé
