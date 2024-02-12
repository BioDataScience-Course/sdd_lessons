# Exemples graphiques nuages de points
# Ph. Grosjean, 2022
SciViews::R(lang = "fr")

set.seed(36744)
df <- dtx(
  x = rnorm(5),
  medval = rnorm(5)
)

chart(data = df, medval ~ x) +
  geom_point() +
  xlab("Variable fictive X [unité]")

set.seed(35633)
df <- dtx(
  x = rnorm(30),
  y = x + rnorm(30, sd = 0.1)
)
df$y[10] <- 2.5

chart(data = df, y ~ x) +
  geom_point() +
  xlab("Variable fictive X [unité]") +
  ylab("Variable fictive Y [unité]")

set.seed(6456)
df <- dtx(
  x = c(rnorm(30, -2), rnorm(15, 4)),
  y = c(rnorm(30, -1), rnorm(15, 2.5)),
  sexe = sample(c("mâle", "femelle"), 45, replace = TRUE),
  type = c("B", rep("A", 32), rep("B", 12))
)

chart(data = df, y ~ x) +
  geom_point() +
  xlab("Variable fictive X [unité]") +
  ylab("Variable fictive Y [unité]")



chart(data = df, y ~ x %col=% sexe) +
  geom_point() +
  xlab("Variable fictive X [unité]") +
  ylab("Variable fictive Y [unité]")



chart(data = df, y ~ x %col=% type) +
  geom_point() +
  xlab("Variable fictive X [unité]") +
  ylab("Variable fictive Y [unité]")


set.seed(76454)
df <- dtx(
  x = rnorm(3000),
  y = x + rnorm(3000, 0.5)
)

chart(data = df, y ~ x) +
  geom_point() +
  xlab("Variable fictive X") +
  ylab("Variable fictive Y [unité]")

chart(data = df, y ~ x) +
  geom_point(alpha = 0.3) +
  xlab("Variable fictive X [unité]") +
  ylab("Variable fictive Y [unité]")

