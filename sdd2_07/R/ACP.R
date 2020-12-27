# ACP avec SciViews::R

# Code --------------------------------------------------------------------

SciViews::R()
library(broom)

# broom implements only methods for prcomp objects, not princomp, while pcomp
# is compatible with princomp... but prcomp is simpler. So, conversion is easy
as.prcomp <- function(x, ...)
  UseMethod("as.prcomp")

as.prcomp.default <- function(x, ...)
  stop("No method to convert this object into a 'prcomp'")

as.prcomp.prcomp <- function(x, ...)
  x

as.prcomp.princomp <- function(x, ...)
  structure(list(sdev = as.numeric(x$sdev), rotation = unclass(x$loadings),
    center = x$center, scale = x$scale, x = as.matrix(x$scores)),
    class = "prcomp")

# Comparison of pcomp() -> as.prcomp() with prcomp() directly
# Almost the same, only no rownames for x (is it important?)
#iris_prcomp_pcomp <- as.prcomp(pcomp(iris[, -5], scale = TRUE))
#iris_prcomp <- prcomp(iris[, -5], scale = TRUE)

# Now, broom methods can be defined simply by converting into prcomp objects
augment.princomp <- function(x, data = NULL, newdata, ...)
  if (missing(newdata)) {
    augment(as.prcomp(x), data = data, ...)
  } else {
    augment(as.prcomp(x), data = data, newdata = newdata, ...)
  }

tidy.princomp <- function(x, matrix = "u", ...)
  tidy(as.prcomp(x), matrix = matrix, ...)

# There is no glance.prcomp() method

# There is a problem with pcomp() that returns a data.frame in scores,
# while it is a matrix in the original princomp object. pca() corrects this
pca <- function(x, ...) {
  res <- SciViews::pcomp(x, ...)
  # Change scores into a matrix
  res$scores <- as.matrix(res$scores)
  res
}

scale_axes <- function(data, aspect.ratio = 1) {
  range_x <- range(data[, 1])
  span_x <- abs(max(range_x) - min(range_x))
  range_y <- range(data[, 2])
  span_y <- abs(max(range_y) - min(range_y))
  if ((span_y / aspect.ratio) > span_x) {
    # Adjust range_x
    span_x_2 <- span_y / aspect.ratio / 2
    range_x_mid <- sum(range_x) / 2
    range_x <- c(range_x_mid - span_x_2, range_x_mid + span_x_2)
  } else {
    # Adjust range_y
    span_y_2 <- span_x * aspect.ratio / 2
    range_y_mid <- sum(range_y) / 2
    range_y <- c(range_y_mid - span_y_2, range_y_mid + span_y_2)
  }
  list(x = range_x, y = range_y)
}

autoplot.pcomp <- function(object,
  type = c("screeplot", "altscreeplot", "loadings", "correlations", "scores", "biplot"),
  choices = 1L:2L, name = deparse(substitute(object)), ar.length = 0.1,
  circle.col = "gray", col = "black", fill = "gray", scale = 1, aspect.ratio = 1,
  repel = FALSE, labels, title, xlab, ylab, ...) {
  type = match.arg(type)

  if (missing(title))
    title <- paste(name, type, sep = " - ")

  contribs <- paste0(names(object$sdev), " (",
    round((object$sdev^2/object$totdev^2) * 100, digits = 1), "%)")[choices]

  scores <- as.data.frame(object$scores[, choices])
  names(scores) <- c("x", "y")
  if (!missing(labels)) {
    if (length(labels) != nrow(scores))
      stop("You must provide a character vector of length ", nrow(scores),
        " for 'labels'")
    scores$labels <- labels
  } else {# Default labels are row numbers
    scores$labels <- 1:nrow(scores)
  }

  lims <- scale_axes(scores, aspect.ratio = aspect.ratio)

  if (!missing(col)) {
    if (length(col) != nrow(scores))
      stop("You must provide a vector of length ", nrow(scores), " for 'col'")
    scores$color <- col
    scores_formula <- y ~ x %col=% color %label=% labels
  } else {
    if (missing(labels)) {
      scores_formula <- y ~ x %label=% labels
    } else {
      scores_formula <- y ~ x %col=% labels %label=% labels
    }
  }

  res <- switch(type,
    screeplot = object %>.% # Classical screeplot
      tidy(., "pcs") %>.%
      chart(data = ., std.dev^2 ~ PC) +
      geom_col(col = col, fill = fill) +
      labs(y = "Variances", title = title),

    altscreeplot = object %>.% # screeplot represented by dots and lines
      tidy(., "pcs") %>.%
      chart(data = ., std.dev^2 ~ PC) +
      geom_line(col = col) +
      geom_point(col = "white", fill = col, size = 2, shape = 21, stroke = 3) +
      labs(y = "Variances", title = title),

    loadings = object %>.% # Plots of the variables
      tidy(., "variables") %>.%
      spread(., key = PC, value = value) %>.%
      #rename_if(., is.numeric, function(x) paste0("PC", x)) %>.%
      select(., c(1, choices + 1)) %>.%
      set_names(., c("labels", "x", "y")) %>.%
      chart(data = ., y ~ x %xend=% 0 %yend=% 0 %label=% labels) +
      annotate("path", col = circle.col,
        x = cos(seq(0, 2*pi, length.out = 100)),
        y = sin(seq(0, 2*pi, length.out = 100))) +
      geom_hline(yintercept = 0, col = circle.col) +
      geom_vline(xintercept = 0, col = circle.col) +
      geom_segment(arrow = arrow(length = unit(ar.length, "inches"),
        ends = "first")) +
      ggrepel::geom_text_repel(hjust = "outward", vjust = "outward") +
      coord_fixed(ratio = 1) +
      labs(x = contribs[1], y = contribs[2], title = title),

    correlations = object %>.% # Correlations plot
      Correlation(.) %>.%
      as_tibble(., rownames = "labels") %>.%
      select(., c(1, choices + 1)) %>.%
      set_names(., c("labels", "x", "y")) %>.%
      chart(data = ., y ~ x %xend=% 0 %yend=% 0 %label=% labels) +
      annotate("path", col = circle.col,
        x = cos(seq(0, 2*pi, length.out = 100)),
        y = sin(seq(0, 2*pi, length.out = 100))) +
      geom_hline(yintercept = 0, col = circle.col) +
      geom_vline(xintercept = 0, col = circle.col) +
      geom_segment(arrow = arrow(length = unit(ar.length, "inches"),
        ends = "first")) +
      ggrepel::geom_text_repel(hjust = "outward", vjust = "outward") +
      coord_fixed(ratio = 1) +
      labs(x = contribs[1], y = contribs[2], title = title),

    scores = scores %>.% # Plot of the individuals
      chart(data = ., scores_formula) +
      geom_hline(yintercept = 0, col = circle.col) +
      geom_vline(xintercept = 0, col = circle.col) +
      coord_fixed(ratio = 1, xlim = lims$x, ylim = lims$y, expand = TRUE) +
      labs(x = contribs[1], y = contribs[2], title = title) +
      theme(legend.position = "none"),

    biplot = object %>.% # Biplot using ggfortify function
      as.prcomp(.) %>.%
      ggfortify:::autoplot.prcomp(., x = choices[1], y = choices[2],
        scale = scale, size = -1, label = TRUE, loadings = TRUE,
        loadings.label = TRUE) +
      geom_hline(yintercept = 0, col = circle.col) +
      geom_vline(xintercept = 0, col = circle.col) +
      theme_sciviews() +
      labs(x = contribs[1], y = contribs[2], title = title),

    stop("Unrecognized type, must be 'screeplot', 'altscreeplot', loadings', 'correlations', 'scores' or 'biplot'")
  )

  if (type == "scores") {
    if (isTRUE(repel)) {
      res <- res + geom_point() + ggrepel::geom_text_repel()
    } else {# Use text
      res <- res + geom_text()
    }
  }

  if (!missing(xlab))
    res <- res + xlab(xlab)
  if (!missing(ylab))
    res <- res + ylab(ylab)
  res
}

chart.pcomp <- function(data, choices = 1L:2L, name = deparse(substitute(data)),
  ..., type = NULL, env = parent.frame())
  autoplot.pcomp(data, choices = choices, name = name, ..., type = type, env = env)
class(chart.pcomp) <- c("function", "subsettable_type")


# Exemples ----------------------------------------------------------------

## Le jeu traditionnel iris
iris <- read("iris", package = "datasets", lang = "fr")
summary(iris)
skimr::skim(iris)
# Graphique descriptif initial
plot(correlation(iris[, -5]))
#
# Rappel: quelques graphiques utilisables en nuages de points 2D, 3D, et plus
# 2D
chart(data = iris, petal_length ~ petal_width %col=% species) +
  geom_point()
# 3D
rgl::plot3d(iris$petal_length, iris$petal_width, iris$sepal_length,
  col = as.integer(iris$species))
# ou
car::scatter3d(iris$petal_length, iris$petal_width, iris$sepal_length,
  surface = FALSE, point.col = as.integer(iris$species))
# Plus que 3D... matrice de nuages de points
GGally::ggscatmat(as.data.frame(iris), 1:4, color = "species")
# ... en version R de base
pairs(data = iris, ~ petal_length + petal_width + sepal_length + sepal_width,
  col = as.integer(iris$species))
# Un autre utilisant lattice cette fois-ci...
car::scatterplotMatrix(data = iris,
  ~ petal_length + petal_width + sepal_length + sepal_width | species,
  reg.line = lm, smooth = TRUE, span = 0.5, diagonal = 'density',
  by.groups = TRUE)

# ACP sans mise à l'échelle des variables (peut se concevoir car mêmes unités!)
iris_pca <- pca(data = iris,
  ~ petal_length + petal_width + sepal_length + sepal_width, scale = FALSE)
summary(iris_pca, loadings = FALSE, cutoff = 0.1)
#screeplot(iris_pca, type = "barplot", col = "cornsilk")
chart$scree(iris_pca, fill = "cornsilk")
# ou simplement chart(iris_pca) puisque c'est le graphique par défaut
# ou encore chart$screeplot() avec le nom complet
# Une autre version du graphique des éboulis
#screeplot(iris_pca, type = "lines")
chart$altscree(iris_pca)
# Les données correspondantes sont obtenues avec tidy(, "pcs")
tidy(iris_pca, "pcs")
#
# Graphique des variables (loadings en anglais)
# Déjà obtenus avec summary(, loadings = TRUE)
summary(iris_pca, loadings = TRUE, cutoff = 0)
# Graphique de l'espace des variables pour les 2 premiers axes
#plot(iris_pca, which = "load", choices = 1:2, col = "black", cex = 1, pos = 1)
chart$loadings(iris_pca, choices = c(1, 2))
# Les données correspondantes sont obtenues avec tidy(, "variables")
tidy(iris_pca, "variables") # ou "v", ou "rotation"
# Pour une version en format laerge, un peut de travail est nécessaire :
tidy(iris_pca, "variables") %>.%
  spread(., key = PC, value = value) %>.%
  rename_if(., is.numeric, function(x) paste0("PC", x))
#
# Graphique des individus (scores plot en anglais)
#plot(iris_pca, which = "scores", choices = c(1, 2), labels = NULL, cex = 1, main = "")
chart$scores(iris_pca, choices = c(1, 2))
# En couleurs et avec libellés personnalisés, c'est mieux!
#plot(iris_pca, which = "scores", choices = 1:2, labels = c("Se", "Vi", "Ve")[iris$species],
#  col = c("red", "blue", "green")[iris$species], cex = 0.9, main = "")
chart$scores(iris_pca, labels = c("Se", "Vi", "Ve")[iris$species])
# Lorsque le graphique est trop encombré, on peut utiliser repl = TRUE, mais
# c'est beaucoup plus lent!
chart$scores(iris_pca, labels = c("Se", "Vi", "Ve")[iris$species], repel = TRUE)
# Les données correspondantes sont obtenues avec augment()
augment(data = iris, iris_pca)
#
# Graphique des corrélations (pas utilisé et apparemment buggé!)
# (une corrélation est > 1 !)
#plot(iris_pca, which = "correlations")
chart$correlations(iris_pca)
# Les données correspondantes sont obtenues avec Correlation()
Correlation(iris_pca)
#
# Enfin, le biplot()
#biplot(iris_pca, choices = 1:2, scale = 1); abline(h = 0, col = "gray"); abline(v = 0, col = "gray")
# TODO: la mise à l'échelle n'est pas la même, mais je ne trouve pas le bins!
chart$biplot(iris_pca, scale = 1)


## Toujours iris, mais cette fois-ci avec standardisation des variables
# Au lieu de l'interface formule (plus explicite), on peut donner directement
# un tableau à condition qu'on ait éliminé les variables pas utiles avant
iris %>.%
  select(., -species) %>.%
  pca(., scale = TRUE) -> iris_pca2
summary(iris_pca2)
#
# Les "loadings" sont obtenus avec loadings() ou tidy(, "variables")
iris_pca2_loadings <- loadings(iris_pca2)
print(iris_pca2_loadings, sort = TRUE, cutoff = 0, digits = 3)
tidy(iris_pca2, "variables") # Au format long!

# scores() forunit la même info que augment(), mais en moins pratique
#iris_pca2_scores <- scores(iris_pca2, dim = 3, labels = NULL)
#iris_pca2_scores
augment(iris_pca2)
#
# Graphique des éboulis
#screeplot(iris_pca2, type = "barplot", col = "cornsilk", main = "")
chart$scree(iris_pca2, fill = "cornsilk", title = "")
#
# Graphique des variables
#plot(iris_pca2, which = "load", col = "black", cex = 1, pos = 1, main = "")
chart$loadings(iris_pca2, title = "")
#
# Graphique des individus
#plot(iris_pca2, which = "scores", choices = 1:2, labels = c("Se", "Vi", "Ve")[iris$species],
#  col = c("red", "blue", "green")[iris$species], cex = 0.9, main = "")
chart$scores(iris_pca2, labels = c("Se", "Vi", "Ve")[iris$species], title = "")


## Autre exemple: varechem... mais ne fonctionne pas très bien!
# Mesures du sol relatives aux 24 mêmes stations étudiées en varespec alias veg
# N = [mg/g], P, K, Ca, Mg, S, Al, Fe, Mn, Zn & Mo = [µg/g] en ces éléments
# pH, Baresoil est la surface ne % de sol nu et Humdepth est la hauteur de la
# couche d'humus [cm].
soil <- read("varechem", package = "vegan")
soil
skimr::skim(soil)
plot(correlation(soil[, -1]))
# ACP avec interface formule et standardisation (unités différentes)
soil_pca <- pca(data = soil,  ~ N + P + K + Ca + Mg + S + Al + Fe + Mn + Zn +
  Mo + Baresoil + Humdepth + pH, scale = TRUE)
summary(soil_pca)
#
# Graphe des éboulis
chart$scree(soil_pca)
# Les deux premiers axes ne capturent que 60% de la variance totale
#
# Graphe des variables
chart$loadings(soil_pca)
# Les normes des vecteurs sont toutes assez faibles, mauvaise représentativité
#
# Graphe des individus
chart$scores(soil_pca)
#
# ou encore le biplot
chart$biplot(soil_pca)


## Exemple intéressant avec Pima Indians Diabetes (version 2, corrigé)
# Il s'agit de données relatives aux indiens Pima qui ont un haut pourcentage
# de diabétiques : variable 'diabetes' qui indique si la personne est diabétique
# (pos) ou non (neg)
# Les huit autres variables sont des mesures quantitatives, mais 'pregnant'
# est quatitative discrète. Nous allons effectuer une ACP sur les sept autres
# Comme les variables sont mesurées dans des unités différentes, nous standardisons
# Il faut préalablement éliminer les lignes du tableau qui ont des valeurs manquantes
read("PimaIndiansDiabetes2", package = "mlbench") %>.%
  drop_na(.) -> pima
pima
skimr::skim(pima)
plot(correlation(pima[, 2:8]))
#
# ACP
pima_pca <- pca(data = pima, ~ glucose + pressure + triceps + insulin + mass +
  pedigree + age, scale = TRUE)
# Equivalent, mais moins explicite :
#pima %>.%
#  select(., glucose:age) %>.%
#  pca(., scale = TRUE) -> pima_pca
summary(pima_pca)
#
# Graphe des éboulis
chart$scree(pima_pca)
# Les deux premeirs axes ne reprennent que 53% de la variance totale
#
# Graphique des variables
chart$loadings(pima_pca)
# Autres axes
chart$loadings(pima_pca, choices = c(1, 3))
chart$loadings(pima_pca, choices = c(2, 3))
#
# Graphique des individus
chart$scores(pima_pca)
# Il est plus inxstructif d'indiquer sur le graphique qui est diabétique ou non
# et d'y ajouter des ellipses de confiance
chart$scores(pima_pca, labels = pima$diabetes, choices = c(1, 2)) +
  stat_ellipse()
# Les diabétiques sont plutôt vers la droite en bas, là où les variables
# glucose, insuline et age pointaient => plutôt âgés avec beaucoup de sucre et
# d'insuline dans le sang
# Par contre, la masse et l'épaisseur du pli de peau au niveau du triceps pointent
# à angle droit avec ces variables et ne sont donc pas corrélées. Les individus
# les plus gros sont en haut à droite du graphique. L'obésité est corrélée au
# diabète, mais dans une moindre mesure par rapport à age, glucose et insulin
# pressure et pedigree sont trop faiblement représentés dans le premier plan de l'ACP
#
# biplot
chart$biplot(pima_pca)


## Autre exemple : airquality
air <- drop_na(read("airquality", package = "datasets"))
air
skimr::skim(air)
plot(correlation(air[, 1:4]))
# ACP avec les 4 variables quantitatives standardisées puisque mesurées
# dans des unités différentes
air_pca <- pca(data = air, ~ Ozone + Solar.R + Wind + Temp, scale = TRUE)
# Equivalent, mais moins explicite :
#air %>.%
#  select(., Ozone:Temp) %>.%
#  pca(., scale = TRUE) -> air_pca
summary(air_pca)
chart$scree(air_pca)
# 81% sur les 2 premeirs axes
#
# Graphique des individus
chart$loadings(air_pca)
# PC1 est lié à ozone et température, PC2 aux radiations solaires, par ailleurs
# non corrélées avec les deux premiers. Le vent est plut^to inversément
# corrélé à la température et à l'ozone dans l'air
# Le vent est mieux représenté sur PC3
chart$loadings(air_pca, choices = c(1, 3))
#
# Graphique des individus
chart$scores(air_pca)
# Plus intéressant avec des lab nles ezt couleurs par mois
chart$scores(air_pca, labels = air$Month, choices = c(1, 2))
# Juillet et Aout ont un maximum de points à droite dans la zone température +
# ozone élevés. A l'inverse, mai est essentiellement représenté à la gauche
# sauf pour un point
#
# biplot
chart$biplot(air_pca)


## Le jeu de données 'Ozone' est plus complet que 'airquality'
# Similaire à airquality, mais avec plus de variables, mais nécessite de
# renommer les variables et de laisser tomber les lignes avec valeurs manquantes
read("Ozone", package = "mlbench") %>.%
  rename(., Mois = V1, Jour = V2, Jour_semaine = V3, Ozone = V4, Pression = V5,
    Vent = V6, Humidité = V7, Température1 = V8, Température2 = V9,
    Inversion_hauteur = V10, Gradient_pression = V11,
    Inversion_température = V12, Visibilité = V13) %>.%
  drop_na(.) -> ozone
ozone
skimr::skim(ozone)
plot(correlation(ozone[, 4:13]))
#
# ACP
ozone_pca <- pca(data = ozone, ~ Ozone + Pression + Vent + Humidité +
  Température1 + Température2 + Inversion_hauteur + Gradient_pression +
  Inversion_température + Visibilité, scale = TRUE)
# Equivalent, mais moins explicite:
summary(ozone_pca)
#
# Graphe des éboulis
chart$scree(ozone_pca)
# 72% de la variance totale sur les deux premeirs axes
#
# Graphique des variables
chart$loadings(ozone_pca)
# Ici aussi, températures et ozones pointent vers la droite
# Vent, gradient de pression et humidité pointent vers le haut
# Autres axes
chart$loadings(ozone_pca, choices = c(1, 3))
chart$loadings(ozone_pca, choices = c(1, 4))
#
# Graphique des individus
chart$scores(ozone_pca)
# Labels et coulers par mois
chart$scores(ozone_pca, labels = ozone$Mois, choices = c(1, 2))
# juin à octobre à droite, le reste à gauche
#
# biplot
chart$biplot(ozone_pca)


## Exercice de data.world sur l'ACP, voir https://data.world/exercises/principal-components-exercise-1
