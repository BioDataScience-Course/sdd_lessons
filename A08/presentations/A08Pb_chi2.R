# Génération de graphiques pour les tests relatif au Wooclap module 8
# Chi-square distribution (density probability) with parameter:
.df <- 3 # Degree of freedom .df
.col <- 1; .add <- FALSE # Plot parameters
.x <- seq(0, qchisq(0.999, df = .df), l = 1000)  # Quantiles
.d <- function (x) dchisq(x, df = .df)           # Distribution function
.q <- function (p) qchisq(p, df = .df)           # Quantile for lower-tail prob
.label <- bquote(paste(chi^2,(.(.df))))          # Curve parameters
curve(.d(x), xlim = range(.x), xaxs = "i", n = 1000, col = .col,
  add = .add, xlab = "Quantiles", ylab = "Probability density") # Curve
abline(h = 0, col = "gray") # Baseline

# Upper-tail probability (right area)
.p2 <- 0.05; .x2 <- .x[.x >= .q(1 - .p2)]
polygon(c(.x2, max(.x2), min(.x2)), .d(c(.x2, -Inf, -Inf)),
  border = .col, col = "salmon")

abline(v = 7, lty = "dashed", lwd = 2, col = "red") # Vertical line(s)

text(6.5, 0.01, label = expression(chi[obs]^2), col = "red")

text(12, 0.20, label = "Rejet de H0")
text(12, 0.12, label = "Non rejet de H0")
