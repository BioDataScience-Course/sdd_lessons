data("mtcars", package = "datasets")
data = mtcars[, 1:3]
str(data)

library("mlr3")

task_mtcars = TaskRegr$new(id = "cars", backend = data, target = "mpg")
print(task_mtcars)

library("mlr3viz")
autoplot(task_mtcars, type = "pairs")

mlr_tasks
library("data.table")
as.data.table(mlr_tasks)

task_iris = mlr_tasks$get("iris")
print(task_iris)

tsk("iris")

task_iris$nrow
task_iris$ncol
task_iris$data()

head(task_iris$row_ids)

task_iris$data(rows = c(1, 51, 101))

task_iris$feature_names
task_iris$target_names
task_iris$data(rows = c(1, 51, 101), cols = "Species")

summary(as.data.table(task_iris))

print(task_mtcars$col_roles)
