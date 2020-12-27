# Séries spatio-temporelles (cinquième partie)
library(pastecs)

## Régularisation de séries
data(releve)  # série totalement irrégulière
names(releve) # variable phytoplancton
head(releve)

# Graphe d'une série
library(tidyverse)
releve %>% ggplot() + geom_line(mapping = aes(x = Day, y = Melosul))
# ou
#plot(releve$Day, releve$Melosul, type = "l")
# A priori assez anarchique avec pas de temps irrégulier!

# Etude des intervalle de temps
releve$Day # jour des mesure
# Quels sont les écart entre les observation?
# -> différence entre les observations 2 à 2
releve$Day[2:61] - releve$Day[1:60]

# Calcul de l'écart moyen
mean(releve$Day[2:61] - releve$Day[1:60])
range(releve$Day[2:61] - releve$Day[1:60]) # min et max

# Quel intervalle prendre?
# Recherche de la meilleure grille régulière en utilisant regul.screen()
regul.screen(releve$Day, xmin = 1:11, deltat = 16:27)
# xmin commence du jour 1 au jour 11 et deltat intervalle de 16 à 27 j
# Trois valeur importantes: n, exact et match
regul.adj(releve$Day, xmin = 8, deltat = 21)
# Choix de la tolérance
# Donne le nombre d'observation par rapport à la grille choisie

# Régularisation par valeur constante
#xmin = 8 , deltat 21 , n = 63
relreg <- regul(releve$Day, releve$Melosul,
  xmin = 8, deltat = 21, tol = 3.1, n = 63,
  methods = "c")
relreg
plot(relreg)

# Régularisation par valeur linéaire
relreg <- regul(releve$Day, releve$Melosul,
  xmin = 8, deltat = 21, tol = 3.1, n = 63,
  methods = "l")
relreg
plot(relreg)

# Régularisation par courbes splines
relreg <- regul(releve$Day, releve$Melosul,
  xmin = 8, deltat = 21, tol = 3.1, n = 63,
  methods = "s")
relreg
plot(relreg)

# Régularisation par la méthode des aires
relreg <- regul(releve$Day, releve$Melosul,
  xmin = 8, deltat = 21, tol = 3.1, n = 63,http://127.0.0.1:28053/graphics/plot_zoom_png?width=816&height=583
  methods = "a")
relreg
plot(relreg)

# Transformation de relreg en série temporelle
rel.ts <- tseries(relreg)
plot(rel.ts) # graphe de la série temporelle
class(rel.ts)
acf(rel.ts)  # possible car série régulière


## Prédiction (démonstration)
# Il faut installer le package R prophet
#install.packages("prophet")
library(prophet)
library(DAAG)
data(SP500close)
?SP500close
plot(SP500close, type = "l")

# Il faut un data frame avec ds (la date) et y (le signal) pour prophet
SP500 <- data.frame(ds = as.Date("1990-01-01") + 0:(length(SP500close) - 1),
                     y = SP500close)
plot(SP500, type = "l")

# Analyse
SP500.pred <- prophet(SP500)
# Décider des valeurs futures à prédire (1 an)
future <- make_future_dataframe(SP500.pred, periods = 365)
tail(future)
# Effectuer la prédiction
forecast <- predict(SP500.pred, future)
tail(forecast) # Beaucoup d'information!
plot(SP500.pred, forecast)
# Examiner les composantes
prophet_plot_components(SP500.pred, forecast)
# On constate que la méthode prend en compte à la fois une tendance à long terme
# une variation siasonnière,
# mais aussi une variation en fonction du jour de la semaine!
#
