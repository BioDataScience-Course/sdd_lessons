SciViews::R

# Jeu de données trees
# diametre du tronc à 1,2m de haut (en cm), hauteur (en m), volume de bois (en m^3)

trees <- read("trees", package = "datasets")

# On peut aussi encoder le tableau comme ceci
cerisiers <- tribble(~diametre, ~hauteur, ~volume,
  21.1, 21.3, 0.292,
  21.8, 19.8, 0.292,
  22.4, 19.2, 0.289,
  26.7, 21.9, 0.464,
  27.2, 24.7, 0.532,
  27.4, 25.3, 0.558,
  27.9, 20.1, 0.442,
  27.9, 22.9, 0.515,
  28.2, 24.4, 0.640,
  28.4, 22.9, 0.564,
  28.7, 24.1, 0.685,
  29.0, 23.2, 0.595,
  29.0, 23.2, 0.606,
  29.7, 21.0, 0.603,
  30.5, 22.9, 0.541,
  32.8, 22.6, 0.629,
  32.8, 25.9, 0.957,
  33.8, 26.2, 0.776,
  34.8, 21.6, 0.728,
  35.1, 19.5, 0.705,
  35.6, 23.8, 0.977,
  36.1, 24.4, 0.898,
  36.8, 22.6, 1.028,
  40.6, 21.9, 1.085,
  41.4, 23.5, 1.206,
  43.9, 24.7, 1.569,
  44.5, 25.0, 1.577,
  45.5, 24.4, 1.651,
  45.7, 24.4, 1.458,
  45.7, 24.4, 1.444,
  52.3, 26.5, 2.180)
#View(cerisiers)

# Revenons sur trees
# Description des données
summary(trees)
cor(trees, use = "complete.obs", method = "pearson")

# Représentation graphique
#GGally::ggscatmat(trees)
plot(trees)
corrplot::corrplot(cor(trees,
  use = "pairwise.complete.obs"), method = "ellipse")

# Regression linéaire simple du volume en fonction du diamètre
summary(lm.1 <- lm(data = trees, volume ~ diameter))
lm.1 %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
    geom_point() + stat_smooth(method = "lm", formula = y ~ x))

# ANOVA associée à la régression
anova(lm.1)


# Régression multiple -----------------------------------------------------
summary(lm.2 <- lm(data = trees, volume ~ diameter + height))

# Représentation graphique: nécessite 3D, ne fonctionne pas à partir de R Studio Server!)
car::scatter3d(trees$diameter, trees$volume, trees$height, fit = "linear",
  residuals = TRUE, bg = "white", axis.scales = TRUE, grid = TRUE,
  ellipsoid = FALSE, xlab = "Diametre", ylab = "Volume", zlab = "Hauteur")

# Modèle plus complexe multiple et polynomial
summary(lm.3 <- lm(data = trees, volume ~ diameter + I(diameter^2)))
lm.3 %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
  geom_point() + stat_smooth(method = "lm", formula = y ~ x + I(x^2)))


# En utilisant les deux variables
lm.4 <- lm(data = trees, volume ~ diameter + I(diameter^2) + height + I(height^2))
summary(lm.4, correlation = FALSE, symbolic.car = FALSE)

# Attention: ne fonctionne pas dans R Studio Server!
car::scatter3d(trees$diameter, trees$volume, trees$height, fit = "quadratic",
  residuals = TRUE, bg = "white", axis.scales = TRUE, grid = TRUE,
  ellipsoid = FALSE, xlab = "Diametre", ylab = "Volume", zlab = "Hauteur")

# Simplification du modèle
trees_simple <- lm(data = trees, volume ~ I(diameter^2) + 0)
summary(trees_simple)

# Autre possibilité
trees %>% mutate(diameter2 = diameter^2) -> trees
summary(lm.5 <- lm(data = trees, volume ~ diameter2 + 0))
lm.5 %>% (function(lm, model = lm[["model"]], vars = names(model))
  ggplot(model, aes_string(x = vars[2], y = vars[1])) +
  geom_point() + stat_smooth(method = "lm", formula = y ~ x + 0))


# Graphe et analyse des résidus du modèle 4
#plot(lm.4, which = 1)
lm.4 %>% qplot(.fitted, .resid, data = .) +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab("Residuals") +
  ggtitle("Residuals vs Fitted")

#plot(lm.4, which = 2)
lm.4 %>% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

#plot(lm.4, which = 3)
lm.4 %>% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

#plot(lm.4, which = 5)
lm.4 %>.%
  chart(broom::augment(.), .std.resid ~ .hat %size=% .cooksd) +
  geom_point() +
  geom_smooth(se = FALSE, size = 0.5, method = "loess", formula = y ~ x) +
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  labs(x = "Leverage", y = "Standardized residuals") +
  ggtitle("Residuals vs Leverage")

#plot(lm.4, which = 6)
lm.4 %>.%
  chart(broom::augment(.), .cooksd ~ .hat %size=% .cooksd) +
  geom_point() +
  geom_vline(xintercept = 0, colour = NA) +
  geom_abline(slope = seq(0, 3, by = 0.5), colour = "darkgray") +
  geom_smooth(se = FALSE, size = 0.5, method = "loess", formula = y ~ x) +
  labs(x = expression("Leverage h"[ii]), y = "Cook's distance") +
  ggtitle(expression("Cook's dist vs Leverage h"[ii]/(1-h[ii])))


## Choix du modèle avec le critère d'Akaike
AIC(lm.1) # Linéaire simple avec Diamètre
AIC(lm.2) # Linéaire multiple diamètre et Hauteur
AIC(lm.3) # Polynômiale Diamètre
AIC(lm.4) # Polynômiale Diamètre et Hauteur
AIC(lm.5) # Modèle simplifié avec diamètre^2 seulement

AIC(lm.1, lm.2, lm.3, lm.4, lm.5)


# Analyse de yellowfin dans UsingR, en utilisant les fonctions de base de R
yellowfin <- read("yellowfin", package = "UsingR")
head(yellowfin)
summary(yellowfin)
chart(data = yellowfin, count ~ year) +
  geom_point()
plot(yellowfin$year, yellowfin$count)


# Régression linéaire simpleCPCOLS <- c("#1f78b4", "#A3A32D", "#e31a1c")

ggplot(iris, aes(Sepal.Length, Petal.Length)) +
      geom_point(aes(col = Species)) +
      scale_colour_manual(values = CPCOLS)convertr::convert(1:10,'1/H','1/H')
LinearModel.1 <- lm(data = yellowfin, count ~ year)
summary(LinearModel.1)
lines(yellowfin$year, predict(LinearModel.1))

# Polynome d'ordre 2
LinearModel.2 <- lm(data = yellowfin, count ~ year  +  I(year^2))
summary(LinearModel.2)
lines(yellowfin$year, predict(LinearModel.2), col = "red")

# Polynome d'ordre 3
LinearModel.3 <- lm(data = yellowfin, count ~ year  +  I(year^2) + I(year^3))
summary(LinearModel.3)
lines(yellowfin$year, predict(LinearModel.3), col = "blue")

legend(1985, 5, c("linéaire", "ordre 2", "ordre 3"), col = c("black", "red", "blue"), lwd = 1)
title("Régression polynomiale (yellowfin)")

# Analyse des résidus
par(mfrow = c(2, 2))
plot(LinearModel.1)
par(mfrow = c(1, 1))

par(mfrow = c(2, 2))
plot(LinearModel.2)
par(mfrow = c(1, 1))

par(mfrow = c(2, 2))
plot(LinearModel.3)
par(mfrow = c(1, 1))

AIC(LinearModel.1, LinearModel.2, LinearModel.3)
