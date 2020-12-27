library(readr)
calvi <- read_csv("../data/plancton_set_calvi.csv")
#View(calvi)
calvi <- as.data.frame(calvi)
calvi$Class <- as.factor(calvi$Class)
library(mlearning)
calvi_nnet <- mlNnet(Class ~ ., data = calvi, maxit = 2000)
calvi_conf <- confusion(cvpredict(calvi_nnet, cv.k = 10), calvi$Class)
calvi_conf # Error env. 11%


calvi_lda <- mlLda(Class ~ ., data = calvi)
calvi_conf2 <- confusion(cvpredict(calvi_lda, cv.k = 10), calvi$Class)
calvi_conf2 # Error 13.5%

calvi_rf <- mlRforest(Class ~ ., data = calvi)
calvi_conf3 <- confusion(cvpredict(calvi_rf, cv.k = 10), calvi$Class)
calvi_conf3 # Error 8.5%
