data(iris)
head(iris)

library(dplyr)
iris %>% group_by(Species) %>%
  summarise(mean = mean(Petal.Length), sd = sd(Petal.Length), count = sum(!is.na(Petal.Length)))

boxplot(Petal.Length ~ Species, data = iris, col = "cornsilk",
  method = "stack", xlab = "Species", ylab = "Petal.Length")
stripchart(Petal.Length ~ Species, data = iris, vertical = TRUE,
  method = "stack", xlab = "Species", ylab = "Petal.Length")

anova(anova. <- lm(Petal.Length ~ Species, data = iris))

# Test des conditions d'application
plot(anova., which = 2)
bartlett.test(Petal.Length ~ Species, data = iris)
# Pas bon!

# Transformation log
iris %>% mutate(logPL = log10(Petal.Length)) -> iris

# Graphe
stripchart(logPL ~ Species, data = iris, vertical = TRUE,
  method = "stack", xlab = "Species", ylab = "Petal.Length")
boxplot(logPL ~ Species, data = iris, vertical = TRUE,
  method = "stack", xlab = "Species", ylab = "Petal.Length")
bartlett.test(logPL ~ Species, data = iris)

# Anova
anova(anova. <- lm(logPL ~ Species, data = iris))
# OK

plot(anova., which = 2)

# Normalité des résidus
library("ggplot2")
#plot(anova., which = 2)
anova. %>% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

# Comparaisons multiples
summary(anovaComp. <- confint(multcomp::glht(anova.,
  linfct = multcomp::mcp(Species = "Tukey")))) # Add a second factor if you want
.oma <- par(oma = c(0, 5.1, 0, 0)); plot(anovaComp.); par(.oma); rm(.oma)



## Anova deux facteurs sans replicas
#(Ble <- read.csv("~/Documents/Data/Ble.csv")
library(tidyverse)
(Ble <- tribble(~Ferme, ~Variete, ~Rendement,
"X", "A", 0.327,
"X", "B", 0.500,
"X", "C", 0.442,
"X", "D", 0.471,
"Y", "A", 0.532,
"Y", "B", 0.599,
"Y", "C", 0.516,
"Y", "D", 0.638,
"Z", "A", 0.269,
"Z", "B", 0.308,
"Z", "C", 0.241,
"Z", "D", 0.305))
Ble$Ferme <- as.factor(Ble$Ferme)
Ble$Variete <- as.factor(Ble$Variete)

# Description des données
SciViews::R
Ble %>.%
  group_by(., Ferme, Variete) %>.%
  summarise(., mean = mean(Rendement), sd = sd(Rendement), count = sum(!is.na(Rendement)))

stripchart(Rendement ~ Ferme, data = Ble, vertical = TRUE,
  method = "stack", xlab = "Ferme", ylab = "Rendement")
stripchart(Rendement ~ Variete, data = Ble, vertical = TRUE,
  method = "stack", xlab = "Variete", ylab = "Rendement")
boxplot(Rendement ~ Ferme, data = Ble, col = 8,
  xlab = "Ferme", ylab = "Rendement")
boxplot(Rendement ~ Variete, data = Ble, col = 8,
  xlab = "Variete", ylab = "Rendement")

anova(anova. <- lm(Rendement ~ Ferme + Variete, data = Ble))

summary(anovaComp. <- confint(multcomp::glht(anova.,
  linfct = multcomp::mcp(Ferme = "Tukey")))) # Add a second factor if you want
.oma <- par(oma = c(0, 5.1, 0, 0)); plot(anovaComp.); par(.oma); rm(.oma)

summary(anovaComp. <- confint(multcomp::glht(anova.,
  linfct = multcomp::mcp(Variete = "Tukey")))) # Add a second factor if you want
.oma <- par(oma = c(0, 5.1, 0, 0)); plot(anovaComp.); par(.oma); rm(.oma)


## Test modèle complet sur données sans réplicas
anova(anova. <- lm(Rendement ~ Ferme * Variete, data = Ble))


## Anova deux facteurs avec replicas
#(Ble2 <- read.csv("~/Documents/Data/Ble2.csv")
(Ble2 <- tribble(~Ferme, ~Variete, ~Rendement,
  "X", "A", 0.327,
  "X", "A", 0.289,
  "X", "B", 0.500,
  "X", "B", 0.510,
  "X", "C", 0.442,
  "X", "C", 0.463,
  "X", "D", 0.471,
  "X", "D", 0.460,
  "Y", "A", 0.532,
  "Y", "A", 0.526,
  "Y", "B", 0.599,
  "Y", "B", 0.637,
  "Y", "C", 0.516,
  "Y", "C", 0.499,
  "Y", "D", 0.638,
  "Y", "D", 0.655,
  "Z", "A", 0.269,
  "Z", "A", 0.277,
  "Z", "B", 0.308,
  "Z", "B", 0.286,
  "Z", "C", 0.241,
  "Z", "C", 0.228,
  "Z", "D", 0.305,
  "Z", "D", 0.314))
Ble2$Ferme <- as.factor(Ble2$Ferme)
Ble2$Variete <- as.factor(Ble2$Variete)

Ble2 %>% group_by(Ferme, Variete) %>%
  summarise(mean = mean(Rendement), sd = sd(Rendement), count = sum(!is.na(Rendement)))

stripchart(Rendement ~ Variete, data = Ble2, vertical = TRUE,
  method = "stack", xlab = "Variete", ylab = "Rendement")
stripchart(Rendement ~ Ferme, data = Ble2, vertical = TRUE,
  method = "stack", xlab = "Ferme", ylab = "Rendement")
boxplot(Rendement ~ Variete, data = Ble2, col = "cornsilk",
  method = "stack", xlab = "Variete", ylab = "Rendement")
boxplot(Rendement ~ Ferme, data = Ble2, col = "cornsilk",
        method = "stack", xlab = "Ferme", ylab = "Rendement")

anova(anova. <- lm(Rendement ~ Ferme * Variete, data = Ble2))

plot(anova., which = 2)
bartlett.test(Rendement ~ Ferme, data = Ble2)
bartlett.test(Rendement ~ Variete, data = Ble2)

summary(anovaComp. <- confint(multcomp::glht(anova.,
  linfct = multcomp::mcp(Ferme = "Tukey", Variete = "Tukey")))) # Add a second factor if you want
.oma <- par(oma = c(0, 5.1, 0, 0)); plot(anovaComp.); par(.oma); rm(.oma)


## Anova à deux facteur hiérarchisés
#(Eaux <- read.csv("~/Documents/Data/Eaux.csv")
(Eaux <- tribble(~Eau, ~Etudiant, ~Bacterio,
  "Egout", "A", 2700,
  "Egout", "A", 2800,
  "Egout", "A", 1700,
  "Egout", "B", 2600,
  "Egout", "B", 3000,
  "Egout", "B", 3200,
  "Polluee", "C", 52,
  "Polluee", "C", 49,
  "Polluee", "C", 61,
  "Polluee", "D", 68,
  "Polluee", "D", 75,
  "Polluee", "D", 83,
  "Propre", "E", 5.9,
  "Propre", "E", 7.6,
  "Propre", "E", 16,
  "Propre", "F", 5.6,
  "Propre", "F", 5.9,
  "Propre", "F", 6.3))
Eaux$Eau <- as.factor(Eaux$Eau)
Eaux$Etudiant <- as.factor(Eaux$Etudiant)

# Graphique
coplot(Bacterio ~ Etudiant | Eau, data = Eaux, panel = panel.smooth)
chart(data = Eaux, Bacterio ~ Etudiant | Eau) +
  geom_point()

Eaux %>% group_by(Etudiant, Eau) %>%
  summarise(mean = mean(Bacterio), sd = sd(Bacterio), count = sum(!is.na(Bacterio)))

# Besoin d'une échelle logarithmique
coplot(log10(Bacterio) ~ Etudiant | Eau, data = Eaux, panel = panel.smooth)
chart(data = Eaux, log10(Bacterio) ~ Etudiant | Eau) +
  geom_point()


Eaux %>% group_by(Etudiant, Eau) %>%
  summarise(mean = mean(log10(Bacterio)), sd = sd(log10(Bacterio)), count = sum(!is.na(log10(Bacterio))))

anova(anova. <- lm(log10(Bacterio) ~ Eau + Etudiant %in% Eau, data = Eaux))

plot(anova., which = 2)
bartlett.test(log10(Bacterio) ~ Eau, data = Eaux)


## Traitement ToothGrowth avec aov()
#data(ToothGrowth)
#TG.aov <- aov(len ~ dose * supp, data = ToothGrowth)
#anova(TG.aov)
#par(mfrow = c(2,2))
#plot(TG.aov)
#par(mfrow = c(1,1))
#coplot(len ~ dose | supp, data = ToothGrowth, panel = panel.smooth)
