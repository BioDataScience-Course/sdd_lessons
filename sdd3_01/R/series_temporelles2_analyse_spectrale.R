# Analogie avec la régression polynomiale
data(trees)
trees
library("dplyr")
library("cowplot")
summary(lm. <- lm(Volume ~  Girth + I(Girth^2) + I(Girth^3) + I(Girth^4) + I(Girth^5), data = trees))
lm. %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
  geom_point() + stat_smooth(method = "lm", formula = y ~ x + I(x^2)+ I(x^3)+ I(x^4)+ I(x^5)))

# Ici, aucun terme n'est significatif au delà du degré 2 car pas assez de données => choisir un autre jeu de données!

# Faire la même chose avec une régression harmonique, voir: http://rstudio-pubs-static.s3.amazonaws.com/9428_1197bd003ebd43c49b429f22ea4f36e5.html

# De là, dériver le périodogramme et ensuite voir le lissage
# Ne pas oublier d'indiquer que la série doit être stationnaire + définir stationnarité!
#
