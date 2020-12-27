# AFC avec SciViews::R

# Code --------------------------------------------------------------------

SciViews::R()
library(broom)

# Au lieu de MASS::corresp(, nf = 2), nous préférons ca::ca()
ca <- ca::ca

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

plot3d <- rgl::plot3d
plot3d.ca <- ca:::plot3d.ca

autoplot.ca <- function(object, choices = 1L:2L,
  type = c("screeplot", "altscreeplot", "biplot"), col = "black", fill = "gray",
  aspect.ratio = 1, repel = FALSE, ...) {
  type = match.arg(type)

  res <- switch(type,
    screeplot = object %>.% # Classical screeplot
      `[[`(., "sv") %>.%
      tibble(Dimension = 1:length(.), sv = .) %>.%
      chart(data = ., sv^2 ~ Dimension) +
      geom_col(col = col, fill = fill) +
      labs(y = "Inertia"),

    altscreeplot = object %>.% # screeplot represented by dots and lines
      `[[`(., "sv") %>.%
      tibble(Dimension = 1:length(.), sv = .) %>.%
      chart(data = ., sv^2 ~ Dimension) +
      geom_line(col = col) +
      geom_point(col = "white", fill = col, size = 2, shape = 21, stroke = 3) +
      labs(y = "Inertia"),

    biplot = {
      # We want to use the function plot.ca(), but without plotting the base plot
      # So, we place it in a specific environment where all base plot functions are
      # fake and do nothing (we just want to collect points coordinates at the end)
      env <- new.env()
      env$plot_ca <- ca:::plot.ca
      environment(env$plot_ca) <- env
      env$plot <- function(...) NULL
      env$box <- function(...) NULL
      env$abline <- function(...) NULL
      env$axis <- function(...) NULL
      env$par <- function(...) NULL
      env$points <- function(...) NULL
      env$lines <- function(...) NULL
      env$.arrows <- function(...) NULL
      env$text <- function(...) NULL
      env$strwidth <- function(...) NULL
      env$strheight <- function(...) NULL

      contribs <- paste0("Dimension ", 1:length(object$sv), " (",
        round(object$sv^2 / sum(object$sv^2) * 100, 1), "%)")[choices]

      res <- env$plot_ca(object, dim = choices, ...)

      rows <- as.data.frame(res$rows)
      rows$Type <- "rows"
      rows$Labels <- object$rownames
      cols <- as.data.frame(res$cols)
      cols$Type <- "cols"
      cols$Labels <- object$colnames
      res <- bind_rows(rows, cols)
      names(res) <- c("x", "y", "type", "labels")

      lims <- scale_axes(res, aspect.ratio = aspect.ratio)
      nudge <- (lims$x[2] - lims$x[1]) / 100

      res <- chart(data = res, y ~ x %col=% type %label=% labels) +
        geom_hline(yintercept = 0, col = "gray") +
        geom_vline(xintercept = 0, col = "gray") +
        coord_fixed(ratio = 1, xlim = lims$x, ylim = lims$y, expand = TRUE) +
        theme(legend.position = "none") +
        labs(x = contribs[1], y = contribs[2])

      if (isTRUE(repel)) {
        res <- res + geom_point() + ggrepel::geom_text_repel()
      } else {# Use text
        res <- res + geom_point() +
          geom_text(hjust = 0, vjust = 0, nudge_x = nudge, nudge_y = nudge)
      }
      res
    }
  )
  res
}
chart.ca <- function(data, choices = 1L:2L, ...,
  type = c("screeplot", "altscreeplot", "boiplot"), env = parent.frame())
  autoplot.ca(data, choices = choices, ..., type = type, env = env)
class(chart.ca) <- c("function", "subsettable_type")


# Exemples ----------------------------------------------------------------

## Couleur des yeux et des cheveux
# Analyse factorielle des correspondances sur tableau de contingence à 2 entrées
caith <- read("caith", package = "MASS")
caith
# read() transforme les données et crée une colonne "rownames" de manière
# explicite... C'est souvent une bonne idée, mais ici, nous voulons conserver
# cela vraiment sous forme de noms de lignes et pas sous forme de variable
# supplémentaire afin de pouvoir traiter tout le tableau comme un tableau de
# contingence à double entrée. La fonction `column_to_rownames()` se charge
# de rétablir les noms des lignes
caith <- column_to_rownames(caith, "rownames")
caith
# Quelques détails de calcul autour du chi2
sum(caith)
(.chi2 <- chisq.test(caith)); cat("Expected frequencies:\n"); .chi2$expected
# Calcul des composantes du Chi2. Les a_i sont les contribution observées, et les
# alpha_i sont les contributions théoriques sous H_0 (indépendance entre facteurs)
a_i <- caith
alpha_i <- .chi2$expected
# Les contributions au chi2 sont obtenues comme ceci
(a_i - alpha_i)^2 / alpha_i
# Notez que nous avons mainte nant des données quantitatives continues
# Nous faisons deux ACP dessus, une en ligne et une en colonne, puis un biplot

# AFC proprement dite
caith_ca <- ca(caith)
caith_ca
#summary(caith_ca)
chart$scree(caith_ca, fill = "cornsilk")
chart$altscree(caith_ca)
# Plus de 99% de l'inertie totale est sur les deux premières dimensions
#plot(caith_ca)
chart$biplot(caith_ca)
# Juste poiur montrer les options: axes 2 et 3, et aspect ratio de 3/4
chart$biplot(caith_ca, choices = c(2, 3), aspect.ratio = 3/4)


## Autre exemple : tableau espèces x stations (marbio)
# Un tableau espèces - station peut être vu comme un tableau de contingence
# à double entrées également
marbio <- read("marbio", package = "pastecs")
marbio
# Ici, on n'a même pas les numéros de stations => les rajouter manuellement
# sachant qu'elles sont dans l'ordre dans le tableau (1 = Nice, 68 = Calvi)
marbio %>.%
  mutate(., stations = 1:nrow(.)) %>.%
  column_to_rownames(., "stations") -> marbio
# AFC
marbio_ca <- ca(marbio)
marbio_ca
#summary(marbio_ca)
chart$scree(marbio_ca, fill = "cornsilk")
# Ici par contre, on n'a qu'un peu plus de 50% sur les deux premiers axes
# Il faut garder à l'esprit qu'une partie importante de l'information est perdue!
#plot(marbio_ca)
chart$biplot(marbio_ca)
# Comme ce graphique est super-encombré, on peut spécifier repel = TRUE, ...
# mais le temps de calcul est beaucoup plus long!
chart$biplot(marbio_ca, repel = TRUE)
# Juste pour voir... le graphique axes 1 et 3
chart$biplot(marbio_ca, choices = c(1, 3))
# Graphique en 3D interactif
plot3d(marbio_ca)


## Exemple en partant de deux variables facteurs
# Un questionnaire (4 questions A, B, C et D) avec des réponses entre
# 1 = tout-à-fait d'accord à 5 = pas du tout d'accord concernant l'attitude
# d'allemands (de l'ouest) envers la science est analysé (données de 1993)
# La version française du questionnaire est disponible [ici](https://dbk.gesis.org/dbksearch/download.asp?db=E&id=7987). Voir aussi https://dbk.gesis.org/dbksearch/sdesc2.asp?no=2450&search=issp%201993&search2=&field=all&field2=&DB=e&tab=0&notabs=&nf=1&af=&ll=10
# Les questions correspondent à la section 4\ :
# A = Les gens croient trop souvent à la science, et pas assez aux sentiments et à la foi
# B = En général, la science moderne fait plus de mal que de bien
# C = Tout changement dans la nature apporté par les êtres humains risque d'empirer les choses
# D = La science moderne va résoudre nos problèmes relatifs à l'environement sans faire de grands changements à notre mode de vie
#
# De plus,
# - le sexe (1 = homme, 2 = femme),
# - l'âge (1 = 18-24, 2 = 25-34, 3 = 35-44, 4 = 45-54, 5 = 55-64, 6 = 65+)
# - le niveau d'éducation (1 = primaire, 2 = second. partim, 3 = secondaire, 4 = univ. partim, 5 = univ. cycle 1, 6 = univ. cycle 2+)
# des répondants sont fournis
wg <- read("wg93", package = "ca")
wg
# Ceci est un tableau cas x variables avec 7 variables facteurs et 871 cas
# Nous réencodons les variables pour plus de clarté
wg %>.%
  mutate(.,
    A = recode(A, `1` = "++", `2` = "+", `3` = "0", `4` = "-", `5` = "--"),
    B = recode(B, `1` = "++", `2` = "+", `3` = "0", `4` = "-", `5` = "--"),
    C = recode(C, `1` = "++", `2` = "+", `3` = "0", `4` = "-", `5` = "--"),
    D = recode(D, `1` = "++", `2` = "+", `3` = "0", `4` = "-", `5` = "--"),
    sex = recode(sex, `1` = "H", `2`= "F"),
    age = recode(age, `1` = "18-24", `2` = "25-34", `3` = "35-44",
      `4` = "45-54", `5` = "55-64", `6` = "65+"),
    edu = recode(edu, `1` = "primaire", `2` = "sec. part", `3` = "secondaire",
      `4` = "univ. part", `5` = "univ. cycle 1", `6` = "univ. cycle 2")
  ) -> wg
wg

# Par exemple, si nous nous posons la question de l'impact de l'éducation sur
# l'impression que la science est néfaste (question B), nous pourrons faire :
# Table de contingence à double entrée
table(wg$B, wg$edu)
# Test du chi2
chisq.test(wg$B, wg$edu)
# Rejet de H_0 au seil alpha de 5%, il n'y a pas indépendance entre les réponses
# à la question B et le niveau d'éducation

# AFC
wg_b_edu <- ca(data = wg, ~ B + edu)
wg_b_edu
#summary(wg_b_edu)
chart$scree(wg_b_edu)
# Les deux premiers axes représentent plus de 88% de l'inertie totale
chart$biplot(wg_b_edu, choices = c(1, 2))
# Clairement, plus le niveau d'éducation est faible, moins les gens croient en
# les bienfaits de la science
