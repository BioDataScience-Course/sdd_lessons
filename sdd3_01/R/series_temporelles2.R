# Séries spatio-temporelles (seconde partie)

# Repartons de notre exemple de série temporelle: température à Nottingham
data(nottem)
nottem
?nottem
plot(nottem)

data(co2)
co2
?co2
plot(co2)

## Identification de tendance à long terme
# Tendance générale / globale
library(pastecs)
# Test classique de signification du coefficient de Spearman (moins adapté pour les ts!)
trend.test(nottem) # Valeur p = 0.41 (valable uniquement si pas d'autocarrelation)
# Même test, mais par bootstrap (mieux!) => R = 999, rééchantillonage 999x
nottem_trend_test <- trend.test(nottem, R = 999)
nottem_trend_test
# Visualisation graphique
plot(nottem_trend_test)
# Valeur p associée au test bootstrappé
nottem_trend_test$p.value # 0.20 -> pas de tendance significative au seuil alpha de 5%


## Etude de la tendance locale
# Utilisation des sommes cumulées avec local.trend()
not.lt <- local.trend(nottem)
# le cycle annuel perturbe l'analyse pluriannuelle
# -> aggrégation des données par an
nottem2 <- aggregate(nottem, 1, mean)
nottem2
plot(nottem2)
# Graphe après aggrégation
not.lt2 <- local.trend(nottem2)
# La courbe en rouge (somme cumulées) amplifie les variations
# Choisir manuellement les points à identifier
# ATTENTION: identify() ne peut PAS être utilisée dans un R Markdown ou Notebook
# Cette fonction doit être utilisée seulement dans le fenêtre console de R!!!
identify(not.lt2) # Cliquer les points voulus, puis indiquer "finish"...

# Création d'une série artificielle
x2.random <- rnorm(100) # composante aléatoire = bruit
plot(x2.random, type = "l") # graphe de ces données
# Choix des moyennes
x2.means <- c(rep(5, 50), rep(6, 50))
plot(x2.means, type = "l")
# Signal observé = somme des 2 signaux
x2 <- (x2.means + x2.random)
plot(x2)
# Transformation en objet 'ts'
x2.ts <- as.ts(x2)
plot(x2.ts)
# Recherche de tendances à l'aide des sommes cumulées
x2.lt <- local.trend(x2)
# Identifier les zones à la souris (RAPPEL: pas dans R Markdown!)
identify(x2.lt)


## Analyse spectrale
spectrum(nottem) # Cycle annuel
# Technique très puissante, mais signal brut bruité => lissage nécessaire!
# Lissage du spectre pour mieux voir
?spectrum
# L'argument 'spans' affectue ce lissage (voir cours)
# Il n'y a pas de règle stictes. Il faut juste deux nombres impairs
spectrum(nottem, spans = c(3, 7))
# Permet de mieux mettre en évidence les pics significatifs
