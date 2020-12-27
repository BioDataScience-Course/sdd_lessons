# Plot the domain for each class in a scatterplot (LDA method)

# predplot() function inspired from MASS, chap. 12, p. 340
# adapted to iris, using only petal data as attributes
iris_p <- iris[, 3:5]

library(mlearning)
iris_p_lda <- mlLda(Species ~ ., data = iris_p)
iris_p_lda
summary(iris_p_lda)
plot(iris_p_lda, col = as.numeric(response(iris_p_lda)) + 1)

predplot <- function(object, main = "", len = 100, ...) {
  plot(iris_p[, 1], iris_p[, 2], type = "n", #log = "xy",
    xlab = "Petal.Length", ylab = "Petal.Width", main = main)
  for (il in 1:3) {
    set <- iris_p$Species == levels(iris_p$Species)[il]
    text(iris_p[set, 1], iris_p[set, 2],
      labels = substr(as.character(iris_p$Species[set]), 1, 3), col = 1 + il)
  }
  xp <- seq(1, 7, length = len)
  yp <- seq(0, 2.5, length = len)
  irisT <- expand.grid(Petal.Length = xp, Petal.Width = yp)
  Z <- predict(object, irisT, type = "both",...)
  zp <- as.numeric(Z$class)
  zp <- Z$membership[, 3] - pmax(Z$membership[, 2], Z$membership[, 1])
  contour(xp, yp, matrix(zp, len), add = TRUE, levels = 0, labex = 0)
  zp <- Z$membership[, 1] - pmax(Z$membership[, 2], Z$membership[, 3])
  contour(xp, yp, matrix(zp, len), add = TRUE, levels = 0, labex = 0)
  invisible()
}
predplot(iris_p_lda)
