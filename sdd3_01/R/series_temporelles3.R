# Séries spatio-temporelles (troisième partie)

# Repartons de nos exemples de série temporelles: température à Nottingham et CO2 à Hawaï
data(nottem)
nottem
?nottem
plot(nottem)

data(co2)
co2
?co2
plot(co2)

library(pastecs)

# Décomposition de séries régulières
# fonction tsd()
?tsd

# Lissage par moyennes mobiles
?decaverage

time(co2)	# données mensuelle
## Fenêtre de 12 mois -> élimine la tendance saisonnière
co2.avg <- tsd(co2, method = "average", type = "additive",
  order = 6, times = 3)
## Si 'times' augmente alors le lissage est plus fort
co2.avg
plot(co2.avg, col = 1:3)
# On voit bien que le choix judicieux de la fenêtre a permis d'éliminer
# complètement l'effet saisonnier

# Même chose sur nottem
not.avg <-  tsd(nottem, method = "average", type = "additive",
  order = 6, times = 10)
plot(not.avg, col = 1:3)
# Autre façon de représenter les résultats, en superposant les courbes
plot(not.avg, col = 1:2, stack = FALSE, resid = FALSE)

# Transformation en séries temporelles multiples
not.avg.ts <- tseries(not.avg)
is.ts(not.avg) # Non
is.ts(not.avg.ts) # Oui
is.mts(not.avg.ts) # Aussi
plot(not.avg.ts)

# Exttraction d'une ou plusieurs composantes
not.avg.filtered <- extract(not.avg, components = "filtered")
is.ts(not.avg.filtered) # Oui
is.mts(not.avg.filtered) # Non
plot(not.avg.filtered)
# Analyse
acf(not.avg.filtered)
spectrum(not.avg.filtered, span = c(3, 5))
(not.avg.trend <- trend.test(not.avg.filtered, R = 999))
plot(not.avg.trend)
not.avg.trend$p.value # Tendance significative (compare with same test before filtration!)

not.avg.resid <- extract(not.avg, components = "residuals")
is.ts(not.avg.resid) # Oui
is.mts(not.avg.resid) # Non
plot(not.avg.resid)
# Analyse
acf(not.avg.resid) # Effet saisonnier très marqué
spectrum(not.avg.resid, span = c(3, 5)) # Idem
(not.avg.resid.trend <- trend.test(not.avg.resid, R = 999))
plot(not.avg.resid.trend)
not.avg.resid.trend$p.value # Absoluement pas de tendance générale

# Conclusion: la tendance générale et le cycle saisonnier ont été remarquablement
# bien séparés l'un de l'autre par le filtrage par les moyennes mobiles

# Les deux composantes étaient déjà visibles dès le départ pour co2,
# mais à titre d'exercice, faite la même chose sur cette série...
#
