library(MASS)	# Package contenant la fonction
data(caith)
caith	# Tableau de contingence exemple
sum(caith)
(.chi2 <- chisq.test(caith)); cat("Expected frequencies:\n"); .chi2$expected
## Calcul des composantes du Chi2
Ai <- caith
Alphai <- .chi2$expected
(Ai - Alphai)^2 / Alphai

## AFC
plot(corresp(caith, nf = 2))


## Autre exemple
require(pastecs)
data(marbio)
marbio
plot(corresp(marbio, nf = 2))
