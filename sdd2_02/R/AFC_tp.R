obs <- data.frame(station = c("st1", "st2", "st3", "st1", "st2", "st3", "st1", "st2", "st3"),
                  species = c("spA", "spA", "spA", "spB", "spB", "spB", "spC", "spC", "spC"),
                  freq = c(4, 2, 1, 1, 1, 6, 3, 3, 2))

obs.Table <- xtabs(freq ~ station + species, data =
                     obs)
knitr::kable(obs.Table)
