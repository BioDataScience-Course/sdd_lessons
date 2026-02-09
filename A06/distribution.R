# SDD I module 6
# Copyright (c) 2026, Philippe Grosjean & Guyliann Engels
# Exercice de calcul de distribution
# Solution wooclap sur les distribution.

SciViews::R("infer", lang = "fr")


# Exercice sur les distributions ------------------------------------------

## Distribution uniforme continue 0 à 20 : quantile pour avoir 25% aire à gauche
dist <- dist_uniform(min = 0, max = 20)
chart(dist)

quantile(dist, 0.25)
# ou
qunif(0.25, min = 0, max = 20)

# Représentation graphique
chart(dist) +
  geom_funfill(fun = dfun(dist), from = 0, to = 5)

## Distribution uniforme continue 0 à 20 : quantile pour avoir 25% aire à droite
qunif(0.25, min = 0, max = 20, lower.tail = FALSE)

chart(dist) +
  geom_funfill(fun = dfun(dist), from = 15, to = 20)

## Distribution uniforme continue 0 à 20 : probabilité pour valeur supérieur à 7
punif(7, min = 0, max = 20, lower.tail = FALSE)

chart(dist) +
  geom_funfill(fun = dfun(dist), from = 7, to = 20)

## Distribution uniforme continue 0 à 20 : probabilité pour valeur entre 12 et 15
punif(12, min = 0, max = 20, lower.tail = FALSE) -
  punif(15, min = 0, max = 20, lower.tail = FALSE)

# ou

punif(15, min = 0, max = 20, lower.tail = TRUE) -
  punif(12, min = 0, max = 20, lower.tail = TRUE)

chart(dist) +
  geom_funfill(fun = dfun(dist), from = 12, to = 15)


# Distribution uniforme 1, 8 : probabilité pour valeur supérieur à 6 -----

dist <- dist_uniform(min = 1, max = 8)
chart(dist) +
  geom_funfill(fun = dfun(dist), from = 6, to = 8)

# Version avec {distributional}
1 - cdf(dist, 6)

# Version R de base
punif(6, min = 1, max = 8, lower.tail = FALSE) # Attention lower.tail


# Distribution uniforme 1, 8 : probabilité pour valeur inférieur à 5 -----

dist <- dist_uniform(min = 1, max = 8)
chart(dist) +
  geom_funfill(fun = dfun(dist), from = 1, to = 5)

# Version avec {distributional}
cdf(dist, 5)

# Version R de base
punif(5, min = 1, max = 8, lower.tail = TRUE) # Attention lower.tail


# Distribution Normale 180, 35 : quantile pour 80% aire à gauche ----------

dist <- dist_normal(mean = 180, sd = 35)
chart(dist)

# Version avec {distributional}
quantile(dist, 0.8)

# Version R de base
qnorm(0.8, 180, 35)

chart(dist) +
  geom_funfill(fun = dfun(dist), from = 0, to = quantile(dist, 0.8)) +
  geom_vline(xintercept = quantile(dist, 0.8), color = "red")

# Distribution Normale 180, 35 : probabilité entre 150 et 190 -------------

chart(dist) +
  geom_funfill(fun = dfun(dist), from = 150, to = 190)

# Version avec {distributional}
cdf(dist, 190) - cdf(dist, 150)

# Version R de base
pnorm(190, 180, 35) - pnorm(150, 180, 35)
