# Transformée log()!
data(iris)
summary(iris)

# 2D plot of iris
plot(Petal.Length ~ Petal.Width, data = iris)
# A better one...
plot(Petal.Length ~ Petal.Width, data = iris, col = c("red", "green", "blue")[iris$Species])

# 3D plot of iris
library(car)
scatter3d(iris$Petal.Length, iris$Sepal.Length, iris$Sepal.Width, surface =
	FALSE, point.col = (2:4)[iris$Species])

# More than 3D... scatterplot matrix
pairs( ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width, data = iris)
# A better one...
require(car)
scatterplotMatrix( ~ Petal.Length + Petal.Width + Sepal.Length + Sepal.Width | Species,
	reg.line = lm, smooth = TRUE, span = 0.5, diagonal = 'density', by.groups = TRUE, data = iris)

# ACP without scaling variables
library(SciViews)
iris.pcomp <- pcomp( ~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width,
	data = iris, scale = FALSE)
summary(iris.pcomp, loadings = FALSE, cutoff = 0.1)
screeplot(iris.pcomp, type = "barplot", col = "cornsilk", main = "")

plot(iris.pcomp, which = "scores", choices = 1:2, labels = NULL, cex = 1, main = "")
plot(iris.pcomp, which = "scores", choices = 1:2, labels = c("Se", "Vi", "Ve")[iris$Species],
	col = c("red", "green", "blue")[iris$Species], cex = 0.9, main = "")

summary(iris.pcomp, loadings = TRUE, cutoff = 0)
#dev.new()
plot(iris.pcomp, which = "load", choices = 1:2, col = "black", cex = 1, pos = 1)
biplot(iris.pcomp, choices = 1:2, scale = 1, pc.biplot = TRUE, cex = 1)
abline(h = 0, col = "gray"); abline(v = 0, col = "gray")


# PCA with scale == TRUE
iris.pca <- pcomp(iris[, -5], scale = TRUE)

iris.pca.loadings <- loadings(iris.pca)
print(iris.pca.loadings, sort = FALSE, cutoff = 0, digits = 3)
summary(iris.pca)

#iris.pca.scores <- scores(iris.pca, dim = 3, labels = NULL)
#iris.pca.scores
#dev.new()
screeplot(iris.pca, type = "barplot", col = "cornsilk", main = "")

plot(iris.pca, which = "scores", choices = 1:2, labels = c("Se", "Vi", "Ve")[iris$Species],
	col = c("red", "green", "blue")[iris$Species], cex = 0.9, main = "")
#dev.new()
plot(iris.pca, which = "load", choices = 1:2, col = "black", cex = 1, pos = 1)


