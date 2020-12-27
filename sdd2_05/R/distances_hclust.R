# Distance matrix and hierachical clustering example
# Copyright (c) 2010-2018, Ph. Grosjean

SciViews::R


# marphy dataset ----------------------------------------------------------
marphy <- read("marphy", package = "pastecs")
summary(marphy)
marphy

marphy2 <- marphy[c(1, 20, 35, 50, 65), ]
marphy2_dist <- dist(marphy2, method = "euclidean")
marphy2_dist
plot(hclust(marphy2_dist, method = "single"))
plot(hclust(marphy2_dist, method = "complete"))

summary(marphy_dist <- dist(marphy, method = "euclidean"))
marphy_dist
(marphy_hclust <- hclust(marphy_dist, method = "complete"))
plot(marphy_hclust, hang = 0.1, col = "black", cex = 1, ann = TRUE)

(marphy_hclust2 <- hclust(marphy_dist, method = "single"))
plot(marphy_hclust2, hang = 0.1, col = "black", cex = 1, ann = TRUE)

(marphy_hclust2 <- hclust(marphy_dist, method = "median"))
plot(marphy_hclust2, hang = 0.1, col = "black", cex = 1, ann = TRUE)

plot(marphy_hclust, hang = 0.1, col = "black", cex = 1, ann = FALSE)
title("Regroupement des stations par liens complets", sub = "")
abline(h = 0.48, col = "red", lty = "solid", lwd = 2)
.grlist <- rect.hclust(marphy_hclust, k = 4, which = NULL, border = "red")

(marphy$groups <- cutree(marphy_hclust, k = 4))


# iris dataset ------------------------------------------------------------
iris <- read("iris", package = "datasets")
head(iris)
iris2 <- iris[, 1:4]
iris2
summary(iris_dist <- dist(iris2, method = "euclidean"))
(iris_hclust <- hclust(iris_dist, method = "complete"))
plot(iris_hclust, hang = 0.1, col = "black", cex = 0.8, ann = TRUE)

iris_dist <- vegan::vegdist(iris[, -5], method = "euclidean", na.rm = FALSE)
summary(iris_dist)
(iris_hclust <- hclust(iris_dist, method = "complete"))

plot(iris_hclust, labels = NULL, hang = 0.1, col = "black", cex = 1,
	ann = TRUE, main = "Cluster Dendrogram",
	sub = "subtitle", xlab = "Test", ylab = "Height")

plot(iris_hclust, hang = 0.1, col = "black", cex = 1, ann = FALSE)
abline(h = 3, col = "red", lty = "dotdash", lwd = 2)
rect.hclust(iris_hclust, h = 3, which = NULL, border = "red")
rect.hclust(iris_hclust, k = 2, which = NULL, border = "blue")
(iris$groups3 <- cutree(iris_hclust, h = 3))
(iris$groups2 <- cutree(iris_hclust, k = 2))
table(as.data.frame(cutree(iris_hclust, k = c(2, 3))))

table(iris$species, cutree(iris_hclust, k = 4))

# Another clustering method
(iris_hclust <- hclust(iris_dist, method = "average"))
plot(iris_hclust, hang = 0.1, cex = 0.8, ann = FALSE)
abline(h = 2.5, col = "red", lty = "dotdash", lwd = 2)
rect.hclust(iris_hclust, h = 2.5, which = 1, border = "red")
(iris$groups_h2.5 <- cutree(iris_hclust, h = 2.5))
(iris$groups3 <- cutree(iris_hclust, k = 3))

# To identify items with the mouse...
identify(iris_hclust, function(k) print(table(iris$species[k])))


# Represent groups on a PCA -----------------------------------------------
## TODO later on, when studying PCA
# Identify groups on a PCA scores plot
iris <- read("iris", package = "datasets")
iris2 <- iris[, 1:4]
iris2
summary(iris_dist <- dist(iris2, method = "euclidean"))
(iris_hclust <- hclust(iris_dist, method = "complete"))
plot(iris_hclust, hang = 0.1, col = "black", cex = 0.8, ann = TRUE)
rect.hclust(iris_hclust, k = 3, border = "red")
(iris$groups <- cutree(iris_hclust, k = 3))
#table(as.data.frame(cutree(iris_hclust, k = c(2, 3))))

iris_pca <- pcomp(iris[, -5], scale = TRUE)
plot(iris_hclust, hang = 0.1, col = "black", cex = 0.8, ann = TRUE)
(iris$groups <- cutree(iris_hclust, k = 3))
rect.hclust(iris_hclust, k = 3, border = (.col <- 2:8))

plot(iris_pca, which = "scores", choices = 1:2, labels = iris$groups,
	col = .col[as.integer(iris$groups)], cex = 1, main = "")

plot(iris_pca, which = "scores", choices = 1:2,
  labels = c("Se", "Vi", "Ve")[iris$species],
	col = .col[as.integer(iris$groups)], cex = 1, main = "")
