# Exercice 2 Marbio

library(pastecs)
data("marbio")
log(marbio + 1) -> logmarbio

#dendrogrammes
library(vegan)
vegdist(logmarbio, method = "bray") -> braymarbio
hclust(braymarbio, method = "complete") -> complete
plot(complete)
hclust(braymarbio, method = "median") -> median
plot(median)
hclust(braymarbio, method = "single") -> single
plot(single)

#graphes
par(mfrow = c (2,1))
plot(marbio$Acartia, type = "l")
plot(marbio$AdultsOfCalanus, type = "l")
par(mfrow = c (2,3))
plot(marbio$Copepodits1, type = "l")
plot(marbio$Copepodits2, type = "l")
plot(marbio$Copepodits3, type = "l")
plot(marbio$Copepodits4, type = "l")
plot(marbio$Copepodits5, type = "l")
par(mfrow = c (2,2))
plot(marbio$ClausocalanusA, type = "l")
plot(marbio$ClausocalanusB, type = "l")
plot(marbio$ClausocalanusC, type = "l")
par(mfrow = c (2,2))
plot(marbio$AdultsOfCentropages, type = "l")
plot(marbio$JuvenilesOfCentropages, type = "l")
plot(marbio$Nauplii, type = "l")
plot(marbio$Oithona, type = "l")
par(mfrow = c (2,1))
plot(marbio$Acanthaires, type = "l")
plot(marbio$Cladocerans, type = "l")
par(mfrow = c (2,2))
plot(marbio$EchinodermsLarvae, type = "l")
plot(marbio$DecapodsLarvae, type = "l")
plot(marbio$GasteropodsLarvae, type = "l")
plot(marbio$EggsOfCrustaceans, type = "l")
par(mfrow = c (2,2))
plot(marbio$Ostracods, type = "l")
plot(marbio$Pteropods, type = "l")
plot(marbio$Siphonophores, type = "l")
plot(marbio$BellsOfCalycophores, type = "l")

#coupures
par(mfrow = c (1,1))
hclust(braymarbio, method = "complete") -> complete
plot(complete)
abline(h = 0.5, col = "red")
abline(h = 0.25, col = "red")
abline(h = 0.2, col = "red")
