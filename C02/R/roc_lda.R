# ROC curve
library(ROCR)
# Works only with a two-class problem. So, try only to separate versicolor and
# virginica for the iris dataset
data(iris)
iris2 <- dplyr::filter(iris, Species != "setosa")
summary(iris2)
levels(iris2$Species)
iris2$Species <- droplevels(iris2$Species)
levels(iris2$Species)

# Use LDA to classify these items
library(mlearning)
iris2_lda <- mlLda(Species ~ ., data = iris2)
iris2_lda
summary(iris2_lda)
iris2_conf <- confusion(cvpredict(iris2_lda, cv.k = 10), iris2$Species)
iris2_conf
plot(iris2_conf)
summary(iris2_conf)

pred <- prediction(as.numeric(predict(iris2_lda)), iris2$Species)

# Classical ROC curve
perf <- performance(pred, "tpr", "fpr")
plot(perf); abline(a = 0, b = 1, col = "gray")

