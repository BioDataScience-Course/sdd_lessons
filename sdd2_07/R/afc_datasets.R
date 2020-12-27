SciViews::R
source("sdd2_07/preparation/sciviews_ca.R")

library(vegan)
# Jeu de données pour présenter l'ACF aux étudiants
#
# FISH -----------------------
data(doubs, package = "ade4")

fish <- doubs$fish

fish %>.%
  mutate(., stations = 1:nrow(.)) %>.%
  column_to_rownames(., "stations") -> fish

skimr::skim(fish)

range(fish) # Données semi-quantitatives

fish %>.%
  gather(., key = "species", value = "n") %>.%
  mutate(., station = rep(1:nrow(fish), ncol(fish))) %>.%
  chart(., species ~ station %fill=% n) +
    geom_raster()

# Il n'y a pas d'espèces rares, mais des station où il y a plus ou moins de tout. Sauf à la station 8 qui ne contient rien => à éliminer
# Graphique pas adapté ici! -> boxplot(fish)
rowSums(fish)
colSums(fish)

# Test Chi2 d'indépendence (pas applicable)
#chisq.test(fish[-8, ]) # H_0 rejetté => dépendence

# AFC
fish_ca <- ca(fish[-8, ])
summary(fish_ca, scree = TRUE, rows = FALSE, columns = FALSE)

chart$scree(fish_ca, fill = "cornsilk")
# 64% sur les 2 premiers axes

chart$biplot(fish_ca, choices = c(1, 2))
chart$biplot(fish_ca, choices = c(1, 2), repel = TRUE)
# Progression le long d'une rivière avec 3 états associés à différentes espèces de poissons
# Station 1 - 12 (Neba, Phph et Satr), puis 13-18 (Thth, Cogo & Teso) et le reste

# mite --------------------------
mite <- read("mite", package = "vegan")
skimr::skim(mite)

rowSums(mite)
colSums(mite)

mite %>.%
  gather(., key = "species", value = "n") %>.%
  chart(., n ~ species) +
    geom_boxplot() +
  coord_flip()

# Il y a des grandes disparités entre espèces, utilisation de log1p()
mite2 <- log1p(mite)
# Ajouter le nom des lignes explicitement
rownames(mite2) <- 1:nrow(mite2)

mite2 %>.%
  gather(., key = "species", value = "log_n_1") %>.%
  chart(., log_n_1 ~ species) +
  geom_boxplot() + coord_flip()
# C'est mieux

# Test Chi2 pas applicable
#chisq.test(mite2)

# AFC
mite2_ca <- ca(mite2)
summary(mite2_ca, scree = TRUE, rows = FALSE, columns = FALSE)

chart$scree(mite2_ca, fill = "cornsilk")
# Seulement 43% sur les 2 premiers axes, mais le gain n'est que très progressif après => relativement OK

# Biplot
chart$biplot(mite2_ca, choices = c(1, 2), repel = TRUE)
# Au final, bon jeu de données, mais évidemment difficile à interpréter quand on
# ne connait rien des mites ou des stations d'où elles proviennent! On voit que même
# lorsque H_0 n'est pas rejetté, il y a des choses intéressantes à sortir!


# rpjdl -------------------
# Il s'agit du jeu de données qui présente le plus simplement l'ACF
data(rpjdl, package = "ade4") # Je n'aime pas les datasets sous forme de listes
# que l'on ne peut pas lire avec read()!
fau <- rpjdl$fau

# Données présence-absence
range(fau)

rowSums(fau)
colSums(fau)

# Données présence absence idotes à représentées en boxplot!
fau %>.%
  gather(., key = "species", value = "n", factor_key = TRUE) %>.%
  mutate(., station = rep(1:nrow(fau), ncol(fau))) %>.%
  chart(., species ~ station %fill=% n) +
  geom_raster()

# Test Chi2 pas applicable sur ce genre de données
#chisq.test(fau)

fau_ca <- ca(fau)
summary(fau_ca, scree = TRUE, rows = FALSE, columns = FALSE)
# Seulement 23% sur les 2 premiers axes... personnellement, je n'irais pas beaucoup plus loin ici!

chart$scree(fau_ca, fill = "cornsilk")
chart$biplot(fau_ca, choices = c(1, 2))
#chart$biplot(fau_ca, choices = c(1, 2), repel = TRUE)


# atlas -------------------------
data(atlas, package = "ade4")

birds <- atlas$birds

range(birds) # Semi-quantitatif

rowSums(birds)
colSums(birds)

# Données semi-quanrtitatives idotes à représentées en boxplot!
birds %>.%
  gather(., key = "species", value = "n", factor_key = TRUE) %>.%
  mutate(., station = rep(1:nrow(birds), ncol(birds))) %>.%
  chart(., species ~ station %fill=% n) +
  geom_raster()

# Test Chi2 pas applicable
#chisq.test(birds)

birds_ca <- ca(birds)
summary(birds_ca, scree = TRUE, rows = FALSE, columns = FALSE)
# 64% sur les 2 premiers axes

chart$scree(birds_ca, fill = "cornsilk")

chart$biplot(birds_ca, choices = c(1, 2), repel = TRUE)
# Fauvette mélanocéphale, Fauvette pitchou et Fauvette passerinette pratiquement présentes seulement en la station S22
# Le reste est moins facile à analyser. Ceci ressemble très fort à marbio...

# Caith
# Jeu de données utilisé les années précédentes pour le cours théorique.
# ... et continuera à l'être comme première approche!
data(caith)
caith_ca <- ca(caith)
chart$scree(caith_ca, fill = "cornsilk")
chart$biplot(caith_ca)
