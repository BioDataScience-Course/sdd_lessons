# Séries spatio-temporelles (seconde partie)

# Note: trend.test() in pastecs does not work well with current version of R
# with the SciViews::R extension. This version corrects the problem
trend.test <- function(tseries, R = 1) {
  Call <- deparse(substitute(tseries))
  x <- as.ts(tseries)
  Names <- colnames(x)
  if (R < 2) {
    if (is.matrix(x) == TRUE) {
      n <- ncol(x)
      Time <- time(x)
      res <- NULL
      res[[1]] <- list(statistics = 1)
      for (i in 1:n) {
        res[[i]] <- cor.test(x[, i], Time, alternative = "two.sided",
          method = "spearman")
        res[[i]]$data.name <- paste(Names[i], " and time(",
          Names[i], ")", sep = "")
      }
      names(res) <- Names
    } else {
      res <- cor.test(x, time(x), alternative = "two.sided",
        method = "spearman")
      res$data.name <- paste(Call, " and time(", Call,
        ")", sep = "")
    }
  } else {
    test.trend <- function(Tseries) {
      Tseries <- as.ts(Tseries)
      rho <- cor(Tseries, time(Tseries), method = "spearman")
      rho
    }
    test.trends <- function(Tseries) {
      Tseries <- as.ts(Tseries)
      data.rank <- apply(Tseries, 2, rank)
      rhos <- apply(data.rank, 2, cor, time(Tseries), method = "spearman")
      rhos
    }
    if (is.matrix(x) == TRUE && ncol(x) > 1) {
      res <- tsboot(x, test.trends, R = R, sim = "fixed",
        l = 1)
    } else {
      dim(x) <- NULL
      res <- boot::tsboot(x, test.trend, R = R, sim = "fixed",
        l = 1)
    }
    boot.t <- res$t
    boot.t0 <- res$t0
    boot.R <- res$R
    n <- ncol(boot.t)
    if (is.null(n)) {
      if (boot.t0 > 0) {
        P <- (sum(boot.t > boot.t0)/boot.R) +
          (sum(boot.t < -boot.t0)/boot.R)
      } else {
        P <- (sum(boot.t < boot.t0)/boot.R) +
          (sum(boot.t > -boot.t0)/boot.R)
      }
    } else {
      P <- NULL
      if (boot.t0 > 0) {
        for (i in 1:n)
          P[i] <- (sum(boot.t[, i] > boot.t0[i])/boot.R) +
            (sum(boot.t[, i] < -boot.t0[i])/boot.R)
      } else {
        for (i in 1:n)
          P[i] <- (sum(boot.t[, i] < boot.t0[i])/boot.R) +
            (sum(boot.t[, i] > -boot.t0[i])/boot.R)
      }
      names(P) <- dimnames(boot.t)[[2]]
      res$p.value <- P
    }
  }
  res
}


# Repartons de notre exemple de série temporelle: température à Nottingham
data(nottem)
nottem
?nottem
plot(nottem)

# Des données différentes: CO2 dans l'air à Hawaï
data(co2)
co2
?co2
plot(co2)


## Identification de tendance à long terme
# Tendance générale / globale
library(pastecs)
# Test classique de signification du coefficient de Spearman (moins adapté pour les ts!)
trend.test(nottem) # Valeur p = 0.41 (valable uniquement si pas d'autocarrelation)
trend.test(co2)

# Même test, mais par bootstrap (mieux!) => R = 999, rééchantillonage 999x
nottem_trend_test <- trend.test(nottem, R = 999)
nottem_trend_test
# Visualisation graphique
plot(nottem_trend_test)
# Valeur p associée au test bootstrappé
nottem_trend_test$p.value # 0.20 -> pas de tendance significative au seuil alpha de 5%

co2_trend_test <- trend.test(co2, R = 999)
plot(co2_trend_test)
co2_trend_test$p.value

## Etude de la tendance locale
# Utilisation des sommes cumulées avec local.trend()
not.lt <- local.trend(nottem)
# le cycle annuel perturbe l'analyse pluriannuelle
# -> aggrégation des données par an
nottem2 <- aggregate(nottem, 1, mean)
nottem2
plot(nottem2)
# Graphe après aggrégation
not.lt2 <- local.trend(nottem2)
# La courbe en rouge (somme cumulées) amplifie les variations
# Choisir manuellement les points à identifier
# ATTENTION: identify() ne peut PAS être utilisée dans un R Markdown ou Notebook
# Cette fonction doit être utilisée seulement dans le fenêtre console de R!!!
identify(not.lt2) # Cliquer les points voulus, puis indiquer "finish"...

# Création d'une série artificielle
x2.random <- rnorm(100) # composante aléatoire = bruit
plot(x2.random, type = "l") # graphe de ces données
# Choix des moyennes
x2.means <- c(rep(5, 50), rep(6, 50))
plot(x2.means, type = "l")
# Signal observé = somme des 2 signaux
x2 <- (x2.means + x2.random)
plot(x2, type = "l")
# Transformation en objet 'ts'
x2.ts <- as.ts(x2)
plot(x2.ts)
# Recherche de tendances à l'aide des sommes cumulées
x2.lt <- local.trend(x2)
# Identifier les zones à la souris (RAPPEL: pas dans R Markdown!)
identify(x2.lt)


## Analyse spectrale
spectrum(nottem) # Cycle annuel
# Technique très puissante, mais signal brut bruité => lissage nécessaire!
# Lissage du spectre pour mieux voir
?spectrum
# L'argument 'spans' affectue ce lissage (voir cours)
# Il n'y a pas de règle stictes. Il faut juste deux nombres impairs
spectrum(nottem, spans = c(3, 7))
# Permet de mieux mettre en évidence les pics significatifs
