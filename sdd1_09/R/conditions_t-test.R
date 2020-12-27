# Très grand nombre d'observations (2000 par population) et variances très
# différentes (4 versus 25 => sd = 2 versus 5, respectivement)
x <- rnorm(2000, mean = 20, sd = 2)
y <- rnorm(2000, mean = 40, sd = 5)
# Résidus poolés
res <- c(x - mean(x), y - mean(y))
hist(res) # Unimodal et symétrique
qqnorm(res); qqline(res)
# ou
library(car)
qqPlot(res)
# Test de Shapiro-Wilk
shapiro.test(res) # Rejet de la distribution normale
# Test d'homoscédasticité sur les données initiales
dat <- data.frame(z <- c(x, y), group = rep(c("A", "B"), each = 2000))
bartlett.test(z ~ group, data = dat) # Rejet d'homogénéité des variances

# Test séparé des deux distributions (ici pas de problèmes de nombre d'obs.)!
shapiro.test(x) # OK
shapiro.test(y) # OK

# Test des résidus standardisés et poolés
stdres <- c((x - mean(x)) / sd(x), (y - mean(y)) / sd(y))
qqPlot(stdres) # OK
shapiro.test(stdres) # OK
# On en conclu que l'on peut utiliser la variante de Welch du t-test puisque
# les résidus standardisés sont normaux, mais les variances ne sont pas homogènes

#### Maintenant que se passe-t-il avec un petit nombre d'observations (10 / pop.)?
set.seed(5745)
x <- rnorm(10, mean = 20, sd = 2)
y <- rnorm(10, mean = 40, sd = 5)
# Résidus poolés
res <- c(x - mean(x), y - mean(y))
hist(res) # Difficile à interpréter!
qqPlot(res) # Ne semble pas différent d'une distri normale
shapiro.test(res) # Non rejet du test!
dat <- data.frame(z <- c(x, y), group = rep(c("A", "B"), each = 10))
bartlett.test(z ~ group, data = dat) # Rejet d'homogénéité des variances

# Test séparé des deux distributions (ici pas de problèmes de nombre d'obs.)!
shapiro.test(x) # OK
shapiro.test(y) # OK

# Test des résidus standardisés et poolés
stdres <- c((x - mean(x)) / sd(x), (y - mean(y)) / sd(y))
qqPlot(stdres) # OK
shapiro.test(stdres) # OK

# Donc, avec un petit nombre d'observations, on ne voit pas de différences entre
# les tests sur distributions des résidus et distribution des résidus standardisés
# avec variances très inégales pourtant. Cela illustre bien la limite de ces tests
# qu'il faut donc interpréter avec prudence et esprit critique => argument contre
# un travail automatisé comme dans rquery.t.test().


