# Graphiques quantile-quantile de différentes distributions
# Copyright (c) 2023, Ph. Grosjean <phgrosjean@sciviews.org> & G. Enngels

SciViews::R("infer", lang = "fr")


# Distribution Normale ----------------------------------------------------

N1 <- dist_normal(mu = 1, sigma = 0.5)
chart(N1)

N1s1 <- generate(N1, 1000)[[1]]
qqnorm(N1s1); qqline(N1s1)

N1s2 <- generate(N1, 100)[[1]]
qqnorm(N1s2); qqline(N1s2)

N1s3 <- generate(N1, 30)[[1]]
qqnorm(N1s3); qqline(N1s3)

N1s3 <- generate(N1, 10)[[1]]
qqnorm(N1s3); qqline(N1s3)


# Distribution plus étroite: Student t, ddl=2 -----------------------------

T1 <- dist_student_t(df = 2, mu = 1, sigma = 0.5)
chart(T1)

T1s1 <- generate(T1, 1000)[[1]]
qqnorm(T1s1); qqline(T1s1)

T1s2 <- generate(T1, 100)[[1]]
qqnorm(T1s2); qqline(T1s2)

T1s3 <- generate(T1, 30)[[1]]
qqnorm(T1s3); qqline(T1s3)

T1s4 <- generate(T1, 10)[[1]]
qqnorm(T1s4); qqline(T1s4)


# Distribution asymétrique: log-Normale -----------------------------------

lN1 <- dist_lognormal(mu = 1, sigma = 0.5)
chart(lN1)

lN1s1 <- generate(lN1, 1000)[[1]]
qqnorm(lN1s1); qqline(lN1s1)

lN1s2 <- generate(lN1, 100)[[1]]
qqnorm(lN1s2); qqline(lN1s2)

lN1s3 <- generate(lN1, 30)[[1]]
qqnorm(lN1s3); qqline(lN1s3)

lN1s4 <- generate(lN1, 10)[[1]]
qqnorm(lN1s4); qqline(lN1s4)
