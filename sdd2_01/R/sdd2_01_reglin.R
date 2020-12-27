SciViews::R

# Jeu de données trees
# diametre du tronc à 1,4m de haut (en cm), hauteur (en m), volume de bois (en m^3)

trees <- read("trees", package = "datasets", lang = "fr")

# Description des données
summary(trees)
cor(trees, use = "complete.obs", method = "pearson")

# Représentation graphique
GGally::ggscatmat(trees)
corrplot::corrplot(cor(trees,
  use = "pairwise.complete.obs"), method = "ellipse")

# Regression linéaire simple du volume en fonction du diamètre
summary(lm.1 <- lm(data = trees, volume ~ diameter))
lm.1 %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
    geom_point() + stat_smooth(method = "lm", formula = y ~ x))

# ANOVA associée à la régression
anova(lm.1)
