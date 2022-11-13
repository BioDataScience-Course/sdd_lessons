# Modèle linéaire
SciViews::R("model", lang = "fr")

# Contrastes
contr.treatment(4)
contr.sum(4)
contr.helmert(4)
contr.poly(4)
# Plus compréhensible lorsque représenté graphiquement
plot(contr.poly(10)[, 1], type = "b")
plot(contr.poly(10)[, 2], type = "b")
plot(contr.poly(10)[, 3], type = "b")
plot(contr.poly(10)[, 4], type = "b")
# etc...

# Constrastes définis par défaut
getOption("contrasts")

# ANCOVA, analyse de babies
babies <- read("babies", package = "UsingR")
knitr::kable(head(babies))

# Description et remaniement des données
babies %>.%
  select(., wt, wt1, smoke) %>.% # Garder seulement wt, wt1 & smoke
  filter(., wt1 < 999, wt < 999, smoke < 9) %>.% # Éliminer les valeurs manquantes
  mutate(., wt = wt * 0.02835) %>.% # Transformer le poids de livres en kg
  mutate(., wt1 = wt1 * 0.4536) %>.% # Idem de onces en kg
  mutate(., smoke = as.factor(smoke)) %->%
  Babies # Enregistrer le résultat dans Babies

knitr::kable(head(Babies))

skimr::skim(Babies)

chart(data = Babies, wt ~ wt1 %col=% smoke) +
  geom_point() +
  xlab("Masse de la mère [kg]") +
  ylab("Masse du bébé [kg]")

chart(data = Babies, wt ~ smoke) +
  geom_boxplot() +
  ylab("Masse du bébé [kg]")

chart(data = Babies, wt1 ~ smoke) +
  geom_boxplot() +
  ylab("Masse de la mère [kg]")

# Modèle 1
Babies_lm <- lm(data = Babies, wt ~ smoke * wt1)
summary(Babies_lm)
anova(Babies_lm)
equatiomatic::extract_eq(Babies_lm)


# Seulement smoke == 0
summary(lm(data = Babies, wt ~ wt1, subset = smoke == 0))
# Seulement smoke == 1
summary(lm(data = Babies, wt ~ wt1, subset = smoke == 1))

chart(data = Babies, wt ~ wt1 %col=% smoke) +
  geom_point() +
  stat_smooth(method = "lm", formula = y ~ x) +
  xlab("Masse de la mère [kg]") +
  ylab("Masse du bébé [kg]")

chart(data = Babies, wt ~ wt1 | smoke) +
  geom_point() +
  stat_smooth(method = "lm", formula = y ~ x) +
  xlab("Masse de la mère [kg]") +
  ylab("Masse du bébé [kg]")

# Modèle linéaire sans interactions
Babies_lm2 <- lm(data = Babies, wt ~ smoke + wt1)
summary(Babies_lm2)
anova(Babies_lm2)
equatiomatic::extract_eq(Babies_lm2)

# Graphique (il faut ruser)
offsets <- c(0, -0.238, 0.0227, 0.0355)
cols <- scales::hue_pal()(4)
chart(data = Babies, wt ~ wt1) +
  geom_point(aes(col = smoke)) +
  purrr::map2(offsets, cols, function(offset, col)
    geom_smooth(method = lm, formula = y + offset ~ x, col = col)) +
  xlab("Masse de la mère [kg]") +
  ylab("Masse du bébé [kg]")

# Comparaisons multiples
summary(anovaComp. <- confint(multcomp::glht(Babies_lm2,
  linfct = multcomp::mcp(smoke = "Tukey"))))
.oma <- par(oma = c(0, 5.1, 0, 0)); plot(anovaComp.); par(.oma); rm(.oma)

# Réencodage de smoke
Babies %>.%
  mutate(., smoke = recode(smoke, "0" = "0", "1" = "3", "2" = "2", "3" = "1")) %>.%
  mutate(., smoke = factor(smoke, levels = c("0", "1", "2", "3"))) %->%
  Babies2

# Nouveau modèle
Babies_lm3 <- lm(data = Babies2, wt ~ smoke + wt1,
  contrasts = list(smoke = "contr.helmert"))
summary(Babies_lm3)
anova(Babies_lm3)
equatiomatic::extract_eq(Babies_lm3)

# Les contrastes utilisés:
contr.helmert(4)

# Modèle avec smoke réencodé
summary(lm(data = Babies2, wt ~ smoke + wt1))

# Modèle avec smoke comme variable ordonnée
Babies3 <- fmutate(Babies2, smoke = as.ordered(smoke))
summary(lm(data = Babies3, wt ~ smoke + wt1))

# Encodage encore plus simple de smoke (2 niveaux seulement)
Babies %>.%
  mutate(., smoke_preg = recode(smoke, "0" = "0", "1" = "1", "2" = "0", "3" = "0")) %>.%
  mutate(., smoke_preg = factor(smoke_preg, levels = c("0", "1"))) %->%
  Babies
Babies_lm4 <- lm(data = Babies, wt ~ smoke_preg + wt1)
summary(Babies_lm4)
anova(Babies_lm4)
equatiomatic::extract_eq(Babies_lm4)

# Graphique du modèle
offsets <- c(0, -0.246)
cols <- scales::hue_pal()(2)
chart(data = Babies, wt ~ wt1) +
  geom_point(aes(col = smoke_preg)) +
  purrr::map2(offsets, cols, function(offset, col)
    geom_smooth(method = lm, formula = y + offset ~ x, col = col)) +
  xlab("Masse de la mère [kg]") +
  ylab("Masse du bébé [kg]")

# Analyse des résidus
chart$resfitted(Babies_lm4)
chart$qqplot(Babies_lm4)
chart$scalelocation(Babies_lm4)
chart$cooksd(Babies_lm4)


# Schémas des 3 types de modèles
# Y ~ X + F
dtx(X = c(0, 3, 0, 3), Y = c(2, 5, 3, 6), F = c("A", "A", "B", "B")) %>.%
  chart(data = ., Y ~ X %col=% F) +
  geom_line()

# Y ~ X + X:F
dtx(X = c(0, 3, 0, 3), Y = c(2, 5, 2, 6), F = c("A", "A", "B", "B")) %>.%
  chart(data = ., Y ~ X %col=% F) +
  geom_line()

# Y ~ X + F + X:F, identique à Y ~ X * F
dtx(X = c(0, 3, 0, 3), Y = c(2, 6, 3, 5), F = c("A", "A", "B", "B")) %>.%
  chart(data = ., Y ~ X %col=% F) +
  geom_line()

