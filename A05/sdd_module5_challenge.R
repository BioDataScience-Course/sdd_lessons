# Challenge de SDD I module 5
# Date : 28-11-2022
# 
SciViews::R(lang = "fr")

# Datasets ----
iris <- read("iris", package = "datasets")
skimr::skim(iris)

urchin <- read("urchin_bio", package = "data.io")
skimr::skim(urchin)

zooplankton <- read("zooplankton", package = "data.io")
skimr::skim(zooplankton)

biometry <- read("biometry", package = "BioDataScience")
skimr::skim(biometry)

# Challenge ----

# Challenge 1

## Exclure setosa ?
names(iris)
(iris2 <- sfilter(iris, species != "setosa"))

# Challenge 2

# Selection des données relatives aux pétales
(iris2 %<-% select(iris, petal_length:petal_width))

# Challenge 3

# Sélection des hommes de moins de 25 ans dans biometry_m_25
biometry %>.%
  sfilter(., gender = "M") %>.%
  sfilter(., age < 25) %->%
  biometry_m_25

# Proposition d'une correction
biometry %>.%
  sfilter(., gender == "M") %>.%
  sfilter(., age < 25) ->
  biometry_m_25

# Challenge 4

# Récupérer toutes les colonnes sauf gender, weigth et wrist
biometry %>.%
  sselect(., -gender, -weight, -wrist) %->%
  biometry2

# Challenge 5

# Selectionner les colonnes 2 à 3, prendre les valeurs du diamètre inférieurs à 11
urchin %>.%
  select(., 2:3) %>.% 
  filter(., diameter1 < 11) -> 
  urchin2

# Proposition de corrections
urchin %>.%
  select(., 2:3) %>.% 
  filter(., diameter1 < 11) %->% 
  urchin2
 
urchin %>.%
  select(., 2:3) %>.% 
  filter(., diameter1 < 11) %>.%
  collect_dtx(.) -> 
  urchin2

# Challenge 6

# Selectionner uniquement les décapodes et les cirripèdes
zooplankton2 %<-% filter(zooplankton, !class %in% c("Decapod", "Cirriped"))

# Challenge 7

# Résumer les longueurs de sépales par expèces: moyenne et écart type (= SD)
iris %>.%
  group_by(., species) |> summarise(
    mean_sl = mean(sepal_length),
    sd_sl = sd(sepal_length)
  ) %->%
  iris2
iris2

# Challenge 8

# Filtrer les variables age et gender ET les individus de plus de 42 ans
biometry %>.%
  sfilter(., age > 42) %>.%
  sselect(., age, gender) %->%
  biometry2

# Challenge 9

# Compter les individus par classe
zooplankton %>.%
  sgroup_by(., class) %>.%
  ssummarise(., group = fn(class)) %->%
  zooplankton2
zooplankton2

# Challenge 10

# Calculer une nouvelle variable diameter (moyenne des diamètres) 
# et calculer la moyenne par origin
urchin %>.%
  smutate(., "diameter" = (diameter2+diameter1)/2) %>.%
  sgroup_by(., origin) |> ssummarise(mean = fmean(diameter)) ->
  urchin3
urchin3


# Challenge 11

# Calculer la moyenne de la masse immergée en fonction de l'origin
head(urchin)
urchin %>.%
  sgroup_by(., origin) |> ssummarise(mean = mean(buoyant_weight)) %->%
  urchin3
urchin3

# Proposition de corrections
urchin %>.%
  sgroup_by(., origin) |> ssummarise(mean = mean(buoyant_weight, na.rm = TRUE)) %->%
  urchin3
urchin3

urchin %>.%
  sgroup_by(., origin) |> ssummarise(
    mean = fmean(buoyant_weight),
    obs = fnobs(buoyant_weight),
    obs_na = fna(buoyant_weight),
    tot = fn(buoyant_weight)) %->%
  urchin3
urchin3


# Challenge 12

# Réordonner les colonnes et calculer le log de la variable "petal_length"
iris2 %<-% mutate(select(iris, species, sepal_length:petal_width),
  petal_log = log(petal_length))

# Proposition de corrections
iris2 %<-% select(iris, species, sepal_length:petal_width)
iris2 %<-% mutate(iris2, petal_log = log(petal_length))

iris %>.%
  select(., species, sepal_length:petal_width) %>.%
  mutate(., petal_log = log(petal_length)) %->%
  iris2

# Challenge 13

# Créer une variable facteur qui scinde les données en deux groupes d'âge
biometry2 <- biometry
#biometry2$age_rec <- as.factor(cut(biometry2$age, include.lowest = FALSE,
#   right = FALSE, breaks = c(14, 27, 90)
#table(biometry2$age_rec)

# Proposition d'une correction
biometry2$age_rec <- as.factor(cut(biometry2$age, include.lowest = FALSE,
  right = FALSE, breaks = c(14, 27, 90)))
table(biometry2$age_rec)

# Challenge 14

# Restreindre le tableau et calculer moyenne, écart type et nombre de données pour size
zooplankton %>.%
  sselect(., area, ecd, class) %>.%
  sgroup_by(., class) |> ssummarise(
    mean = fmean(size),
    sd   = fsd(size),
    n    = fnobs(size)
  )

# Proposition d'une correction
zooplankton %>.%
  sselect(., area, ecd, size, class) %>.%
  sgroup_by(., class) |> ssummarise(
    mean = fmean(size),
    sd   = fsd(size),
    n    = fnobs(size)
  )

# Challenge 15

# Calculer la moyenne par espèce de toutes les variables sauf species
sgroup_by(iris, species) |> fmean(na.rm = FALSE)
