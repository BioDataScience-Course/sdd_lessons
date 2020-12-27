# Cours 7: modèle linéaire

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
#
# Constrastes définis par défaut
getOption("contrasts")

# Variables factor, ordered versus numeric
class(iris$Species)
class(iris$Petal.Length)
ff <- ordered(c("A", "B", "A", "A", "C"))
ff
class(ff)


# ANCOVA
data(babies, package = "UsingR")
View(babies)
# wt = masse du bébé à la naissance en onces (*0.02835 => kg) et 999 = valeur manquante
# wt1 = masse de la mère à la naissance en livres (*0.4536 => kg) et 999 = valeur manquante
# smoke = 0 (non), = 1 (oui), = 2 (jusqu'à grossesse), = 3 (plus depuis un certain temps) and = 9 (inconnu)
library("dplyr")
# Garder ces 3 variables et éliminer les valeurs manquantes
babies %>% select(wt, wt1, smoke) %>% dplyr::filter(wt1 < 999, wt < 999, smoke < 9) %>%
  # Transformer en kg
  mutate(wt = wt * 0.02835) %>% mutate(wt1 = wt1 * 0.4536) -> Babies
# Transformer smoke en variable factor
Babies$smoke <- as.factor(Babies$smoke)

# Descriptions numérique et graphiques
summary(Babies)
boxplot(wt ~ smoke, Babies)
boxplot(wt1 ~ smoke, Babies)

# Commençons par déterminer si la masse de la mère a un impact sur la masse du nouveau né
plot(Babies$wt1, Babies$wt)
cor(Babies$wt1, Babies$wt)
# Modélisation par régression linéaire simple
summary(regwt <- lm(wt ~ wt1, data = Babies))
abline(coef = coef(regwt), col = "black")
# Régression significative entre wt et wt1,
# mais pente et R^2 très faibles
summary(regwt0 <- lm(wt ~ wt1, data = Babies, subset = Babies$smoke == "0"))
abline(coef = coef(regwt0), col = "blue")
summary(regwt1 <- lm(wt ~ wt1, data = Babies, subset = Babies$smoke == "1"))
abline(coef = coef(regwt1), col = "red")
# La masse du nouveau né pour les mères qui fument semble plus petite, mais est-ce significatif?
summary(regwt2 <- lm(wt ~ wt1, data = Babies, subset = Babies$smoke == "2"))
#abline(coef = coef(regwt2), col = "orange")
# Régression non significative avec smoke == "2"!
summary(regwt3 <- lm(wt ~ wt1, data = Babies, subset = Babies$smoke == "3"))
#abline(coef = coef(regwt3), col = "blue")
# Régression non significative avec smoke == "3"!

# ANCOVA
anova(reg1 <- lm(wt ~ smoke * wt1, data = Babies))
summary(reg1)
# Sur données non tranformées, ceci n'est pas facile à interpréter!
# Garder seulement smoke = 0 et smoke = 1, et comparer les deux
Babies %>% dplyr::filter(smoke == "0" | smoke == "1") -> Babies2
Babies2$smoke <- as.factor(as.character(Babies2$smoke))
anova(reg2 <- lm(wt ~ smoke * wt1, data = Babies2))
summary(reg2)
# Différence non significative entre les 2 droites smoke == 0 vs smoke == 1

plot(reg2)


# Modèle linéaire généralisé
data(babies, package = "UsingR")
library("dplyr")
# Transformation, voir plus haut, et garder aussi la variable 'gestation' en jours
# et 'ht', la taille de la mère en pouces à convertir en m (/ 39.37)
babies %>% select(gestation, smoke, wt1, ht) %>%
  dplyr::filter(gestation < 999, smoke < 9, wt1 < 999, ht < 999) %>%
  # Transformer wt1 en kg et ht en cm
  mutate(wt1 = wt1 * 0.4536) %>% mutate(ht = ht / 39.37) -> Babies_prem
# Transformer smoke en variable factor
Babies_prem$smoke <- as.factor(Babies_prem$smoke)
# Déterminer quels sont les enfants prématurés (nés avant 37 semaines)
Babies_prem$premat <- as.factor(as.numeric(Babies_prem$gestation < 7*37))
table(Babies_prem$premat)
# BMI peut être plus parlant que la masse pour la mère?
Babies_prem %>% mutate(bmi = wt1 / ht^2) -> Babies_prem

# Description des données
summary(Babies_prem)
hist(Babies_prem$bmi)
boxplot(bmi ~ premat, Babies_prem)

# Modèle linéaire
lm(premat ~ smoke + bmi, data = Babies_prem)
# Ne fonctionne pas avec une variable réponse qualitative
class(Babies_prem$premat)
# Modèle linéaire généralisé avec fonction de lien de type logit
res <- glm(premat ~ smoke + bmi, family = binomial(link = logit), data = Babies_prem)
summary(res)
# Résultat différent si la variable est facteur ordonné
# Il faut réorganiser les niveaux du plus grave au moins grave => 0 devient 4
# 1 = oui, 2 = jusqu'à la grossesse, 3 = plus depuis un certain temps, 4 = non
Babies_prem$smokeB <- as.character(Babies_prem$smoke)
Babies_prem$smokeB[Babies_prem$smokeB == "0"] <- "4"
Babies_prem$smokeB <- as.ordered(Babies_prem$smokeB)
summary(Babies_prem)
res <- glm(premat ~ smokeB + bmi, family = binomial(link = logit), data = Babies_prem)
summary(res)

