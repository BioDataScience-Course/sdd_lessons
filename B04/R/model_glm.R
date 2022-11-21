# GLM

SciViews::R("model")

# Babies premat
# Prepa
babies <- read("babies", package = "UsingR")
babies %>.%
  select(., gestation, smoke, wt1, ht, race, age) %>.%
  # Éliminer les valeurs manquantes
  filter(., gestation < 999, smoke < 9, wt1 < 999, ht < 999, race < 99, age < 99) %>.%
  # Transformer wt1 en kg et ht en cm
  mutate(., wt1 = wt1 * 0.4536) %>.%
  mutate(., ht = ht / 39.37) %>.%
  # Transformer smoke en variable facteur
  mutate(., smoke = as.factor(smoke)) %>.%
  # Idem pour race
  mutate(., race = as.factor(race)) %>.%
  # Déterminer si un bébé est prématuré ou non (en variable facteur)
  mutate(., premat = as.factor(as.numeric(gestation < 7 * 37))) %>.%
  # Calculer le BMI comme meilleur index d'embonpoint des mères que leur masse
  mutate(., bmi = wt1 / ht^2) %->% # Collecter les résultats avec %->%
  babies_prem

# Description
table(babies_prem$premat)

babies_table <- table(babies_prem$premat, babies_prem$smoke)
knitr::kable(addmargins(babies_table))

chart(data = babies_prem, ~smoke %fill=% premat) +
  geom_bar(position = "fill") +
  labs(x = "Mère qui fume", y = "Effectif")

babies_table <- table(babies_prem$premat, babies_prem$race)
knitr::kable(addmargins(babies_table))

chart(data = babies_prem, ~race %fill=% premat) +
  geom_bar(position = "fill") +
  labs(x = "Ethnie de la mère", y = "Effectif")

chart(data = babies_prem, bmi ~ premat) +
  geom_boxplot() +
  labs(x = "Prématuré", y = "IMC de la mère")

chart(data = babies_prem, age ~ premat) +
  geom_boxplot() +
  labs(x = "Enfant prématuré", y = "Âge de la mère (an)")

# Modèle glm
# Modèle linéaire généralisé avec fonction de lien de type logit
babies_glm <- glm(data = babies_prem, premat ~ smoke + race + bmi + age,
  family = binomial(link = logit))
summary(babies_glm)


# GGLM
# Données
spe <- dtbl_rows(
  ~donor, ~conc, ~mobile, ~total,
  1,   0.0,     236,    301,
  1,   0.1,     238,    301,
  1,   0.5,     115,    154,
  1,   1.0,     105,    196,
  1,   2.0,     182,    269,
  2,   0.0,      92,    150,
  2,   0.1,      60,    111,
  2,   0.5,      63,    131,
  2,   1.0,      46,     95,
  2,   2.0,      50,    125,
  3,   0.0,     100,    123,
  3,   0.1,      91,    117,
  3,   0.5,     132,    162,
  3,   1.0,     145,    187,
  3,   2.0,      52,     92,
  4,   0.0,      83,    113,
  4,   0.1,     104,    123,
  4,   0.5,      65,     87,
  4,   1.0,      93,    136,
  4,   2.0,      78,    117,
  5,   0.0,     127,    152,
  5,   0.1,      82,    114,
  5,   0.5,      55,     84,
  5,   1.0,      80,    103,
  5,   2.0,      98,    120,
  6,   0.0,      62,     77,
  6,   0.1,      65,     79,
  6,   0.5,      63,     72,
  6,   1.0,      57,     67,
  6,   2.0,      39,     66,
  7,   0.0,      91,    116,
  7,   0.1,      51,     71,
  7,   0.5,      70,     87,
  7,   1.0,      53,     72,
  7,   2.0,      59,     82,
  8,   0.0,     121,    137,
  8,   0.1,      80,     98,
  8,   0.5,     100,    122,
  8,   1.0,     126,    157,
  8,   2.0,      98,    122
)

spe <- smutate(spe, mob_frac = mobile / total, donor = as.factor(donor), conc = as.numeric(conc))
head(spe)

# Modèle complet
spe_m1 <- lme4::glmer(data = spe, cbind(mobile, total - mobile) ~ conc + (conc | donor),
  family = binomial(link = "logit"))
summary(spe_m1)

chart(data = spe, mob_frac ~ conc %col=% donor) +
  geom_point() +
  geom_line(f_aes(fitted(spe_m1) ~ conc %col=% donor)) +
  labs(x = "Ethanol [%]", y = "Mobilité des spermatozoïdes [%]")

# Simplification du modèle
spe_m2 <- lme4::glmer(data = spe, cbind(mobile, total - mobile) ~ conc + (1 | donor),
  family = binomial(link = "logit"))
anova(spe_m1, spe_m2)

summary(spe_m2)

chart(data = spe, mob_frac ~ conc %col=% donor) +
  geom_point() +
  geom_line(f_aes(fitted(spe_m2) ~ conc %col=% donor)) +
  labs(x = "Ethanol [%]", y = "Mobilité des spermatozoïdes [%]")

# Intervalles de confiance
confint(spe_m2)
confint(spe_m2, level = 0.95, method = "boot", nsim = 500)


# Difficultés d'ajustement
lme4::isSingular(spe_m2)
lme4::allFit(spe_m2)

# Analyse des résidus
chart(data = spe, resid(spe_m2, type = "pearson") ~ fitted(spe_m2) %col=% donor) +
  geom_point() +
  geom_hline(yintercept = 0) +
  labs(x = "Valeurs ajustées", y = "Résidus de Pearson")

chart(data = spe, sqrt(abs(resid(spe_m2, type = "pearson"))) ~ fitted(spe_m2) %col=% donor) +
  geom_point() +
  geom_hline(yintercept = 0) +
  labs(x = "Valeurs ajustées", y = "|Résidus de Pearson|^.5")

chart(data = spe, resid(spe_m2, type = "pearson") ~ conc %col=% donor) +
  geom_point() +
  geom_hline(yintercept = 0) +
  labs(x = " Ethanol [%]", y = "Résidus de Pearson")

chart(data = spe, aes(sample = resid(spe_m2, type = "pearson"))) +
  geom_qq() +
  geom_qq_line()


# Predictions
probit <- make.link("probit")
# Transforme quelques valeurs de Y (comprises entre 0 et 1, proportions)
y <- c(0.8, 0.85, 0.9, 0.95)
(y_probit <- probit$linkfun(y))
# Retransforme en y à l'aide de la fonction inverse
(y2 <- probit$linkinv(y_probit))
all.equal(y, y2)

# Graphique de probit
dtbl(y = seq(0, 1, by = 0.001)) %>.%
  smutate(., y_probit = probit$linkfun(y)) %>.%
  chart(., y_probit ~ y) +
  geom_line()

coef(spe_m2)

(spe_m2_fixef <- lme4::fixef(spe_m2))

lme4::ranef(spe_m2)

intercept <- spe_m2_fixef[1]
slope <- spe_m2_fixef[2]
conc <- c(0, 0.25, 0.5, 1, 2)
slope * conc + intercept

(mobi <- probit$linkinv(slope * conc + intercept))

# Diminution de mobilité avec 1% ethanol
mobi[1] - mobi[4]

