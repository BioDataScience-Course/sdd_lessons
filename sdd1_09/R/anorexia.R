SciViews::R
anorexia <- read("anorexia", package = "MASS")
anorexia
# Changement de poids avant - après pour les sujets "contrôle" ?
anorexia %>.%
  subset(., Treat == "Cont") -> anoCont
boxplot(anoCont$Prewt, anoCont$Postwt)

# Calcul de delta_wt
anoCont %>.%
  mutate(., delta_wt = Postwt - Prewt) -> anoCont

(mean_delta_wt <- mean(anoCont$delta_wt))
(sd_delta_wt <- sd(anoCont$delta_wt))
# Ecart type distribution de student (attention: diviser par racine carré de n!)
(sd_delta_wt / sqrt(26))
# nombre d'observations
n <- 26

# Test de Student (version univarié)
t.test(anoCont$delta_wt,
  alternative = "two.sided", mu = 0, conf.level = 0.95)
# Version appariée
t.test(anoCont$Postwt, anoCont$Prewt,
  alternative = "two.sided", conf.level = 0.95, paired = TRUE)

# La valeur t est la moyenne observée divisée par l'écart type
# de la distribution de Student
(mean_delta_wt / (sd_delta_wt / sqrt(n)))

# Calcul de la valeur p à la main (la distribution de référence est la Student t réduite)
.mu <- 0; .s <- 1; pt((-0.28723 - .mu)/.s, df = n - 1, lower.tail = TRUE) * 2

