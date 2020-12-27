# Script écrit par François Husson, voir https://www.dailymotion.com/video/x13gva9
library(FactoMineR)

?MFA

data(wine)
res <- MFA(wine, group=c(2,5,3,10,9,2), type=c("n",rep("s",5)),
    ncp=5, name.group=c("orig","smell","vis","smellAf","tasting","pref"),
    num.group.sup=c(1,6))

# A summary of the main results with the summary.MFA function
summary(res)

# Graph of the individuals and categories
plot(res)
plot(res, invisible="quali")
plot(res, invisible="quali", cex=0.8)
plot(res, invisible="quali", cex=0.8, partial=c("1VAU","PER1"))
plot(res, ,invisible="quali", partial="all", palette=palette(c("black","transparent","transparent","blue","transparent")))

# Selection in the graph of the individuals and categories
plot(res, invisible="quali", cex=0.8, select="cos2 0.4")
plot(res, invisible="quali", habillage=1, cex=0.8, select="cos2 0.4")
plot(res, invisible="quali", habillage="Soil", cex=0.8, select="cos2 0.4")
plot(res, invisible="quali", habillage="Soil", cex=0.8, select="contrib 5")
plot(res, invisible="quali", habillage="Soil", cex=0.8, select="contrib 5", unselect=0)
plot(res, invisible="quali", habillage="Soil", cex=0.8, select="contrib 5", unselect=1)
plot(res, invisible="quali", habillage="Soil", cex=0.8, select="contrib 5", unselect="grey70")
plot(res, invisible="quali", habillage="Soil", cex=0.8, select="contrib 5", unselect="grey70", axes=3:4)
plot(res, invisible="quali", habillage="Soil", cex=0.8, select=c("1VAU","PER1"), unselect="grey70", axes=3:4)

# Graph of the variables
plot(res, choix="var")
plot(res, choix="var", shadow=TRUE,cex=0.8)
plot(res, choix="var", shadow=TRUE, select="contrib 5",cex=0.8)
plot(res, choix="var", shadow=TRUE, select="contrib 5", axes=3:4,cex=0.8)

# Graph of the partial axes
res <- MFA(wine, group=c(2,5,3,10,9,2), type=c("n",rep("s",5)),
    ncp=3, name.group=c("orig","smell","vis","smellAf","tasting","pref"),
    num.group.sup=c(1,6))
plot(res, choix="axes")

# Description of dimensions
dimdesc(res)

