# Analyse plankton1.csv
library(readr)
plankton1 <- read_csv(
  "~/Documents/EcoNum/Cours/2017-2018/Biostat3_Ma1/Cours07/TP/plankton1.csv",
  col_types = cols(Class = col_factor(
    levels = c("Calanoida", "Chaetognatha", "Oncaeidae")
  ))
)
View(plankton1)
library(mlearning)
pl_lda <- mlLda(Class ~ ., data = plankton1)

plankton2 <- plankton1
plankton2$Species <- plankton2$Class
plankton2$Class <- NULL
pl_lda <- mlLda(Species ~ ., data = plankton2)
