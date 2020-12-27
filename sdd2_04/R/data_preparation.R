# data
SciViews::R
# speed_reaction ----------------------------------------------------------

## import data
vr <- read("sdd2_16/data/raw/vitesse_reaction.csv")
## rename and labelise data
vr %>.%
  rename(., conc = concentration, speed = vitesse) %>.%
  labelise(., as_labelled = FALSE,
           label = list(conc = "Concentration",
                        speed = "Vitesse de réaction")) -> vr
## save data
write(vr, file ="sdd2_16/data/speed_reaction.rds", type = "rds")

# algae -------------------------------------------------------------------

algae <- read("sdd2_16/data/raw/algae.csv")

algae <- labelise(algae, as_labelled = FALSE,
                  label = list(conc = "Concentration",
                               vol = "Volume"))
## save data
write(algae, file ="sdd2_16/data/algae.xlsx", type = "xlsx")


# reygrass ----------------------------------------------------------------

ryegrass <- read(file = "sdd2_16/data/raw/ryegrass.csv")
write(ryegrass, file ="sdd2_16/data/ryegrass.csv", type = "csv")


# Croissance_bacterie -----------------------------------------------------

growthcurve <- read("sdd2_16/data/raw/croissance_bacterie.csv")

growthcurve <- rename(growthcurve, time = t,
                      growth_log = LOG10N)

write(growthcurve, file = "sdd2_16/data/growth_curve.tsv", type = "tsv")
