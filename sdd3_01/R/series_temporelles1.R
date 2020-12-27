# Séries spatio-temporelles (première partie)

# Exemple de série temporelle
data(nottem)
nottem
?nottem

# Type d'objet de nottem
class(nottem) # Objet de type 'ts' (time series)
# Structuration de l'objet en interne
unclass(nottem)
# C'est un vecteur de nombres de 1 a 240
# avec un attribut tsp depart, fin et fréquence
# unité année, mesures mensuelles => 12 observations par unité de temps
# 1 / mois .917 ! 11/12 de l'année (voir dernier mois)
time(nottem)

# Graphique
plot(nottem) # fournit le graphe le plus adéquat (connexion des points)
# Calcul des cycle
cycle(nottem)
# Tous les mois de janvier sont numérotés 1, février = 2, etc.
# Sépararer la série en fonction des cycles
split(nottem, cycle(nottem))
# $1 = toutes les mesure du mois de janvier, $2 = février, etc.
# Boites de dispersion des données mensuelles
boxplot(split(nottem, cycle(nottem)))
# Fonction personnalisée pour plus de confort
boxplotByCycle <- function(ts) boxplot(split(ts, cycle(ts)))

boxplotByCycle(nottem)

# Statistiques glissantes
library(pastecs) # besoin de ce package
?stat.slide
# Statistiques par 6 ans
# Vecteur temps
not.stat <- stat.slide(time(nottem), nottem, xmin = 1920, deltat = 6)
not.stat
# Calcul de quelques descripteurs statistiques
# Représentation graphique de ces valeurs
plot(not.stat) # note: température moyenne en constante augmentation

# Propriétés de la série
# Autocorrélation
?acf
acf(nottem)

# Comparaison avec une série purement aléatoire
x <- rnorm(240) # vecteur avec données aléatoires
x
# Création d'une série temporelle
?ts
x.ts <- ts(x, start = 1920.000, frequency = 12)
x.ts
# Cette série n'a pas d'autocorrélation
acf(x.ts)

