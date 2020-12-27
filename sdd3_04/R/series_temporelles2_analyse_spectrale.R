# Analogie avec la régression polynomiale
data(trees)
trees
library("dplyr")
library("ggplot2")
library("cowplot")
summary(lm. <- lm(Volume ~  Girth + I(Girth^2) + I(Girth^3) + I(Girth^4) + I(Girth^5), data = trees))
lm. %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
  geom_point() + stat_smooth(method = "lm", formula = y ~ x + I(x^2)+ I(x^3)+ I(x^4)+ I(x^5)))

# Ici, aucun terme n'est significatif au delà du degré 2 car pas assez de données
# => la quantité de données est cruciale dans une analyse spéctrale !

# La même chose avec une régression harmonique (ajuster des sinusoïdes au lieu
# d'ajuster des termes croissants d'un polynome), voir: http://go.sciviews.org/spectral

# A partir de là, le périodogramme représente les différents facteurs multiplicatifs
# pour les termes harmoniques. Un lissage de ce périodogramme aide à sa lecture
#
# Attention : la série doit être stationnaire (pas de tendance à long terme significative).
# Nous verrons plus loin comment on peut éliminer une tendnace éventuelle...
