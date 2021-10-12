SciViews::R

# resid 0 ----
set.seed(42)
df <- tibble(
  x = seq(10, 50, by = 0.5),
  y = 0.5*x + rnorm(length(x), sd = 0.5))

chart(data = df, y ~ x) +
  geom_point()

lm. <- lm(data = df, y ~ x)

lm. %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

# plot(lm., which = 2)
lm. %>.% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

#plot(lm., which = 3)
lm. %>.% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

#plot(lm., which = 4)
lm. %>.%
  chart(broom::augment(.), .cooksd ~ seq_along(.cooksd)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = seq(0, 0.1, by = 0.05), colour = "darkgray") +
  labs(x = "Obs. number", y = "Cook's distance") +
  ggtitle("Cook's distance")


# resid 1 ----
set.seed(42)
df <- tibble(
  x = seq(10, 50, by = 0.5),
  y = 0.5*x + rnorm(length(x), sd = 2))

chart(data = df, y ~ x) +
  geom_point()

lm. <- lm(data = df, y ~ x)

lm. %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

# plot(lm., which = 2)
lm. %>.% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

#plot(lm., which = 3)
lm. %>.% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

#plot(lm., which = 4)
lm. %>.%
  chart(broom::augment(.), .cooksd ~ seq_along(.cooksd)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = seq(0, 0.1, by = 0.05), colour = "darkgray") +
  labs(x = "Obs. number", y = "Cook's distance") +
  ggtitle("Cook's distance")

# resid 2 ----
set.seed(42)
df <- tibble(
  x = seq(10, 50, by = 0.5),
  y = (0.5 + seq(0, 0.5, length.out = length(x))) * x + rnorm(length(x), sd = 2))

chart(data = df, y ~ x) +
  geom_point()

lm. <- lm(data = df, y ~ x)

lm. %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

#plot(lm., which = 2)
lm. %>.% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

#plot(lm., which = 3)
lm. %>.% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

# resid 3 ----
set.seed(43)
df <- tibble(
  x = seq(10, 50, by = 0.5),
  y = 0.5* x + rnorm(length(x), sd = seq(0.5, 10, length.out = length(x))))

chart(data = df, y ~ x) +
  geom_point()

lm. <- lm(data = df, y ~ x)

lm. %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

#plot(lm., which = 2)
lm. %>.% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

#plot(lm., which = 3)
lm. %>.% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")


# resid 4 ----
set.seed(42)
df <- tibble(
  x = seq(-10,10,0.1),
  y = sin(x) + rnorm(length(x), sd = 0.5) + seq(0, 10, length.out = length(x)))

chart(data = df, y ~ x) +
  geom_point()

lm. <- lm(data = df, y ~ x)

lm. %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

#plot(lm., which = 2)
lm. %>.% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

#plot(lm., which = 3)
lm. %>.% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")


# resid 5 ----
set.seed(42)
df <- tibble(
  x = seq(20, 100,0.5),
  y = 0.4*x + rnorm(length(x), sd = 3))
df$y[130] <- 60

chart(data = df, y ~ x) +
  geom_point()

lm. <- lm(data = df, y ~ x)

lm. %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

#plot(lm., which = 2)
lm. %>.% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

#plot(lm., which = 3)
lm. %>.% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")


# resid 6 ----
set.seed(42)
df <- tibble(
  x = rnorm(50),
  y = rnorm(length(x), sd = 3))
df$y[50] <- 10
df$x[50] <- 10

chart(data = df, y ~ x) +
  geom_point()

lm. <- lm(data = df, y ~ x)

lm. %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

#plot(lm., which = 2)
lm. %>.% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

#plot(lm., which = 3)
lm. %>.% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")


# resid 7 ----
set.seed(42)
df <- tibble(
  x = seq(20, 70, by = 0.5),
  y = 0.1*x + rnorm(length(x), sd = 0.1))

chart(data = df, y ~ x) +
  geom_point()

lm. <- lm(data = df, y ~ x)

lm. %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

# plot(lm., which = 2)
lm. %>.% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

#plot(lm., which = 3)
lm. %>.% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

#plot(lm., which = 4)
lm. %>.%
  chart(broom::augment(.), .cooksd ~ seq_along(.cooksd)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = seq(0, 0.1, by = 0.05), colour = "darkgray") +
  labs(x = "Obs. number", y = "Cook's distance") +
  ggtitle("Cook's distance")

# resid 8 ----
set.seed(42)
df <- tibble(
  x = seq(20, 70, by = 0.5),
  y = 0.1*x + rnorm(length(x), sd = 2))

chart(data = df, y ~ x) +
  geom_point()

lm. <- lm(data = df, y ~ x)

lm. %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

# plot(lm., which = 2)
lm. %>.% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

#plot(lm., which = 3)
lm. %>.% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

#plot(lm., which = 4)
lm. %>.%
  chart(broom::augment(.), .cooksd ~ seq_along(.cooksd)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = seq(0, 0.1, by = 0.05), colour = "darkgray") +
  labs(x = "Obs. number", y = "Cook's distance") +
  ggtitle("Cook's distance")


# resid 9 ----
set.seed(42)
df <- tibble(
  x = seq(20, 70, by = 0.5),
  y = 0.1*x+ rlnorm(length(x)))

chart(data = df, y ~ x) +
  geom_point()

lm. <- lm(data = df, y ~ x)

lm. %>.%
  chart(broom::augment(.), .resid ~ .fitted) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE, method = "loess", formula = y ~ x) +
  labs(x = "Fitted values", y = "Residuals") +
  ggtitle("Residuals vs Fitted")

# plot(lm., which = 2)
lm. %>.% qplot(sample = .stdresid, data = .) +
  geom_abline(intercept = 0, slope = 1, colour = "darkgray") +
  xlab("Theoretical quantiles") +
  ylab("Standardized residuals") +
  ggtitle("Normal Q-Q")

#plot(lm., which = 3)
lm. %>.% qplot(.fitted, sqrt(abs(.stdresid)), data = .) +
  geom_smooth(se = FALSE) +
  xlab("Fitted values") +
  ylab(expression(bold(sqrt(abs("Standardized residuals"))))) +
  ggtitle("Scale-Location")

#plot(lm., which = 4)
lm. %>.%
  chart(broom::augment(.), .cooksd ~ seq_along(.cooksd)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = seq(0, 0.1, by = 0.05), colour = "darkgray") +
  labs(x = "Obs. number", y = "Cook's distance") +
  ggtitle("Cook's distance")
