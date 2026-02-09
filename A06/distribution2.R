# SDD I module 6
# Copyright (c) 2026, Philippe Grosjean & Guyliann Engels
# Exploration des distribution

SciViews::R("infer", lang = "fr")

N <- dist_normal(mean = 50, sd = 10)
N

chart(N)

# Avec annotations
chart(N) +
  geom_funfill(fun = dfun(N), from = 50, to = 80) +
  annotate("text", x = 55, y = 0.015, label = "P x > 50", col = "red")

# 1) Probabilité que x > 50 (ou x >= 50 ?)
# objet distribution
1 - cdf(N, 50) # aire à droite

# avec R de base
pnorm(50, mean = 50, sd = 10, lower.tail = FALSE)


# 2) Probabilité que x > 80 ?
1 - cdf(N, 80) # aire à droite
pnorm(80, mean = 50, sd = 10, lower.tail = FALSE)

# 3) Probabilité que x < 80 ?
cdf(N, 80) # aire à gauche
pnorm(80, mean = 50, sd = 10, lower.tail = TRUE)

# 4) Quantile qui définit une aire à droite de 30% ?
quantile(N, 1 - 0.3)
qnorm(0.3, mean = 50, sd = 10, lower.tail = FALSE)

# 5) Aire centrale entre deux quantiles : 25, 55)
cdf(N, 55) - cdf(N, 25)
pnorm(55, mean = 50, sd = 10, lower.tail = TRUE) -
  pnorm(25, mean = 50, sd = 10, lower.tail = TRUE)

# Génération de nombres aléatoires U(2, 10)
U <- dist_uniform(2, 10)
U
chart(U)

set.seed(835)
generate(U, 10)
runif(10, min = 2, max = 10)

# Moyenne et écart type d'un échantillon généré selon une distribution connue
x1 <- generate(N, 10000)[[1]]
mean(x1)
sd(x1)
